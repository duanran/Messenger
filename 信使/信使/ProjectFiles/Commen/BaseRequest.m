//
//  BaseRequest.m
//  Messenger
//
//  Created by duanran on 15/11/13.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseRequest.h"
#import "AFNetworking.h"
//#import "RequestURL.h"

@implementation BaseRequest

-(id)init
{
    self=[super init];
    if (self) {
        _parameters = [NSDictionary dictionary];
        _HTTPHeader = [NSDictionary dictionary];
    }
    return self;
}


-(void)POSTRequest:(onSuccessCallback)success failureCallback:(onFailureCallback)failed{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if (self.HTTPHeader) {
        [self.HTTPHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSAssert([key isKindOfClass:[NSString class]], @"key must be an string");
            NSAssert([obj isKindOfClass:[NSString class]], @"key must be an string");
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    [manager POST:self.requestURL
                        parameters:self.parameters
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                               //                               NSLog(@"responseObject = %@",responseObject);
//                               responseModel *response = [responseModel objectWithKeyValues: [responseObject objectForKey:@"result"]];
//                               if ([response.code isEqualToString:@"100000"]) {
//                                   success([self assembleResponseModel:[responseObject objectForKey:@"resultData"]]);
//                               }
//     else{
//                                   failure([self handleRequestError:response]);
                               }
                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               //                               NSLog(@"%@",error);
//                               failure([self handleErrorMessage:error]);
                           }];
    
    
}
-(void)GETRequest:(onSuccessCallback)success failureCallback:(onFailureCallback)failed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializerWithWritingOptions:0];
    manager.requestSerializer.timeoutInterval=20.0f;
    
    if(_HTTPHeader!=nil){
        [_HTTPHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    manager.securityPolicy.allowInvalidCertificates=YES;
        NSLog(@"requestURL = %@",self.requestURL);
     [manager GET:self.requestURL
                       parameters:nil
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              if ([[responseObject objectForKey:@"success"]integerValue]==1) {
                                  
                                  NSDictionary *infoDic=[responseObject objectForKey:@"info"];
                                  if (infoDic) {
                                      success([self assembleResponseModel:infoDic]);
                                  }
                                  else
                                  {
                                      success([self assembleResponseModel:responseObject]);
                                  }
                              }
                              else
                              {
                                  failed([responseObject objectForKey:@"message"]);
                              }
      
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              failed(error.description);
                          }];
}



#pragma mark ----- 设置 HTTP 头 -----
- (NSDictionary *)HTTPHeader{
    
    //子类使用示例
    return @{@"Content-Type": @"application/json;charset=UTF-8"};
}

#pragma mark ----- 获取请求 URL -----
- (NSString *)requestURL{
    
    return @"";
    
//    //子类使用示例
//    return [RequestURL urlWithTpye:URLTypeLogin];
}

#pragma mark ----- 各request独立于其VC可获得的参数 -----
- (NSDictionary *)independentOfVCParameters{
    return [NSDictionary dictionary];
}

#pragma mark ----- 将返回结果转换ViewController可以处理的model -----
- (id)assembleResponseModel:(id)responseObject{
    return responseObject;
}


#pragma mark -----  对请求失败进行处理 -----
- (NSString *)handleErrorMessage:(NSError *)error{
    return error.localizedDescription;
}


@end
