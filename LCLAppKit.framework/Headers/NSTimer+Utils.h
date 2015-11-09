//
//  NSTimer+Utils.h
//  守艺
//
//  Created by apple on 15/9/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Utils)

//暂停定时器
- (void)pauseTimer;
//启动定时器
- (void)resumeTimer;
//多少秒后启动定时器
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
