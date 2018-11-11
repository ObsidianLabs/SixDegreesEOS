//
//  RNFriendlyTool.h
//  SixDegrees
//
//  Created by Zehao Li on 2018/11/11.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNFriendlyTool : NSObject

@property (nonatomic, copy) NSString *author;

+ (instancetype)sharedInstance;

- (NSString *)generateMessageBodyByData:(NSDictionary *)messageData;
- (void)sendMessageWithData:(NSDictionary *)data;
- (void)showMessageToPhones:(NSArray *)phones title:(NSString *)title body:(NSString *)body;
- (void)showMessageToPhones:(NSArray *)phones title:(NSString *)title body:(NSString *)body fromViewController:(UIViewController *)fromViewController;
- (void)showMessageToPhones:(NSArray *)phones title:(NSString *)title body:(NSString *)body fromViewController:(UIViewController *)fromViewController messageComposeDelegate:(id<MFMessageComposeViewControllerDelegate>)messageComposeDelegate;

@end

NS_ASSUME_NONNULL_END
