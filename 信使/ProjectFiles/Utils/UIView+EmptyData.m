//
//  UIView+EmptyData.m
//  Fruit
//
//  Created by lichenglong on 15/8/2.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "UIView+EmptyData.h"
#import <objc/runtime.h>

#import "LCLUnLoginView.h"

NSString const *UnloginInfoKey = @"UnloginInfoKey";

@interface UIView ()

@property (strong, nonatomic) LCLUnLoginView *unloginInfoView;

@end

@implementation UIView (EmptyData)

#pragma mark - 显示未登录提示界面
- (LCLUnLoginView *)unloginInfoView{
    return objc_getAssociatedObject(self, &UnloginInfoKey);
}
- (void)setUnloginInfoView:(LCLUnLoginView *)unloginInfoView{
    objc_setAssociatedObject(self, &UnloginInfoKey, unloginInfoView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)showUnloginInfoView:(BOOL)show{
    if (self.unloginInfoView==nil) {
        self.unloginInfoView = [LCLUnLoginView loadXibView];
        [self.unloginInfoView setFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64-44)];
        [self addSubview:self.unloginInfoView];
    }
    [self bringSubviewToFront:self.unloginInfoView];
    [self.unloginInfoView setHidden:!show];
}

@end
















