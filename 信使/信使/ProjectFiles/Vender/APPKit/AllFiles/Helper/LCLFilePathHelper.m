//
//  LCLFilePathHelper.m
//  碧桂园开盘系统
//
//  Created by 李程龙 on 14-7-28.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "LCLFilePathHelper.h"

@implementation LCLFilePathHelper

//获取缓存文件所在的文件夹
+ (NSString *)getLCLCacheFolderPath{
    
    //获取Cache目录
//    NSString*tempPath = NSTemporaryDirectory(); //temp
//    NSArray*cacPathArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES); //library
//    NSArray *cacPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //Documents
    NSArray *cacPathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); //cache
    NSString *fileDir = [cacPathArray objectAtIndex:0];
    fileDir = [NSString stringWithFormat:@"%@/", fileDir];
    
    return fileDir;
}

//获取缓存文件所在的文件夹
+ (NSString *)getLCLCacheFolderPathWithFolderName:(NSString *)folderName{
    
    //获取Cache目录
    //NSString*tempPath = NSTemporaryDirectory(); //temp
    //NSArray*cacPathArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES); //library
    //NSArray *cacPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //Documents
    NSArray *cacPathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); //cache
    NSString *fileDir = [cacPathArray objectAtIndex:0];
    fileDir = [NSString stringWithFormat:@"%@/%@/",fileDir,folderName];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        NSError *error;
        
        if ([fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:&error]) {
            
            return fileDir;
        }else{
            
            return [NSString stringWithFormat:@"%@/",[cacPathArray objectAtIndex:0]];
        }
    }else{
        
        return fileDir;
    }
}

//获取document文件所在的文件夹
+ (NSString *)getLCLDocumentFolderPath{
    
    //获取Cache目录
//    NSString*tempPath = NSTemporaryDirectory(); //temp
//    NSArray*cacPathArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES); //library
    NSArray *cacPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //Documents
//    NSArray *cacPathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); //cache
    NSString *fileDir = [cacPathArray objectAtIndex:0];
    fileDir = [NSString stringWithFormat:@"%@/", fileDir];
    
    return fileDir;
}

//获取document文件所在的文件夹
+ (NSString *)getLCLDocumentFolderPathWithFolderName:(NSString *)folderName{
    
    //获取Cache目录
//    NSString*tempPath = NSTemporaryDirectory(); //temp
//    NSArray*cacPathArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES); //library
    NSArray *cacPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //Documents
//    NSArray *cacPathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); //cache
    NSString *fileDir = [cacPathArray objectAtIndex:0];
    fileDir = [NSString stringWithFormat:@"%@/%@/",fileDir,folderName];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        NSError *error;
        
        if ([fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:&error]) {
            
            return fileDir;
        }else{
            
            return [NSString stringWithFormat:@"%@/",[cacPathArray objectAtIndex:0]];
        }
    }else{
        
        return fileDir;
    }
}


//是否是文件夹或者文件
+ (BOOL)isDocumentPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    return [fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir;
}

@end













