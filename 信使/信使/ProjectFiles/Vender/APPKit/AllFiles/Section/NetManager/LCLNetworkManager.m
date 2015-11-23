//
//  LCLARCBlockNetworkManager.m
//  碧桂园售楼
//
//  Created by 李程龙 on 14-9-24.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "LCLNetworkManager.h"

#import "LCLCacheDefaults.h"

@interface LCLNetworkManager ()

@end

@implementation LCLNetworkManager

@synthesize operationQueue;

-(void)dealloc{
    
    [self.operationQueue cancelAllOperations];
    self.operationQueue = nil;
}

#pragma mark - Init
- (id)init{
    
    self = [super init];
    if (self) {
        
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

//创建单例模式
+ (id)sharedLCLARCNetManager{
    
    static dispatch_once_t netToken;
    static id sharedLCLARCNetManager = nil;
    
    dispatch_once(&netToken, ^{
        
        sharedLCLARCNetManager = [[[self class] alloc] init];
    });
    return sharedLCLARCNetManager;
}

//开始下载
- (void)startLCLDownloader:(LCLDownloader *)download{
    
    [self.operationQueue addOperation:download];
}

//开始下载
- (LCLDownloader *)startDownloadWithURLString:(NSString *)url
                                           httpMethod:(LCLHttpMethod)httpMethod
                                useIntelligenceLoader:(BOOL)useIntelligenceLoader
                                        firstResponse:(LCLDownloadResponseBlock)firstResponseBlock
                                             progress:(LCLDownloadProgressBlock)progressBlock
                                             complete:(LCLDownloadCompleteBlock)completeBlock
                                                cache:(LCLDownloadCacheBlock)cacheBlock{

    LCLDownloader *download = nil;
    BOOL flag = false;
    for (LCLDownloader *down in [self.operationQueue operations]) {
        if ([down.urlString isEqualToString:url]) {
            flag = true;
            download = down;
            break;
        }
    }

    if(flag){
        //已经在下载
        return download;
    }else{
        //还没下载，准备加入下载线程
        //启动智能下载，有缓存就不下载，没缓存就下载最新数据
        if (useIntelligenceLoader) {
            
            NSMutableData *data = [[LCLCacheDefaults standardCacheDefaults] cacheFileForKey:url];
            if (data) {
                 //有缓存
                if (cacheBlock) {
                    cacheBlock(data, url);
                }
                return nil;
            }else{
                //没缓存
                download = [[LCLDownloader alloc] initWithURLString:url];
                [download setHttpMehtod:httpMethod];
                [download setDownloadFirstResponseBlock:firstResponseBlock];
                [download setDownloadProgressBlock:progressBlock];
                [download setDownloadCompleteBlock:completeBlock];
                [self.operationQueue addOperation:download];
                
                return download;
            }
        }else{
            //不启动智能下载，每次都更新最新数据
            download = [[LCLDownloader alloc] initWithURLString:url];
            [download setHttpMehtod:httpMethod];
            [download setDownloadFirstResponseBlock:firstResponseBlock];
            [download setDownloadProgressBlock:progressBlock];
            [download setDownloadCompleteBlock:completeBlock];
            [self.operationQueue addOperation:download];

            return download;
        }
    }
}

//开始上传
- (void)startLCLUploader:(LCLUploader *)upload{

    [self.operationQueue addOperation:upload];
}

//开始上传
- (LCLUploader *)startUploadWithURLString:(NSString *)url
                                       httpMethod:(LCLHttpMethod)httpMethod
                                         fileName:(NSString *)fileName
                                         filePath:(NSString *)filePath
                                    firstResponse:(LCLUploadResponseBlock)firstResponseBlock
                                         progress:(LCLUploadProgressBlock)progressBlock
                                         complete:(LCLUploadCompleteBlock)completeBlock{

    LCLUploader *upload = nil;
    BOOL flag = false;
    for (LCLUploader *up in [self.operationQueue operations]) {
        if ([up.urlString isEqualToString:url]) {
            flag = true;
            upload = up;
            break;
        }
    }
    
    if(flag){
        //已经在上传
        return upload;
    }else{
        //还没上传，准备加入上传线程
        upload = [[LCLUploader alloc] initWithURLString:url fileName:fileName filePath:filePath];
        [upload setHttpMehtod:httpMethod];
        [upload setFirstResponseBlock:firstResponseBlock];
        [upload setProgressBlock:progressBlock];
        [upload setCompleteBlock:completeBlock];
        [self.operationQueue addOperation:upload];
        
        return upload;
    }
}

//设置最大下载线程个数
- (void)setMaxCurrentNetworkLinkNum:(NSInteger)linkNum{

    [self.operationQueue setMaxConcurrentOperationCount:linkNum];
}
//正在连接的线程个数
- (NSUInteger)getNetworkLinkNum{

    return [self.operationQueue operationCount];
}
//取消所有下载线程
- (void)cancelAllNetworkOperations{

    for (LCLBaseOperation *operation in [self.operationQueue operations]) {
        [operation finishOperation:NO];
    }
}

//获取在下载的对象
- (LCLDownloader *)getDownloaderWithURLString:(NSString *)urlString{

    LCLDownloader *download = nil;
    
    for (LCLDownloader *d in [self.operationQueue operations]) {
        
        if ([d.urlString isEqualToString:urlString]) {
            
            download = d;
            
            break;
        }
    }
    
    return download;
}
//取消下载某一个线程
- (void)cancleDownloaderWithURLString:(NSString *)urlString{

    for (LCLDownloader *download in [self.operationQueue operations]) {
        
        if ([download.urlString isEqualToString:urlString]) {
            [download finishOperation:NO];
        }
    }
}


//获取在上传的对象
- (LCLUploader *)getUploaderWithURLString:(NSString *)urlString{

    LCLUploader *uploader = nil;
    
    for (LCLUploader *up in [self.operationQueue operations]) {
        
        if ([up.urlString isEqualToString:urlString]) {
            
            uploader = up;
            
            break;
        }
    }
    
    return uploader;
}
//取消上传某一个线程
- (void)cancleUploadWithURLString:(NSString *)urlString{

    for (LCLUploader *uploader in [self.operationQueue operations]) {
        
        if ([uploader.urlString isEqualToString:urlString]) {
            [uploader finishOperation:NO];
        }
    }
}

@end









