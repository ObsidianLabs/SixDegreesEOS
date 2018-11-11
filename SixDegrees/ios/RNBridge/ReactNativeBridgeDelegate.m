//
//  ReactNativeBridgeDelegate.m
//  SixDegrees
//
//  Created by Zehao Li on 2018/11/11.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ReactNativeBridgeDelegate.h"
#import <React/RCTBundleURLProvider.h>

@implementation ReactNativeBridgeDelegate

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
}

@end
