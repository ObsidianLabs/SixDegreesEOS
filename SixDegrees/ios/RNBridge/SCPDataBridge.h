//
//  SCPDataBridge.h
//  SixDegrees
//
//  Created by Zehao Li on 2018/11/11.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTLog.h>
#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SCPDataBridgeCallback)(NSDictionary *result);

@interface SCPDataBridge : RCTEventEmitter

- (void)testBridge:(NSDictionary *)data callback:(SCPDataBridgeCallback)callback;
- (void)newRefer:(NSDictionary *)data callback:(SCPDataBridgeCallback)callback;
- (void)getAccountWithCallback:(SCPDataBridgeCallback)callback;
- (void)giveRewardWithCallback:(SCPDataBridgeCallback)callback;

@end

NS_ASSUME_NONNULL_END
