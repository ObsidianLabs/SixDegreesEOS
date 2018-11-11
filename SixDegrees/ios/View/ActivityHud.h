//
//  ProgressHud.h
//  SixDegrees
//
//  Created by Albus on 2018/11/12.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityHud : UIView

+ (instancetype)sharedInstance;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
