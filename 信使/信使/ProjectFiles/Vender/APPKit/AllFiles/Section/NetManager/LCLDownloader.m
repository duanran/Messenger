//
//  LCLARCBlockDownloader.m
//  碧桂园售楼
//
//  Created by 李程龙 on 14-8-19.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCLDownloader.h"
#import "LCLNetworkManager.h"

#import "NSData+Crypt.h"
#import "NSString+Crypt.h"
#import "LCLCacheDefaults.h"

const NSTimeInterval LCLDefaultTimeout = 30;

NSString * const LCLErrorDomain = @"www.baidu.com";
NSString * const HTTPErrorCode = @"httpStatus";

@interface LCLDownloader (){
    
    uint64_t _receivedDataLength;
    uint64_t _expectedDataLength;
}

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receivedDataBuffer;

@property (nonatomic, strong) NSString *errorString;
@property (nonatomic) BOOL isIntelligence;

@end

@implementation LCLDownloader

@synthesize connection;
@synthesize receivedDataBuffer;
@synthesize urlString;
@synthesize httpMehtod;
@synthesize errorString;

-(void)dealloc{
    
    if ([[LCLNetworkManager sharedLCLARCNetManager] getNetworkLinkNum]==1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }

    self.postObjDic = nil;
    _expectedDataLength = 0;
    _receivedDataLength = 0;
    
    self.urlString = nil;
    self.errorString = nil;
    self.encryptKey = nil;
    self.httpBodyData = nil;
    self.httpBodyObj = nil;
    
    if (self.connection) {
        self.connection = nil;
    }
    
    if (self.receivedDataBuffer) {
        self.receivedDataBuffer = nil;
    }
    
    self.downloadFirstResponseBlock = nil;
    self.downloadProgressBlock = nil;
    self.downloadCompleteBlock = nil;
}

#pragma mark - init
//初始化下载
- (id)initWithURLString:(NSString *)url{
    
    self = [super init];
    if (self) {
        self.urlString = url;
    }
    
    return self;
}

//开始下载
- (void)startToDownloadWithIntelligence:(BOOL)isIntelligence{

    self.isIntelligence = isIntelligence;
    if (isIntelligence) {
        NSMutableData *data = [[LCLCacheDefaults standardCacheDefaults] cacheFileForKey:self.urlString];
        if (data) {
            //有缓存
            if (self.downloadCompleteBlock) {
                self.downloadCompleteBlock(nil, data, self.urlString);
            }
        }else{
            //没缓存
            [[LCLNetworkManager sharedLCLARCNetManager] startLCLDownloader:self];
        }
    }else{
        //不启动智能下载，每次都更新最新数据
        [[LCLNetworkManager sharedLCLARCNetManager] startLCLDownloader:self];
    }
}

#pragma mark - Actions
- (BOOL)isExecuting{
    
    return self.connection != nil;
}

- (BOOL)isFinished{
    
    return self.connection == nil;
}

