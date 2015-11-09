//
//  LCLGetToken.m
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/29.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLGetToken.h"

#import "LCLLoginViewController.h"
#import "AppDelegate.h"

@implementation LCLGetToken

/*
 获取token
 1.本地已有token，则判断是否已登陆,如果登录，返回登录用户信息，如果没有登录，返回游客账户信息
 2.本地没有token，则下载，如果下载成功则返回token信息和游客账号，如果失败，则不返回
 */
+ (void)checkTokenToGetLoginInfoWithCompleteBlock:(LCLTokenCompleteBlock)completeBlock{

//    NSDictionary *tokenDic = [[LCLCacheDefaults standardCacheDefaults] objectForCacheKey:SecretInfoKey];
//    if (!tokenDic || tokenDic.count==0) {
//        //没有token
//        
//        NSString *tokenURL = [NSString stringWithFormat:@"%@%@", GetTokenURL, [NSString getURLInfoString]];
//        LCLARCBlockDownloader *getToken = [[LCLARCBlockNetworkManager sharedLCLARCNetManager] getDownloaderWithURLString:tokenURL];
//        BOOL haveDownload = YES;
//        if (!getToken) {
//            //判断是否已经在下载token
//            haveDownload = NO;
//            getToken = [[LCLARCBlockDownloader alloc] initWithURLString:tokenURL];
//        }
//        [getToken setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
//            
//            NSDictionary *dataDic = [[[UIApplication sharedApplication] keyWindow] getResponseDataDictFromResponseData:fileData withSuccessString:nil];
//            if (dataDic) {
//                //下载token成功
//                [[LCLCacheDefaults standardCacheDefaults] setCacheObject:dataDic forKey:SecretInfoKey];
//                
//                [self checkLoginInfoWithTokenDic:dataDic completeBlock:completeBlock];
//            }
//        }];
//        if (!haveDownload) {
//            //之前没有下载则下载
//            [getToken startToDownload];
//        }
//        
//    }else{
//        //已有token
//        [self checkLoginInfoWithTokenDic:tokenDic completeBlock:completeBlock];
//    }
}


/* 
 需要登录才能获取信息的时候调用，例如点击礼物或者获取用户记录的时候调用
 1.没登陆，自动弹出登陆界面，返回nil
 2.登录，返回用户信息
 */
+ (NSDictionary *)checkHaveLoginWithShowLoginView:(BOOL)show{

    NSDictionary *loginDic = [self checkLogin];
    
    if (loginDic) {
        //已经登录

        return loginDic;
        
    }else{
        //没有登录
        
        if (show) {
            
//            [LCLAlertViewController dismissView];
            
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UIViewController *rootController = delegate.window.rootViewController;
            
            LCLLoginViewController *login = [[LCLLoginViewController alloc] init];
            [login setCanShowNavBar:NO];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
            
            [rootController presentViewController:nav animated:YES completion:nil];
        }
    }
    
    return nil;
}

//回调登录后的用户信息 和 没有登录的游客信息
+ (void)checkLoginInfoWithTokenDic:(NSDictionary *)tokenDic completeBlock:(LCLTokenCompleteBlock)completeBlock{

    NSDictionary *loginDic = [self checkLogin];

    if (loginDic) {
        //已经登录
        completeBlock(YES, loginDic, tokenDic);
    }else{
        //没有登录
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModel];
        userObj.password = @"0";
        userObj.pwd = @"0";
        userObj.nickname = DefaultUserID;
        userObj.email = @"";
        userObj.headimg = @"";
        userObj.mobile = DefaultUserID;
        userObj.sex = @"1";
        userObj.qq = @"";
        userObj.province_name = @"";
        userObj.city_name = @"";
        userObj.area_name = @"";
        userObj.uid = DefaultUserID;
        userObj.ID = @"";
        userObj.last_login = @"";
        loginDic = userObj.getAllPropertyAndValue;

        [[LCLCacheDefaults standardCacheDefaults] setCacheObject:loginDic forKey:UserInfoKey];

        completeBlock(NO, loginDic, tokenDic);
    }
}

//判断是否登录，如果登录返回登录用户信息
+ (NSDictionary *)checkLogin{
    
    NSDictionary *userDic = [[LCLCacheDefaults standardCacheDefaults] objectForCacheKey:UserInfoKey];
    if (userDic && userDic.count>0) {
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userDic];
        NSString *uid = [NSString stringWithFormat:@"%@", userObj.ukey];
        if (!uid || [uid isEqualToString:@""] || [uid isEqualToString:DefaultUserID]) {
            //没有登录
        }else{
            return userDic;
        }
    }else{
        //没有登录
    }
    return nil;
}

/*
 绑定推送用户
 1.没登陆，不绑定
 2.登录，绑定
 */
+ (void)sendUserToServerToGetNotify{

//    NSString *token = [[LCLCacheDefaults standardCacheDefaults] objectForCacheKey:DeviceTokenKey];
//    if (token) {
//        if (token.length>0) {
//            
//            NSDictionary *userInfo = [self checkLogin];
//            if (userInfo) {
//                
//                LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
//                
//                token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
//                token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
//                token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//                
//                NSString *loginString = [[NSString alloc] initWithFormat:@"token=%@&channel_id=%@&type=%@", token, userObj.username, @"2"];
//                
//                LCLARCBlockDownloader *login = [[LCLARCBlockDownloader alloc] initWithURLString:SendNotifyUser(userObj.ukey)];
//                [login setEncryptType:LCLEncryptTypeNone];
//                [login setHttpMehtod:LCLARCHttpMethodPost];
//                [login setHttpBodyData:[loginString dataUsingEncoding:NSUTF8StringEncoding]];
//                [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
//                    
//                    NSDictionary *dataDic = [[[UIApplication sharedApplication] keyWindow] getResponseDataDictFromResponseData:fileData withSuccessString:nil error:nil];
//                    if (dataDic) {
//                        NSLog(@"%@", [dataDic objectForKey:@"msg"]);
//                    }
//                }];
//                [login startToDownload];
//            }
//        }
//    }
}

+ (void)checkGetUploadInfoWithCompleteBlock:(LCLSelectBolck)completeBlock{

    LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:GetUploadFileURL];
    [login setHttpMehtod:LCLHttpMethodGet];
    [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
        
        NSDictionary *dataDic = [[[UIApplication sharedApplication] keyWindow] getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
        completeBlock(dataDic);
    }];
    [login startToDownloadWithIntelligence:NO];
}

@end

































