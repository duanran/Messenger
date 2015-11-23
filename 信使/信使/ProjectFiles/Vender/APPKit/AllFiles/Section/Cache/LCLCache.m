//
//  LCLCache.m
//  测试ARC
//
//  Created by 李程龙 on 15-1-9.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLCache.h"

#import "LCLFilePathHelper.h"

@interface LCLCache ()

@property (strong, nonatomic) id obj;
@property (strong, nonatomic) NSString *key;
@property (assign, nonatomic) BOOL isSaveCache;

@end

@implementation LCLCache

- (void)dealloc{

    self.obj = nil;
    self.key = nil;
}

//设置缓存
- (void)setCObject:(id)value forKey:(NSString *)defaultName{

    if (value) {
        self.obj = value;
    }
    
    if (defaultName) {
        self.key = defaultName;
    }
    
    self.isSaveCache = YES;
}
- (void)removeCObjectForKey:(NSString *)defaultName{

    if (defaultName) {
        self.key = defaultName;
    }
    
    self.isSaveCache = NO;
}

//保存
- (void)save{

    NSString *fileName = [LCLCache getLCLCachePath];
    
    if (fileName) {
        NSMutableDictionary *cacheDic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
        if (self.isSaveCache) {
            
            if (self.obj && self.key) {
                if (cacheDic) {
                    [cacheDic setObject:self.obj forKey:self.key];
                    [cacheDic writeToFile:fileName atomically:YES];
                }
            }
        }else{
            
            if (self.key) {
                if (cacheDic) {
                    [cacheDic removeObjectForKey:self.key];
                    [cacheDic writeToFile:fileName atomically:YES];
                }
            }
        }
    }
    
    self.obj = nil;
    self.key = nil;
}

#pragma mark - NSOperation Override
- (void)main {
    
//    NSString *fileName = [LCLCache getLCLCacheFilePath];
//
//    if (fileName) {
//        NSMutableDictionary *cacheDic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
//        if (self.isCancelled){
//            return;
//        }
//        if (self.isSaveCache) {
//            
//            if (self.isCancelled){
//                return;
//            }
//            if (self.obj && self.key) {
//                if (cacheDic) {
//                    [cacheDic setObject:self.obj forKey:self.key];
//                    [cacheDic writeToFile:fileName atomically:YES];
//                }
//                cacheDic = nil;
//            }else{
//                cacheDic = nil;
//            }
//        }else{
//            
//            if (self.isCancelled){
//                return;
//            }
//            if (self.key) {
//                if (cacheDic) {
//                    [cacheDic removeObjectForKey:self.key];
//                    [cacheDic writeToFile:fileName atomically:YES];
//                }
//                cacheDic = nil;
//            }else{
//                cacheDic = nil;
//            }
//        }
//    }
//    
//    if (self.isCancelled){
//        return;
//    }
//    self.obj = nil;
//    self.key = nil;
}

//获取cache plist文件
+ (NSString *)getLCLCachePath{

    NSString *folderPath = [self getCacheFolderPathWithFolderName:@"LCLCacheDefaults"];
    NSString *fileName = [folderPath stringByAppendingString:@"LCLCacheDefaults.plist"];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:fileName isDirectory:&isDir];
    if ( !existed ){
        
        NSMutableDictionary *cacheDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Dictionary", @"Root", nil];
        BOOL flag = [cacheDic writeToFile:fileName atomically:YES];
        cacheDic = nil;
        if (flag) {
            return fileName;
        }else{
            return nil;
        }
    }else{
        return fileName;
    }
}

//获取cache folder文件
+ (NSString *)getLCLCacheFolderPath{

    NSString *folderPath = [self getCacheFolderPathWithFolderName:@"LCLCacheFolderDefaults"];
    
    return folderPath;
}

//获取缓存文件所在的文件夹
+ (NSString *)getCacheFolderPathWithFolderName:(NSString *)folderName{
    
    return [LCLFilePathHelper getLCLCacheFolderPathWithFolderName:folderName];
}

@end














