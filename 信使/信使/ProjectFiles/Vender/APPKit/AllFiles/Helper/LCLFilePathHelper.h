//
//  LCLFilePathHelper.h
//  碧桂园开盘系统
//
//  Created by 李程龙 on 14-7-28.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLFilePathHelper : NSObject

//获取缓存文件所在的文件夹
+ (NSString *)getLCLCacheFolderPath;
//获取缓存文件所在的文件夹
+ (NSString *)getLCLCacheFolderPathWithFolderName:(NSString *)folderName;

//获取document文件所在的文件夹
+ (NSString *)getLCLDocumentFolderPath;
//获取document文件所在的文件夹
+ (NSString *)getLCLDocumentFolderPathWithFolderName:(NSString *)folderName;

//是否是文件夹或者文件
+ (BOOL)isDocumentPath:(NSString *)path;

@end








