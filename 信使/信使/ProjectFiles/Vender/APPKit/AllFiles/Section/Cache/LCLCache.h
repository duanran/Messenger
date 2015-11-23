//
//  LCLCache.h
//  测试ARC
//
//  Created by 李程龙 on 15-1-9.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLCache : NSOperation

//设置缓存
- (void)setCObject:(id)value forKey:(NSString *)defaultName;
- (void)removeCObjectForKey:(NSString *)defaultName;

//保存
- (void)save;

//获取cache plist文件
+ (NSString *)getLCLCachePath;

//获取cache folder文件
+ (NSString *)getLCLCacheFolderPath;

@end








