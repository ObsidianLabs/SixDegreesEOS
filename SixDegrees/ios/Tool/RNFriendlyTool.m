//
//  RNFriendlyTool.m
//  SixDegrees
//
//  Created by Zehao Li on 2018/11/11.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "RNFriendlyTool.h"
#import "GlobalTool.h"

#define ROOT_VC [UIApplication sharedApplication].delegate.window.rootViewController

static RNFriendlyTool *instance = nil;

@interface RNFriendlyTool ()<MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UIViewController *fromViewController;

@end

@implementation RNFriendlyTool

+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (instance == nil) {
      instance = [[self alloc] init];
    }
  });
  return instance;
}

- (NSString *)generateMessageBodyByData:(NSDictionary *)messageData {
  NSString *msg = [messageData objectForKey:@"msg"];
  NSString *link = [messageData objectForKey:@"link"];
  NSString *url = [NSString stringWithFormat:@"six://link?x=%@", [GlobalTool base64EncodeString:link]];
  NSString *message = [NSString stringWithFormat:@"%@ %@", msg, url];
  return message;
}

- (void)sendMessageWithData:(NSDictionary *)data {
  NSString *message = [self generateMessageBodyByData:data];
  [self showMessageToPhones:@[] title:@"" body:message];
}

- (void)showMessageToPhones:(NSArray *)phones title:(NSString *)title body:(NSString *)body fromViewController:(UIViewController *)fromViewController messageComposeDelegate:(id<MFMessageComposeViewControllerDelegate>)messageComposeDelegate {
  if([MFMessageComposeViewController canSendText]) {
    self.fromViewController = fromViewController;
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    controller.recipients = phones;
    controller.body = body;
    controller.messageComposeDelegate = messageComposeDelegate;
    [fromViewController presentViewController:controller animated:YES completion:nil];
  }
  else {
    [GlobalTool popAlertOnVC:self.fromViewController withTitle:@"Message Unavailable" andMessage:nil andYesStr:@"OK" andYesAction:nil];
  }
}

- (void)showMessageToPhones:(NSArray *)phones title:(NSString *)title body:(NSString *)body fromViewController:(UIViewController *)fromViewController {
  [self showMessageToPhones:phones title:title body:body fromViewController:fromViewController messageComposeDelegate:self];
}

- (void)showMessageToPhones:(NSArray *)phones title:(NSString *)title body:(NSString *)body {
  [self showMessageToPhones:phones title:title body:body fromViewController:ROOT_VC];
}

#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
  
  [self.fromViewController dismissViewControllerAnimated:YES completion:nil];
  
  switch (result) {
    case MessageComposeResultCancelled:
      NSLog(@"Cancel");
      break;
      
    case MessageComposeResultSent:
      NSLog(@"Sent");
      break;
      
    case MessageComposeResultFailed:
      NSLog(@"Failed");
      break;
      
    default:
      break;
  }
}

@end
