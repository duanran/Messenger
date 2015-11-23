//
//  LCLARCBlockNetworkManager.h
//  碧桂园售楼
//
//  Created by 李程龙 on 14-9-24.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LCLUploader.h"
#import "LCLDownloader.h"

@interface LCLNetworkManager : NSObject

//线程队列
@property (nonatomic, strong) NSOperationQueue *operationQueue;



//创建单例模式
+ (id)sharedLCLARCNetManager;

//开始下载
- (void)startLCLDownloader:(LCLDownloader *)download;

//开始下载
- (LCLDownloader *)startDownloadWithURLString:(NSString *)url
             httpMethod:(LCLHttpMethod)httpMethod
  useIntelligenceLoader:(BOOL)useIntelligenceLoader
          firstResponse:(LCLDownloadResponseBlock)firstResponseBlock
               progress:(LCLDownloadProgressBlock)progressBlock
               complete:(LCLDownloadCompleteBlock)completeBlock
                  cache:(LCLDownloadCacheBlock)cacheBlock;


//开始上传
- (void)startLCLUploader:(LCLUploader *)upload;

//开始上传
- (LCLUploader *)startUploadWithURLString:(NSString *)url
                                       httpMethod:(LCLHttpMethod)httpMethod
                                         fileName:(NSString *)fileName
                                         filePath:(NSString *)filePath
                                    firstResponse:(LCLUploadResponseBlock)firstResponseBlock
                                         progress:(LCLUploadProgressBlock)progressBlock
                                         complete:(LCLUploadCompleteBlock)completeBlock;

//设置最大下载线程个数
- (void)setMaxCurrentNetworkLinkNum:(NSInteger)linkNum;
//正在连接的线程个数
- (NSUInteger)getNetworkLinkNum;
//取消所有下载线程
- (void)cancelAllNetworkOperations;


//获取在下载的对象
- (LCLDownloader *)getDownloaderWithURLString:(NSString *)urlString;
//取消下载某一个线程
- (void)cancleDownloaderWithURLString:(NSString *)urlString;


//获取在上传的对象
- (LCLUploader *)getUploaderWithURLString:(NSString *)urlString;
//取消上传某一个线程
- (void)cancleUploadWithURLString:(NSString *)urlString;


@end










