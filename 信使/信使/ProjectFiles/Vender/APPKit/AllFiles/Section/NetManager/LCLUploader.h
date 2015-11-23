//
//  LCLARCBlockUploader.h
//  碧桂园售楼
//
//  Created by 李程龙 on 14-9-24.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "LCLBaseOperation.h"

//////////////////////定义 block ////////////////
typedef void (^LCLUploadResponseBlock)(NSURLResponse *response, NSString *urlString);
typedef void (^LCLUploadProgressBlock)(NSInteger sendLength, NSInteger totalLength, NSInteger totalExpectedLength, NSString *urlString);
typedef void (^LCLUploadCompleteBlock)(NSString *errorString, NSMutableData *responseData, NSString *urlString);

@interface LCLUploader : LCLBaseOperation<NSURLConnectionDelegate>

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *timeout; //1 为1秒
@property (nonatomic, strong) NSString *formName;
@property (nonatomic) LCLHttpMethod httpMehtod;

@property (nonatomic, copy) LCLUploadResponseBlock firstResponseBlock;
@property (nonatomic, copy) LCLUploadProgressBlock progressBlock;
@property (nonatomic, copy) LCLUploadCompleteBlock completeBlock;

//初始化上传
- (id)initWithURLString:(NSString *)url
         fileName:(NSString *)name
         filePath:(NSString *)path;

//开始上传
- (void)startToUpload;

@end












