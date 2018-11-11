//
//  WantToReferVC.m
//  SixDegrees
//
//  Created by Zehao Li on 2018/11/11.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "WantToReferVC.h"
#import <MessageUI/MessageUI.h>
#import "SCPDataBridge.h"
#import "AppDelegate.h"
#import "RNFriendlyTool.h"
#import "GlobalTool.h"
#import "ActivityHud.h"

@interface WantToReferVC ()<MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) SCPDataBridge *dataBridge;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *caseId;

@property (nonatomic, copy) NSString *referId;

@end

@implementation WantToReferVC

- (instancetype)initWithParametesArray:(NSArray *)parametersArray {
  self = [super init];
  if (self) {
    if (parametersArray.count == 3) {
      self.author = [parametersArray objectAtIndex:0];
      self.caseId = [parametersArray objectAtIndex:1];
      self.referId = [parametersArray objectAtIndex:2];
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.dataBridge = [[(AppDelegate *)[UIApplication sharedApplication].delegate bridge] moduleForName:@"SCPDataBridge"];
  
  [self initSubviews];
}

- (void)initSubviews {
  UILabel *txtOfTitle = [[UILabel alloc] init];
  txtOfTitle.numberOfLines = 0;
  txtOfTitle.backgroundColor = [UIColor whiteColor];
  txtOfTitle.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:20];
  txtOfTitle.text = @"Help blockonehire";
  txtOfTitle.textColor = [UIColor colorWithRed:31/255.0 green:34/255.0 blue:51/255.0 alpha:1.0];
  txtOfTitle.frame = CGRectMake(24, 74, self.view.frame.size.width - 24*2, 24);
  [self.view addSubview:txtOfTitle];
  
  UILabel *txtOfContent = [[UILabel alloc] init];
  txtOfContent.backgroundColor = [UIColor whiteColor];
  txtOfContent.numberOfLines = 0;
  txtOfContent.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
  txtOfContent.text = @"Block.one is looking for a proficient C++ developers. If you know anybody who is interested, please let us know.";
  txtOfContent.textColor = [UIColor colorWithRed:31/255.0 green:34/255.0 blue:51/255.0 alpha:1.0];
  [self.view addSubview:txtOfContent];
  CGSize sizeOfContent = [txtOfContent sizeThatFits:CGSizeMake(self.view.frame.size.width - 24*2, MAXFLOAT)];
  txtOfContent.frame = CGRectMake(24, txtOfTitle.frame.origin.y + txtOfTitle.frame.size.height + 32, self.view.frame.size.width - 24*2, sizeOfContent.height);
  
  UIView *grayLine1 = [[UIView alloc] init];
  grayLine1.backgroundColor = [UIColor colorWithRed:31/255.0 green:34/255.0 blue:51/255.0 alpha:0.08];
  grayLine1.frame = CGRectMake(24, txtOfContent.frame.origin.y + txtOfContent.frame.size.height + 90, self.view.frame.size.width - 24*2, 1);
  [self.view addSubview:grayLine1];
  
  UILabel *txtOfRewardTitle = [[UILabel alloc] init];
  txtOfRewardTitle.textColor = [UIColor colorWithRed:69/255.0 green:62/255.0 blue:86/255.0 alpha:0.78];
  txtOfRewardTitle.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
  txtOfRewardTitle.text = @"Reward";
  txtOfRewardTitle.frame = CGRectMake(24, grayLine1.frame.origin.y + grayLine1.frame.size.height, 100, 62);
  [self.view addSubview:txtOfRewardTitle];
  
  UILabel *txtOfReward = [[UILabel alloc] init];
  txtOfReward.textAlignment = NSTextAlignmentRight;
  txtOfReward.textColor = [UIColor colorWithRed:31/255.0 green:34/255.0 blue:51/255.0 alpha:1.0];
  txtOfReward.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
  txtOfReward.text = @"100.00 EOS";
  txtOfReward.frame = CGRectMake(txtOfRewardTitle.frame.origin.x + txtOfRewardTitle.frame.size.width + 10, grayLine1.frame.origin.y + grayLine1.frame.size.height, self.view.frame.size.width - 24*2 - txtOfRewardTitle.frame.size.width - 10, 62);
  [self.view addSubview:txtOfReward];
  
  UIView *grayLine2 = [[UIView alloc] init];
  grayLine2.backgroundColor = [UIColor colorWithRed:31/255.0 green:34/255.0 blue:51/255.0 alpha:0.08];
  grayLine2.frame = CGRectMake(24, txtOfRewardTitle.frame.origin.y + txtOfRewardTitle.frame.size.height, self.view.frame.size.width - 24*2, 1);
  [self.view addSubview:grayLine2];
  
  UIButton *btnRefer = [UIButton buttonWithType:UIButtonTypeSystem];
  [btnRefer setTitle:@"I want to refer" forState:UIControlStateNormal];
  [btnRefer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  btnRefer.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:16];
  btnRefer.backgroundColor = [UIColor colorWithRed:76/255.0 green:109/255.0 blue:255/255.0 alpha:1.0];
  btnRefer.frame = CGRectMake(24, grayLine2.frame.origin.y + grayLine2.frame.size.height + 42, self.view.frame.size.width - 24*2, 48);
  btnRefer.layer.masksToBounds = YES;
  btnRefer.layer.cornerRadius = 12;
  [btnRefer addTarget:self action:@selector(toRefer:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btnRefer];
  if ([self isSameAuthor]) {
    [btnRefer setTitle:@"Give Reward" forState:UIControlStateNormal];
  }
}

- (void)toRefer:(UIButton *)sender {
  if (!self.author || !self.caseId || !self.referId) {
    [GlobalTool popAlertOnVC:self withTitle:@"Parmeters are not ready" andMessage:nil andYesStr:@"OK" andYesAction:nil];
    return;
  }
  
  [[ActivityHud sharedInstance] show];
  NSLog(@"toRefertoRefer: %@\t%@", self.author, [RNFriendlyTool sharedInstance].author);
  if ([self isSameAuthor]) {
    [self.dataBridge giveRewardWithCallback:^(NSDictionary * _Nonnull result) {
      [[ActivityHud sharedInstance] hide];
      NSLog(@"giveRewardWithCallback: %@", result);
      NSString *alertTitle = @"You give back the rewards!";
      [GlobalTool popAlertOnVC:self withTitle:alertTitle andMessage:nil andYesStr:@"OK" andYesAction:^{
        [self dismissViewControllerAnimated:YES completion:nil];
      }];
    }];
    return;
  }
  
  [self.dataBridge newRefer:@{@"author":self.author, @"caseId":self.caseId, @"referId":self.referId} callback:^(NSDictionary * _Nonnull result) {
    [[ActivityHud sharedInstance] hide];
    if ([[result objectForKey:@"success"] boolValue]) {
      dispatch_async(dispatch_get_main_queue(), ^(void){
        RNFriendlyTool *rnTool = [RNFriendlyTool sharedInstance];
        NSString *messageBody =  [rnTool generateMessageBodyByData:[GlobalTool convertjsonStringToDict:[result objectForKey:@"message"]]];
        [rnTool showMessageToPhones:@[] title:@"" body:messageBody fromViewController:self messageComposeDelegate:self];
      });
    }
  }];
}

#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
  switch (result) {
    case MessageComposeResultCancelled:
      NSLog(@"WantToReferVC Cancel");
      break;
      
    case MessageComposeResultSent: {
      NSLog(@"WantToReferVC Sent");
      NSString *alertTitle = @"Message has been sent";
      [GlobalTool popAlertOnVC:self withTitle:alertTitle andMessage:nil andYesStr:@"OK" andYesAction:^{
        [self dismissViewControllerAnimated:YES completion:nil];
      }];
      break;
    }
      
    case MessageComposeResultFailed:
      NSLog(@"WantToReferVC Failed");
      break;
      
    default:
      break;
  }
}

- (BOOL)isSameAuthor {
  if (self.author && [RNFriendlyTool sharedInstance].author) {
    if ([self.author isEqualToString:[RNFriendlyTool sharedInstance].author]) {
      return YES;
    }
  }
  
  return NO;
}

@end
