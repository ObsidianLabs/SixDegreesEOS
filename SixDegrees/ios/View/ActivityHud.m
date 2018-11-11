//
//  ProgressHud.m
//  SixDegrees
//
//  Created by Albus on 2018/11/12.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ActivityHud.h"

static ActivityHud *instance = nil;

@implementation ActivityHud {
  UIActivityIndicatorView *activityView;
}

+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (instance == nil) {
      instance = [[self alloc] init];
    }
  });
  return instance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 12;
    [self initSubviews];
  }
  return self;
}

- (void)initSubviews {
  activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [self addSubview:activityView];
}

- (void)show {
  UIWindow *window = [UIApplication sharedApplication].delegate.window;
  [window addSubview:self];
  CGFloat size = 100;
  self.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - size)/2.0, (UIScreen.mainScreen.bounds.size.height - size)/2.0, size, size);
  activityView.frame = self.bounds;
  [activityView startAnimating];
}

- (void)hide {
  [self removeFromSuperview];
  [activityView stopAnimating];
}

@end
