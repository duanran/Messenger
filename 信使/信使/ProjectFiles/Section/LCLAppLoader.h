//
//  LCLAppLoader.h
//  信使
//
//  Created by 李程龙 on 15/5/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LCLAppLoader : NSObject

//创建单例模式
+ (id)shareLCLAppLoader;

//登录
+ (void)loginAction;

//登出
+ (void)logoutAction;

    
//获取主界面
- (UIViewController *)getMainViewController;

//登出成功
- (UIViewController *)getLogoutViewController;

//登录成功
- (UIViewController *)getLoginViewController;

@end





