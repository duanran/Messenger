//
//  LCLARCBlockDownloader.h
//  碧桂园售楼
//
//  Created by 李程龙 on 14-8-19.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "LCLBaseOperation.h"

#pragma - 定义block
typedef void (^LCLDownloadResponseBlock)(NSURLResponse *response, NSString *urlString);
typedef void (^LCLDownloadProgressBlock)(float receivedLength, float totalLength, NSString *urlString);
typedef void (^LCLDownloadCompleteBlock)(NSString *errorString, NSMutableData *fileData, NSString *urlString);
typedef void (^LCLDownloadCacheBlock)(NSMutableData *fileData, NSString *urlString);


@interface LCLDownloader : LCLBaseOperation<NSURLConnectionDelegate>

@property (nonatomic, strong) NSString *urlString;  //访问地址
@property (nonatomic, strong) NSDictionary *postObjDic;  //form表格
@property (nonatomic, strong) id httpBodyObj; //body对象 字符串或字典、数组
@property (nonatomic, strong) NSData *httpBodyData;  //body二进制
@property (nonatomic, strong) NSString *encryptKey;  //AES加密钥匙
@property (nonatomic) LCLHttpMethod httpMehtod;  //post 或者 get 默认post
@property (nonatomic) LCLEncryptType encryptType;  //加密类型 默认没有

@property (nonatomic, copy) LCLDownloadResponseBlock downloadFirstResponseBlock;
@property (nonatomic, copy) LCLDownloadProgressBlock downloadProgressBlock;
@property (nonatomic, copy) LCLDownloadCompleteBlock downloadCompleteBlock;

//初始化下载
- (id)initWithURLString:(NSString *)url;

//开始下载
- (void)startToDownloadWithIntelligence:(BOOL)isIntelligence;

@end

















