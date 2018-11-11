//
//  GlobalTool.h
//  SixDegrees
//
//  Created by Zehao Li on 2018/11/11.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AlertSheetAction) (void);

@interface GlobalTool : NSObject

+ (NSDictionary *)convertjsonStringToDict:(NSString *)jsonString;

+ (NSString *)base64EncodeString:(NSString *)str;

+ (NSString *)base64DecodeString:(NSString *)base64Str;

+ (UIImage *)contentsFileStyleImageOfName:(NSString *)imageName;

+ (void)popAlertOnVC:(UIViewController*)vc withTitle:(NSString*)title andMessage:(NSString*)message andYesStr:(NSString*)yesStr andNoStr:(NSString*)noStr andYesAction:(nullable void(^)(void))yesAction andNoAction:(nullable void(^)(void))noAction;
+ (void)popAlertOnVC:(UIViewController*)vc withTitle:(NSString*)title andMessage:(nullable NSString*)message andYesStr:(NSString*)yesStr andNoStr:(NSString*)noStr andYesAction:(nullable void(^)(void))yesAction;
+ (void)popAlertOnVC:(UIViewController *)vc withTitle:(NSString *)title andMessage:(nullable NSString *)message andYesStr:(NSString *)yesStr andYesAction:(nullable void (^)(void))yesAction;
+ (void)popSheetAlertOnVC:(UIViewController*)vc withTitle:(NSString*)title andMessage:(NSString*)message andFuncNames:(NSArray*)funcNames andActions:(NSArray<AlertSheetAction>*)actions;

@end

NS_ASSUME_NONNULL_END
