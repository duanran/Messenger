//
//  RechargeRequest.m
//  Messenger
//
//  Created by duanran on 15/12/4.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "RechargeRequest.h"

@implementation RechargeRequest
- (NSString *)requestURL{
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@/page/%@/month/%@",[RequestURL urlWithTpye:URLTypeRechargeRecord],self.ukey,self.page,self.time];
    return url;
}

@end
