//
//  BaseRequest.h
//  Messenger
//
//  Created by duanran on 15/11/13.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestURL.h"

typedef void(^onSuccessCallback)(id reponseObject);
typedef void(^onFailureCallback)(NSString *errorMessage);
/* HTTP请求失败 block */
typedef void(^HTTPFailure)(NSError *error);




@interface BaseRequest : NSObject

-(void)GETRequest:(onSuccessCallback)success failureCallback:(onFailureCallback) failed;

-(void)POSTRequest:(onSuccessCallback)success failureCallback:(onFailureCallback) failed;
/* requestURL */
@property (nonatomic, strong) NSString *requestURL;

/* 设置HTTP头 */
@property (nonatomic, strong) NSDictionary *HTTPHeader;

@property (nonatomic,strong) NSDictionary *parameters;


@property (nonatomic, copy) onSuccessCallback success;
@property (nonatomic, copy) onFailureCallback failure;
@property (nonatomic, copy) HTTPFailure httpFailure;


@end
