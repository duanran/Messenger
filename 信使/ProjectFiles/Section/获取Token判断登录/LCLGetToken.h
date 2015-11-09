//
//  LCLGetToken.h
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/29.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LCLTokenCompleteBlock)(BOOL isLogin, NSDictionary *userInfo, NSDictionary *tokenInfo);

@interface LCLGetToken : NSObject

/*
 获取token
 1.本地已有token，则判断是否已登陆,如果登录，返回登录用户信息，如果没有登录，返回游客账户信息
 2.本地没有token，则下载，如果下载成功则返回token信息和游客账号，如果失败，则不返回
 */
+ (void)checkTokenToGetLoginInfoWithCompleteBlock:(LCLTokenCompleteBlock)completeBlock;

/*
 需要登录才能获取信息的时候调用，例如点击礼物或者获取用户记录的时候调用
 1.没登陆，自动弹出登陆界面，返回nil
 2.登录，返回用户信息
 */
+ (NSDictionary *)checkHaveLoginWithShowLoginView:(BOOL)show;


/*
绑定推送用户
 1.没登陆，不绑定
 2.登录，绑定
 */
+ (void)sendUserToServerToGetNotify;

+ (void)checkGetUploadInfoWithCompleteBlock:(LCLSelectBolck)completeBlock;

@end

















