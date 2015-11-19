//
//  BaiduPushBindRequest.m
//  Messenger
//
//  Created by duanran on 15/11/19.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaiduPushBindRequest.h"

@implementation BaiduPushBindRequest
- (NSString *)requestURL{
    
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@?token=%@&type=2",[RequestURL urlWithTpye:URLTypePushBindUser],self.uKey,self.token];
//     NSString *url=[NSString stringWithFormat:@"%@/ukey/%@",[RequestURL urlWithTpye:URLTypePushBindUser],self.uKey];
    return url;
}
@end
