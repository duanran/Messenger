//
//  LCLTimeHelper.m
//  LCLAppKit
//
//  Created by 李程龙 on 15/5/10.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLTimeHelper.h"

@implementation LCLTimeHelper

#pragma mark - 获取当前时间
+ (NSString *)getCurrentYDString{
    
    NSDateFormatter *messageFormater = [[NSDateFormatter  alloc]init];
    [messageFormater setDateFormat:@"yyyy-MM-dd"];
    
    return  [messageFormater stringFromDate:[NSDate date]];
}
+ (NSString *)getCurrentTimeString{
    
    NSDateFormatter *messageFormater = [[NSDateFormatter  alloc]init];
    [messageFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return  [messageFormater stringFromDate:[NSDate date]];
}
+ (NSString *)getCurrentYMString{
    
    NSDateFormatter *messageFormater = [[NSDateFormatter  alloc]init];
    [messageFormater setDateFormat:@"yyyy-MM"];
    
    return  [messageFormater stringFromDate:[NSDate date]];
}
+ (NSString *)getCurrentYear{
    
    NSDateFormatter *messageFormater = [[NSDateFormatter  alloc]init];
    [messageFormater setDateFormat:@"yyyy"];
    
    return  [messageFormater stringFromDate:[NSDate date]];
}
+ (NSString *)getCurrentMonth{
    
    NSDateFormatter *messageFormater = [[NSDateFormatter  alloc]init];
    [messageFormater setDateFormat:@"MM"];
    
    return  [messageFormater stringFromDate:[NSDate date]];
}
+ (NSString *)getCurrentDay{
    
    NSDateFormatter *messageFormater = [[NSDateFormatter  alloc]init];
    [messageFormater setDateFormat:@"dd"];
    
    return  [messageFormater stringFromDate:[NSDate date]];
}
+ (NSString *)getCurrentHour{
    
    NSDateFormatter *messageFormater = [[NSDateFormatter  alloc]init];
    [messageFormater setDateFormat:@"HH"];
    
    return  [messageFormater stringFromDate:[NSDate date]];
}
+ (NSString *)getCurrentHourMinute{
    
    NSDateFormatter *messageFormater = [[NSDateFormatter  alloc]init];
    [messageFormater setDateFormat:@"HHmm"];
    
    return  [messageFormater stringFromDate:[NSDate date]];
}

#pragma mark - 获取时间戳
+ (NSString *)getTimeInterval{

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    return timeString;
}

#pragma mark - 根据时间戳获取时间
+ (NSString *)getDateTimeStringFromTime:(long long)time{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

@end














