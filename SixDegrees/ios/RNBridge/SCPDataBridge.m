//
//  SCPDataBridge.m
//  SixDegrees
//
//  Created by Zehao Li on 2018/11/11.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SCPDataBridge.h"
#import "RNFriendlyTool.h"

@implementation SCPDataBridge  {
  NSMutableDictionary<NSNumber *, SCPDataBridgeCallback> *_callbacks;
}

RCT_EXPORT_MODULE();

static int execId = 0;


- (NSArray<NSString *> *)supportedEvents {
  return @[
           @"testBridge",
           @"newRefer",
           @"getAccount",
           @"giveReward",
           ];
}

RCT_EXPORT_METHOD(sendMessageWithData:(NSDictionary *)data) {
  [[RNFriendlyTool sharedInstance] sendMessageWithData:data];
}

RCT_EXPORT_METHOD(clickedButton) {
  [[RNFriendlyTool sharedInstance] showMessageToPhones:@[@"18600870996"] title:@"Test Message" body:@"six://hello?a=1&b=2"];
}

- (void)giveRewardWithCallback:(SCPDataBridgeCallback)callback {
  execId++;
  [self setCallback:callback forKey:execId];
  [self sendEventWithName:@"giveReward" body:@{@"execId":@(execId)}];
}

- (void)getAccountWithCallback:(SCPDataBridgeCallback)callback {
  execId++;
  [self setCallback:callback forKey:execId];
  [self sendEventWithName:@"getAccount" body:@{@"execId":@(execId)}];
}

- (void)newRefer:(NSDictionary *)data callback:(SCPDataBridgeCallback)callback {
  execId++;
  [self setCallback:callback forKey:execId];
  [self sendEventWithName:@"newRefer" body:@{@"execId":@(execId), @"parameters":data}];
}

- (void)testBridge:(NSDictionary *)data callback:(SCPDataBridgeCallback)callback {
  execId++;
  [self setCallback:callback forKey:execId];
  [self sendEventWithName:@"testBridge" body:@{@"execId":@(execId), @"parameters":data}];
}

RCT_EXPORT_METHOD(returnValue:(int)execId result:(NSDictionary *)result)
{
  SCPDataBridgeCallback callback = [self getCallbackForKey:execId];
  if (callback != nil) {
    callback(result);
  }
}

- (void)setCallback:(SCPDataBridgeCallback)callback forKey:(int)key {
  if (_callbacks == nil) {
    _callbacks = [NSMutableDictionary new];
  }
  [_callbacks setObject:callback forKey:@(key)];
}

- (SCPDataBridgeCallback)getCallbackForKey:(int)key {
  if (_callbacks == nil)
    return nil;
  
  SCPDataBridgeCallback callback = _callbacks[@(key)];
  _callbacks[@(key)] = nil;
  return callback;
}


@end
