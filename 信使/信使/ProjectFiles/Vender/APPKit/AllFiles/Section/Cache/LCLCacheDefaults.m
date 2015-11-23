//
//  LCLCacheDefaults.m
//  测试ARC
//
//  Created by 李程龙 on 15-1-9.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLCacheDefaults.h"

#import "LCLCache.h"
#import "NSString+Crypt.h"

@implementation LCLCacheDefaults

//创建单例模式
+ (id)standardCacheDefaults{

    static dispatch_once_t cacheToken;
    static id cacheManager = nil;
    
    dispatch_once(&cacheToken, ^{
        
        cacheManager = [[[self class] alloc] init];
    });
    return cacheManager;
}

#pragma mark - Init
- (id)init{
    
    self = [super init];
    if (self) {
        
        [self setMaxConcurrentOperationCount:1];
    }
    return self;
}

#pragma mark - 缓存plist
//设置缓存
- (void)setCacheObject:(id)value forKey:(NSString *)defaultName{

    if (value && defaultName) {
        LCLCache *cache = [[LCLCache alloc] init];
        [cache setCObject:value forKey:defaultName];
        [cache save];
        [self addOperation:cache];
        cache = nil;
    }
}
- (void)removeCacheObjectForKey:(NSString *)defaultName{
    if (defaultName) {
        LCLCache *cache = [[LCLCache alloc] init];
        [cache removeCObjectForKey:defaultName];
        [cache save];
        [self addOperation:cache];
        cache = nil;
    }
}
- (id)objectForCacheKey:(NSString *)defaultName{
    
    if (!defaultName) {
        return nil;
    }
    
    NSString *fileName = [LCLCache getLCLCachePath];
    if (fileName) {
        NSMutableDictionary *cacheDic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
        id object = [cacheDic objectForKey:defaultName];
        cacheDic = nil;
        
        return object;
    }else{
        return nil;
    }
}
- (NSDictionary *)objectForAllCacheObject{
    NSString *fileName = [LCLCache getLCLCachePath];
    if (fileName) {
        return [NSDictionary dictionaryWithContentsOfFile:fileName];
    }else{
        return nil;
    }
}

#pragma mark - 缓存file文件
//设置缓存文件
- (BOOL)setCacheFileWithData:(NSData *)data forKey:(NSString *)fileURL{

    NSString *folderName = [LCLCache getLCLCacheFolderPath];
    if (folderName && ![folderName isEqualToString:@""] && data) {
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@", folderName, [fileURL encodeWithUTF8]];
        BOOL flag = [data writeToFile:fileName atomically:YES];
        
        return flag;
    }
    
    return NO;
}
//移除缓存文件
- (BOOL)removeCacheFileForKey:(NSString *)fileURL{

    NSString *folderName = [LCLCache getLCLCacheFolderPath];
    if (folderName && ![folderName isEqualToString:@""]) {
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@", folderName, [fileURL encodeWithUTF8]];
        __autoreleasing NSError *error;
        BOOL flag = [[NSFileManager defaultManager] removeItemAtPath:fileName error:&error];
        
        return flag;
    }
    
    return NO;
}

//获取缓存文件
- (NSMutableData *)cacheFileForKey:(NSString *)fileURL{

    NSString *folderName = [LCLCache getLCLCacheFolderPath];
    if (folderName && ![folderName isEqualToString:@""]) {
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@", folderName, [fileURL encodeWithUTF8]];
        
        __autoreleasing NSError *error;
        NSMutableData *data = [NSMutableData dataWithContentsOfFile:fileName options:NSDataReadingMappedIfSafe error:&error];
        
        return data;
    }
    
    return nil;
}

//清除缓存
- (BOOL)clearAllCacheFile{
    
    NSString *folderName = [LCLCache getLCLCacheFolderPath];
    if (folderName && ![folderName isEqualToString:@""]) {
        
        __autoreleasing NSError *error;
        BOOL flag = [[NSFileManager defaultManager] removeItemAtPath:folderName error:&error];
        
        return flag;
    }
    
    return NO;
}

//获取缓存文件大小
- (CGFloat)getAllCacheFileSize{

    NSString *folderName = [LCLCache getLCLCacheFolderPath];
    if (folderName && ![folderName isEqualToString:@""]) {
        
        return [self folderSizeAtPath:folderName];
    }
    
    return 0.0;
}

//文件夹大小
- (float)folderSizeAtPath:(NSString*)folderPath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/(1024.0*1024.0);
}

//单个文件大小
- (long long)fileSizeAtPath:(NSString*)filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end











