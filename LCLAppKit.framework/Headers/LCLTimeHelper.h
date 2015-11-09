//
//  LCLTimeHelper.h
//  LCLAppKit
//
//  Created by 李程龙 on 15/5/10.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLTimeHelper : NSObject

#pragma mark - 获取当前时间
+ (NSString *)getCurrentTimeString;  //yyyy-MM-dd HH:mm:ss
+ (NSString *)getCurrentYMString;    //yyyy-MM
+ (NSString *)getCurrentYDString;    //yyyy-MM-dd
+ (NSString *)getCurrentYear;
+ (NSString *)getCurrentMonth;
+ (NSString *)getCurrentDay;
+ (NSString *)getCurrentHour;
+ (NSString *)getCurrentHourMinute;   //HHmm

#pragma mark - 获取时间戳
+ (NSString *)getTimeInterval;

#pragma mark - 根据时间戳获取时间 YYYY-MM-dd HH:mm:ss
+ (NSString *)getDateTimeStringFromTime:(long long)time;

@end
