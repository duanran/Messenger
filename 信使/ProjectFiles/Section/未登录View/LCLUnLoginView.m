//
//  LCLUnLoginView.m
//  Fruit
//
//  Created by lichenglong on 15/8/2.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLUnLoginView.h"

@implementation LCLUnLoginView

//显示未登录提示界面
+ (LCLUnLoginView *)showUnloginInfoView{

    LCLUnLoginView *unLoginView = [LCLUnLoginView loadXibView];
    [unLoginView setFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64-44)];
    [unLoginView setHidden:YES];
    
    return unLoginView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)tapLoginButton:(id)sender{

    NSDictionary *dic = [LCLGetToken checkHaveLoginWithShowLoginView:YES];
    if (dic) {
        
    }
}

@end
