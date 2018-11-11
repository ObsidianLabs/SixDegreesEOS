//
//  GlobalTool.m
//  SixDegrees
//
//  Created by Zehao Li on 2018/11/11.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "GlobalTool.h"

@implementation GlobalTool

+ (NSString *)base64EncodeString:(NSString *)str {
  NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
  return [data base64EncodedStringWithOptions:0];
}

+ (NSDictionary *)convertjsonStringToDict:(NSString *)jsonString {
  NSDictionary *retDict = nil;
  if ([jsonString isKindOfClass:[NSString class]]) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    retDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
    return retDict;
  }else{
    return retDict;
  }
}

+ (NSString *)base64DecodeString:(NSString *)base64Str {
  NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (UIImage*)contentsFileStyleImageOfName:(NSString *)imageName
{
  return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageName]];
}

+ (void)popAlertOnVC:(UIViewController*)vc withTitle:(NSString*)title andMessage:(NSString*)message andYesStr:(NSString*)yesStr andNoStr:(NSString*)noStr andYesAction:(nullable void(^)(void))yesAction andNoAction:(nullable void(^)(void))noAction {
  UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* action1 = [UIAlertAction actionWithTitle:yesStr style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                            {
                              if (yesAction)
                              {
                                yesAction();
                              }
                            }];
  [alertController addAction:action1];
  [alertController addAction:[UIAlertAction actionWithTitle:noStr style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    if (noAction) {
      noAction();
    }
  }]];
  
  [vc presentViewController:alertController animated:YES completion:nil];
  
}

+ (void)popAlertOnVC:(UIViewController*)vc withTitle:(NSString*)title andMessage:(nullable NSString*)message andYesStr:(NSString*)yesStr andNoStr:(NSString*)noStr andYesAction:(nullable void(^)(void))yesAction
{
  [self popAlertOnVC:vc withTitle:title andMessage:message andYesStr:yesStr andNoStr:noStr andYesAction:yesAction andNoAction:nil];
}

//这个只有确定按钮
+ (void)popAlertOnVC:(UIViewController *)vc withTitle:(NSString *)title andMessage:(nullable NSString *)message andYesStr:(NSString *)yesStr andYesAction:(nullable void (^)(void))yesAction
{
  UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* action1 = [UIAlertAction actionWithTitle:yesStr style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                            {
                              if (yesAction)
                              {
                                yesAction();
                              }
                            }];
  [alertController addAction:action1];
  
  dispatch_async(dispatch_get_main_queue(), ^(void)
                 {
                   [vc presentViewController:alertController animated:YES completion:nil];
                 });
}

+ (void)popSheetAlertOnVC:(UIViewController*)vc withTitle:(NSString*)title andMessage:(NSString*)message andFuncNames:(NSArray*)funcNames andActions:(NSArray<AlertSheetAction>*)actions
{
  if (actions == nil || actions.count == 0 || funcNames == nil || funcNames.count == 0 || funcNames.count != actions.count)
  {
    return;
  }
  UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
  
  for (NSInteger i = 0; i < actions.count; i++)
  {
    UIAlertAction* thisAction = [UIAlertAction actionWithTitle:[funcNames objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                                   AlertSheetAction theAction = [actions objectAtIndex:i];
                                   if (theAction)
                                   {
                                     theAction();
                                   }
                                 }];
    [alertController addAction:thisAction];
  }
  
  [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
  
  [vc presentViewController:alertController animated:YES completion:nil];
}

@end
