//
//  WithdrawCash.m
//  Messenger
//
//  Created by duanran on 15/12/8.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "WithdrawCash.h"

@implementation WithdrawCash
- (NSString *)requestURL{
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@",[RequestURL urlWithTpye:URLTypeWithdrawCash],self.ukey];
    
    return url;
}
@end
