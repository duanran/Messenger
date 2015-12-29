//
//  IapRequest.m
//  Messenger
//
//  Created by duanran on 15/12/29.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "IapRequest.h"

@implementation IapRequest
- (NSString *)requestURL{
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@/order_no/%@/iap_sign/%@",[RequestURL urlWithTpye:URLTypeIapPay],self.uKey,self.order_no,self.iap_sign];
    return url;
}
@end
