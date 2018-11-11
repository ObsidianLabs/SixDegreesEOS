/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "SCPDataBridge.h"
#import "ReactNativeBridgeDelegate.h"
#import "WantToReferVC.h"
#import "GlobalTool.h"
#import "RNFriendlyTool.h"

@interface AppDelegate ()

@property (nonatomic, copy) NSString *author;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;

  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"SixDegrees"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.bridge = [[RCTBridge alloc] initWithDelegate:[ReactNativeBridgeDelegate new] launchOptions:launchOptions];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [self fetchAccountData];
}

- (void)fetchAccountData {
  SCPDataBridge *dataBridge = [self.bridge moduleForName:@"SCPDataBridge"];
  NSLog(@"dataBridgedataBridge: %@", dataBridge);;
  [dataBridge getAccountWithCallback:^(NSDictionary * _Nonnull result) {
    NSLog(@"getAccountWithCallback: %@", result);
    if ([[result objectForKey:@"success"] boolValue]) {
      [RNFriendlyTool sharedInstance].author = [result objectForKey:@"message"];
    }
  }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [self fetchAccountData];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
  NSString *realParametersStr = [GlobalTool base64DecodeString:[url.query substringFromIndex:[@"x=" length]]];
  NSArray *realParametersArr = [realParametersStr componentsSeparatedByString:@":"];
  WantToReferVC *vcWantToRefer = [[WantToReferVC alloc] initWithParametesArray:realParametersArr];
  [self.window.rootViewController presentViewController:vcWantToRefer animated:YES completion:nil];
  return YES;
}

@end
