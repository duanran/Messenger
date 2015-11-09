//
//  LCLAppLoader.m
//  信使
//
//  Created by 李程龙 on 15/5/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLAppLoader.h"

#import "AppDelegate.h"
#import "LCLLoginViewController.h"

#import "LCLHomeViewController.h"
#import "LCLMeetingViewController.h"
#import "LCLSearchViewController.h"
#import "LCLShopViewController.h"
#import "LCLMeViewController.h"

#import <SMS_SDK/SMSSDK.h>

#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>


#define appKey @"7b65f8119630"
#define appSecret @"baba7f527fea16c7758190ca20609c7d"

@interface LCLAppLoader () <UITabBarControllerDelegate>

@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation LCLAppLoader

- (id)init{

    self = [super init];
    if (self) {
        
        //初始化应用，appKey和appSecret从后台申请得到
        [SMSSDK registerApp:appKey
                  withSecret:appSecret];
        
//        [SMSSDK enableAppContactFriends:NO];
        
        [WXApi registerApp:@"wx17929d35ae8879d2"]; //secret 64020361b8ec4c99936c0e3999a9f249
        
    }
    return self;
}

//创建单例模式
+ (id)shareLCLAppLoader{

    static dispatch_once_t appTokens;
    static id shareLCLAppLoader = nil;
    
    dispatch_once(&appTokens, ^{
        shareLCLAppLoader = [[[self class] alloc] init];
    });
    return shareLCLAppLoader;
}

+ (UIWindow *)getAppindow{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    return delegate.window;
}

//登录
+ (void)loginAction{

    [self getAppindow].rootViewController = [[LCLAppLoader shareLCLAppLoader] getLoginViewController];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLogin" object:nil];
}

//登出
+ (void)logoutAction{
    
    [self getAppindow].rootViewController = [[LCLAppLoader shareLCLAppLoader] getLogoutViewController];

    NSDictionary *dic = [[NSDictionary alloc] init];
    [[LCLCacheDefaults standardCacheDefaults] setCacheObject:dic forKey:UserInfoKey];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLogout" object:nil];
}


//获取主界面
- (UIViewController *)getMainViewController{

    NSDictionary *dic = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (dic && dic.count>0) {
        return [self getLoginViewController];
    }else{
        return [self getLogoutViewController];
    }
}

//登出成功
- (UIViewController *)getLogoutViewController{
    
    NSDictionary *dic = [[NSDictionary alloc] init];
    [[LCLCacheDefaults standardCacheDefaults] setCacheObject:dic forKey:UserInfoKey];
    
    LCLLoginViewController *login = [[LCLLoginViewController alloc] initWithNibName:@"LCLLoginViewController" bundle:nil];
    [login setCanShowNavBar:NO];
    [login setCanShowNavBackItem:NO];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    
    return nav;
}

//登录成功
- (UIViewController *)getLoginViewController{
    
    UIImage *firstImage = [[UIImage imageNamed:@"menu_fruit_a"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *secondImage = [[UIImage imageNamed:@"menu_fruit_a"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *thirdImage = [[UIImage imageNamed:@"menu_fruit_a"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *fourthImage = [[UIImage imageNamed:@"menu_fruit_a"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *fivethImage = [[UIImage imageNamed:@"menu_my_a"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];

    UIImage *firstSelectImage = [[UIImage imageNamed:@"menu_fruit_b"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *secondSelectImage = [[UIImage imageNamed:@"menu_fruit_b"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *thirdSelectImage = [[UIImage imageNamed:@"menu_fruit_b"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *fourthSelectImage = [[UIImage imageNamed:@"menu_fruit_b"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *fivethSelectImage = [[UIImage imageNamed:@"menu_my_b"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];

    UIColor *selectColor = TapSelectColor;
    UIColor *normalColor = TapDefaultColor;
    
    LCLHomeViewController *homeViewController = [[LCLHomeViewController alloc] init];
    [homeViewController setCanShowNavBackItem:NO];
    UINavigationController *homeNavViewController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:firstImage tag:0];
    [item1 setSelectedImage:firstSelectImage];
    [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:normalColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:selectColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    homeNavViewController.tabBarItem = item1;

    
    LCLMeetingViewController *meetViewController = [[LCLMeetingViewController alloc] init];
    [meetViewController setCanShowNavBackItem:NO];
    UINavigationController *meetNavViewController = [[UINavigationController alloc] initWithRootViewController:meetViewController];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"约会" image:secondImage tag:1];
    [item2 setSelectedImage:secondSelectImage];
    [item2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:normalColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:selectColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    meetNavViewController.tabBarItem = item2;
    
    
    LCLSearchViewController *searchViewController = [[LCLSearchViewController alloc] initWithNibName:@"LCLSearchViewController" bundle:nil];
    [searchViewController setCanShowNavBackItem:NO];
    UINavigationController *searchNavViewController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"搜索" image:thirdImage tag:2];
    [item3 setSelectedImage:thirdSelectImage];
    [item3 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:normalColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item3 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:selectColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    searchNavViewController.tabBarItem = item3;

    
    LCLShopViewController *shopViewController = [[LCLShopViewController alloc] init];
    [shopViewController setCanShowNavBackItem:NO];
    UINavigationController *shopNavViewController = [[UINavigationController alloc] initWithRootViewController:shopViewController];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"商店" image:fourthImage tag:3];
    [item4 setSelectedImage:fourthSelectImage];
    [item4 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:normalColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item4 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:selectColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    shopNavViewController.tabBarItem = item4;
    
    
    LCLMeViewController *meViewController = [[LCLMeViewController alloc] init];
    [meViewController setCanShowNavBackItem:NO];
    UINavigationController *meNavViewController = [[UINavigationController alloc] initWithRootViewController:meViewController];
    UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:@"我" image:fivethImage tag:4];
    [item5 setSelectedImage:fivethSelectImage];
    [item5 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:normalColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item5 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:selectColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    meNavViewController.tabBarItem = item5;
    
    
    NSMutableArray *tabControllers = [NSMutableArray arrayWithObjects:homeNavViewController, meetNavViewController, searchNavViewController, shopNavViewController, meNavViewController, nil];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    [self.tabBarController.tabBar setTintColor:APPPurpleColor];
    self.tabBarController.viewControllers = tabControllers;
    
    return self.tabBarController;
}


#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    
}


@end









