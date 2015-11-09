//
//  LCLCacheDefaults.h
//  测试ARC
//
//  Created by 李程龙 on 15-1-9.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLCacheDefaults : NSOperationQueue

//创建单例模式
+ (id)standardCacheDefaults;


#pragma mark - 缓存plist
//设置缓存
- (void)setCacheObject:(id)value forKey:(NSString *)defaultName;
//移除缓存
- (void)removeCacheObjectForKey:(NSString *)defaultName;
//获取缓存
- (id)objectForCacheKey:(NSString *)defaultName;
//获取所有缓存信息
- (NSDictionary *)objectForAllCacheObject;


#pragma mark - 缓存file文件
//设置缓存文件
- (BOOL)setCacheFileWithData:(NSData *)data forKey:(NSString *)fileURL;
//移除缓存文件
- (BOOL)removeCacheFileForKey:(NSString *)fileURL;
//获取缓存文件
- (NSMutableData *)cacheFileForKey:(NSString *)fileURL;
//清除缓存
- (BOOL)clearAllCacheFile;
//获取缓存文件大小
- (CGFloat)getAllCacheFileSize;


#pragma mark - NSUserDefaults缓存



@end










