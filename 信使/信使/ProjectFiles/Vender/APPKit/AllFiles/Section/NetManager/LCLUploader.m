//
//  LCLARCBlockUploader.m
//  碧桂园售楼
//
//  Created by 李程龙 on 14-9-24.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCLUploader.h"

#import "LCLNetworkManager.h"

const NSTimeInterval LCLUploadDefaultTimeout = 40;

NSString * const LCLUploadErrorDomain = @"www.baidu.com";
NSString * const HTTPUploadErrorCode = @"httpStatus";

@interface LCLUploader (){
    
    uint64_t _uploadDataLength;
    uint64_t _expectedDataLength;
}

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receivedDataBuffer;

@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *filePath;

@end

@implementation LCLUploader

@synthesize connection;
@synthesize receivedDataBuffer;

@synthesize urlString;
@synthesize httpMehtod;
@synthesize errorString;
@synthesize fileName;
@synthesize filePath;

-(void)dealloc{
    
    _expectedDataLength = 0;
    _uploadDataLength = 0;
    
    self.urlString = nil;
    self.errorString = nil;
    self.filePath = nil;
    self.fileName = nil;
    
    if (self.connection) {
        self.connection = nil;
    }
    
    if (self.receivedDataBuffer) {
        self.receivedDataBuffer = nil;
    }
    
    self.firstResponseBlock = nil;
    self.progressBlock = nil;
    self.completeBlock = nil;
}

//开始上传
- (id)initWithURLString:(NSString *)url
               fileName:(NSString *)name
               filePath:(NSString *)path{
    
    self = [super init];
    if (self) {
        
        self.fileName = name;
        self.filePath = path;
        self.urlString = url;
    }
    
    return self;
}

//开始上传
- (void)startToUpload{

    [[LCLNetworkManager sharedLCLARCNetManager] startLCLUploader:self];
}

- (BOOL)isExecuting{
    
    return self.connection != nil;
}

- (BOOL)isFinished{
    
    return self.connection == nil;
}

#pragma mark - NSOperation Override
- (void)start{
    
    if(!self.urlString){
        
        self.errorString = [NSString stringWithFormat:@"上传失败, URL为空"];
        
        [self finishOperation:NO];
        
        return;
    }

    NSInteger time = LCLUploadDefaultTimeout;
    if (self.timeout) {
        time = [self.timeout integerValue];
    }
    NSMutableURLRequest *fileRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:time];
    
    if (self.httpMehtod) {
        if (self.httpMehtod==LCLHttpMethodPost) {
            [fileRequest setHTTPMethod:@"POST"];
        }else{
            [fileRequest setHTTPMethod:@"GET"];
        }
    }else{
        [fileRequest setHTTPMethod:@"POST"];
    }
    
    if (![NSURLConnection canHandleRequest:fileRequest]) {
        
        self.errorString = [NSString stringWithFormat:@"下载失败,不合法的URL: %@",fileRequest.URL];
        
        [self finishOperation:NO];
        
        return;
    }
    
    //得到文件的data
    NSData *data = [NSData dataWithContentsOfFile:self.filePath options:NSDataReadingMappedIfSafe error:nil];
    
    NSString *BOUNDARY = @"----------cH2gL6ei4Ef1KM7cH2KM7ae0ei4gL6";
    
    [fileRequest setValue:[@"multipart/form-data; boundary=" stringByAppendingString:BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [[NSMutableData alloc]init];
    
    if (!self.formName) {
        self.formName = @"image";
    }
    
    NSString *param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n", BOUNDARY, self.formName, self.fileName, nil];
    
    [body appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:data];
    
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *endString = [NSString stringWithFormat:@"--%@--",BOUNDARY];
    
    [body appendData:[endString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [fileRequest setHTTPBody:body];
    
    self.receivedDataBuffer = [[NSMutableData alloc] init];
    self.connection = [[NSURLConnection alloc] initWithRequest:fileRequest delegate:self startImmediately:NO];
    if (self.connection) {
        [self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                   forMode:NSDefaultRunLoopMode];
        [self willChangeValueForKey:@"isExecuting"];
        [self.connection start];
        [self didChangeValueForKey:@"isExecuting"];
    }
    
    body = nil;
}


#pragma mark - NSURLConnection Delegate
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error{
    
    self.errorString = [NSString stringWithFormat:@"上传失败: %@",error.localizedDescription];
        
    [self finishOperation:NO];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response{
    
    _expectedDataLength = [response expectedContentLength];
    NSHTTPURLResponse *httpUrlResponse = (NSHTTPURLResponse *)response;
    
    
    if (httpUrlResponse.statusCode >= 400) {
        
        self.errorString = [NSString stringWithFormat:@"上传失败, HTTP error code: %@",[NSHTTPURLResponse localizedStringForStatusCode:httpUrlResponse.statusCode]];
        
        [self finishOperation:NO];
        
    }else{
        
        [self.receivedDataBuffer setData:nil];
        
        if (self.firstResponseBlock) {
            self.firstResponseBlock(response, self.urlString);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
    if (self.progressBlock) {
        self.progressBlock(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite, self.urlString);
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    
    [self.receivedDataBuffer appendData:data];
    _uploadDataLength += [data length];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection{
    
    [self finishOperation:YES];
}


#pragma mark - Utilities
//完成上传，从队列删除
- (void)finishOperation:(BOOL)flag{
    
    [self handleOperation:flag];
    
    [self willChangeValueForKey:@"isFinished"];
    [self.connection cancel];
    [self didChangeValueForKey:@"isFinished"];
    
    _expectedDataLength = 0;
    _uploadDataLength = 0;
    
    self.urlString = nil;
    self.errorString = nil;
    self.filePath = nil;
    self.fileName = nil;
    
    if (self.connection) {
        self.connection = nil;
    }
    
    if (self.receivedDataBuffer) {
        self.receivedDataBuffer = nil;
    }
}

-(void)handleOperation:(BOOL)flag{
    
    [self willChangeValueForKey:@"isFinished"];
    [self.connection cancel];
    [self didChangeValueForKey:@"isFinished"];
    
    if (self.completeBlock) {
        if (flag) {
            self.completeBlock(nil, self.receivedDataBuffer, self.urlString);
        }else{
            if (self.errorString) {
                self.completeBlock(self.errorString, nil, self.urlString);
            }else{
                self.completeBlock(@"上传已被中断", nil, self.urlString);
            }
        }
    }
    
    _expectedDataLength = 0;
    _uploadDataLength = 0;
    
    self.urlString = nil;
    self.errorString = nil;
    self.filePath = nil;
    self.fileName = nil;
    
    if (self.connection) {
        self.connection = nil;
    }
    
    if (self.receivedDataBuffer) {
        self.receivedDataBuffer = nil;
    }
}


@end




















