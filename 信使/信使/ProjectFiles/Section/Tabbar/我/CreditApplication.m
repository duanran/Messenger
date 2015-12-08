//
//  CreditApplication.m
//  Messenger
//
//  Created by duanran on 15/12/8.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "CreditApplication.h"

@implementation CreditApplication
- (NSString *)requestURL{
//    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@?&coin=%@&account=%@",[RequestURL urlWithTpye:URLTypeCreditApplication],self.ukey,self.coin,self.account];
     NSString *url=[NSString stringWithFormat:@"%@/ukey/%@",[RequestURL urlWithTpye:URLTypeCreditApplication],self.ukey];
    return url;
}
@end
