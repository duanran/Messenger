//
//  AppDelegate.m
//  信使
//
//  Created by 李程龙 on 15/5/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "AppDelegate.h"

#import "LCLAppLoader.h"

#import "PayPalMobile.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self configurePaypal];
    self.window.backgroundColor = [UIColor whiteColor];
        
    self.window.rootViewController = [[LCLAppLoader shareLCLAppLoader] getMainViewController];
    
    [self.window makeKeyAndVisible];
   
//    [LCLImageHelper createImageWithIconImageName:@"logo_ios"];
    
    return YES;
}
-(void)configurePaypal
{
    [PayPalMobile initializeWithClientIdsForEnvironments:@{
                                                           
                                                           PayPalEnvironmentProduction :@"AS_XQG9XivTbL3_Q9T_9yNyZnG4sBg2ix6_IQgGSv_nQhi_0LtTh7yM4oOCR_U0j9Z5KJJcXSeGaA9gE",//产品模式
                                                           PayPalEnvironmentSandbox : @"AU07d4sI-p6TsCBUcotsOflMrV8D1190RUvv5l5l2DPtE2SF9TSd5WMWZwFsYhoXCU3sncI_Fa4R7IW-"}];//开发模式
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end





