- (void)finishOperation:(BOOL)flag{
    
    if ([[LCLNetworkManager sharedLCLARCNetManager] getNetworkLinkNum]==1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
    [self handleOperation:flag];
    
    [self willChangeValueForKey:@"isFinished"];
    [self.connection cancel];
    [self didChangeValueForKey:@"isFinished"];
    
    _expectedDataLength = 0;
    _receivedDataLength = 0;
    self.urlString = nil;
    self.errorString = nil;
    
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
    
    if (self.downloadCompleteBlock) {
        if (flag) {
            self.downloadCompleteBlock(nil, self.receivedDataBuffer, self.urlString);
        }else{
            NSMutableData *data = [[LCLCacheDefaults standardCacheDefaults] cacheFileForKey:self.urlString];
            if (self.errorString) {
                self.downloadCompleteBlock(self.errorString, data, self.urlString);
            }else{
                self.downloadCompleteBlock(@"下载已被中断", data, self.urlString);
            }
        }
    }
    
    _expectedDataLength = 0;
    _receivedDataLength = 0;
    self.urlString = nil;
    self.errorString = nil;
    
    if (self.connection) {
        self.connection = nil;
    }
    
    if (self.receivedDataBuffer) {
        self.receivedDataBuffer = nil;
    }
}

//添加post字段
- (void)addPostDataObj:(id)obj key:(id)key body:(NSMutableData *)body{

    NSString *name = [NSString stringWithFormat:@"%@", key];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name='%@'\n\n", name] dataUsingEncoding:NSUTF8StringEncoding]];//第一个字段开始，类型于<input type="text" name="user">

    NSData *encryptedData = [self getDataFromObj:obj];
    if (encryptedData) {
        [body appendData:encryptedData]; //第一个字段的内容
    }
}

//添加HttpBody
- (void)addHttpBodyWithURLRequest:(NSMutableURLRequest *)request obj:(id)obj{

    NSData *encryptedData = [self getDataFromObj:obj];
    if (encryptedData) {
        [request setHTTPBody:encryptedData]; //第一个字段的内容
    }
}

//获取body二进制内容
- (NSData *)getDataFromObj:(id)obj{

    NSData *encryptedData = nil;
    if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]] || [obj isKindOfClass:[NSMutableDictionary class]]) {
        encryptedData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    }else if ([obj isKindOfClass:[NSData class]] || [obj isKindOfClass:[NSMutableData class]]){
        encryptedData = obj;
    }else{
        encryptedData = [[NSString stringWithFormat:@"%@",obj] dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if (!encryptedData) {
        return nil;
    }
    
    if (self.encryptType==LCLEncryptTypeNone) {
        
    }else if (self.encryptType==LCLEncryptType64){
        
        NSString *base64EncodedString = [NSString base64EncodedStringFromTextData:encryptedData];
        encryptedData = [base64EncodedString dataUsingEncoding:NSUTF8StringEncoding];
        
    }else if (self.encryptType==LCLEncryptTypeAES){
        
        if (self.encryptKey) {
            encryptedData = [encryptedData AES256EncryptWithKey:self.encryptKey];
            NSString *base64EncodedString = [NSString base64EncodedStringFromTextData:encryptedData];
            encryptedData = [base64EncodedString dataUsingEncoding:NSUTF8StringEncoding];
        }
    }else if (self.encryptType==LCLEncryptType16MD5){
        
        NSString *md5String = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
        md5String = [md5String encodeWith16MD5];
        encryptedData = [md5String dataUsingEncoding:NSUTF8StringEncoding];

    }else if (self.encryptType==LCLEncryptType32MD5){
        
        NSString *md5String = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
        md5String = [md5String encodeWith32MD5];
        encryptedData = [md5String dataUsingEncoding:NSUTF8StringEncoding];
        
    }else{
        
    }
    
    return encryptedData;
}

#pragma mark - NSOperation Override
- (void)start{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    if(!self.urlString){
    
        self.errorString = [NSString stringWithFormat:@"下载失败, URL为空"];

        [self finishOperation:NO];
        
        return;
    }
    
    if (!self.encryptType) {
        self.encryptType = LCLEncryptTypeNone;
    }
    
    NSMutableURLRequest *fileRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:LCLDefaultTimeout];
    
    NSString *contentType = @"multipart/form-data";
    if (self.httpMehtod) {
        if (self.httpMehtod==LCLHttpMethodPost) {
            [fileRequest setHTTPMethod:@"POST"];
        }
        else if (self.httpMehtod==LCLHttpMethodRestDelete){
            [fileRequest setHTTPMethod:@"Delete"];
        }
        else if (self.httpMehtod==LCLHttpMethodRestGet){
            [fileRequest setHTTPMethod:@"GET"];
        }
        else if (self.httpMehtod==LCLHttpMethodRestPost){
            [fileRequest setHTTPMethod:@"POST"];
        }
        else if (self.httpMehtod==LCLHttpMethodRestPut){
            [fileRequest setHTTPMethod:@"PUT"];
        }
        else{
            [fileRequest setHTTPMethod:@"GET"];
        }
    }else{
        [fileRequest setHTTPMethod:@"POST"];
    }

    if (self.httpBodyData) {
        
        [fileRequest setHTTPBody:self.httpBodyData];

    }else if(self.httpBodyObj){
       
        [self addHttpBodyWithURLRequest:fileRequest obj:self.httpBodyObj];
        
    }else{
    
        if (self.postObjDic.count>0) {
            
            NSString *myBoundary = @"0xKhTmLbOuNdArY";//这个很重要，用于区别输入的域
            NSString *myContent = [NSString stringWithFormat:@"%@;boundary=%@", contentType, myBoundary];//意思是要提交的是表单数据

            [fileRequest setValue:myContent forHTTPHeaderField:@"Content-type"];//定义内容类型

            NSMutableData * body = [NSMutableData data];//这个用于暂存你要提交的数据
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",myBoundary] dataUsingEncoding:NSUTF8StringEncoding]];//表示开始
            
            int i=0;
            __weak typeof(self) weakSelf =  self;
            [self.postObjDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                [self addPostDataObj:obj key:key body:body];
                
                if (i==weakSelf.postObjDic.count-1) {
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",myBoundary] dataUsingEncoding:NSUTF8StringEncoding]];//结束
                }else{
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",myBoundary] dataUsingEncoding:NSUTF8StringEncoding]];//字段间区分开，也意味着第一个字段结束
                }
            }];
            
            [fileRequest setHTTPBody:body];
        }
    }
    
    if (![NSURLConnection canHandleRequest:fileRequest]) {
        
        self.errorString = [NSString stringWithFormat:@"下载失败,不合法的URL: %@",fileRequest.URL];
        
        [self finishOperation:NO];
        
        return;
    }
    
    self.receivedDataBuffer = [[NSMutableData alloc] init];
    self.connection = [[NSURLConnection alloc] initWithRequest:fileRequest delegate:self startImmediately:NO];
    if (self.connection) {
        [self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                   forMode:NSDefaultRunLoopMode];
        [self willChangeValueForKey:@"isExecuting"];
        [self.connection start];
        [self didChangeValueForKey:@"isExecuting"];
    }
}

#pragma mark - NSURLConnection Delegate
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error{
    
    self.errorString = [NSString stringWithFormat:@"下载失败: %@",error.localizedDescription];
    
    [self finishOperation:NO];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response{
    
    _expectedDataLength = [response expectedContentLength];
    NSHTTPURLResponse *httpUrlResponse = (NSHTTPURLResponse *)response;
    
    if (httpUrlResponse.statusCode >= 400) {
        
        self.errorString = [NSString stringWithFormat:@"下载失败, HTTP error code: %@",[NSHTTPURLResponse localizedStringForStatusCode:httpUrlResponse.statusCode]];
        
        [self finishOperation:NO];
        
    }else{
        
        [self.receivedDataBuffer setData:nil];
        
        if (self.downloadFirstResponseBlock) {
            self.downloadFirstResponseBlock(response, self.urlString);
        }
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    
    [self.receivedDataBuffer appendData:data];
    _receivedDataLength += [data length];
    
    if (self.downloadProgressBlock) {
        self.downloadProgressBlock(_receivedDataLength, _expectedDataLength, self.urlString);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection{
    
    if (self.urlString && self.receivedDataBuffer) {
        [[LCLCacheDefaults standardCacheDefaults] setCacheFileWithData:self.receivedDataBuffer forKey:self.urlString];
    }
    
    [self finishOperation:YES];
}

@end






















