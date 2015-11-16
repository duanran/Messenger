//
//  GiveCoinRequest.m
//  Messenger
//
//  Created by duanran on 15/11/16.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "GiveCoinRequest.h"

@implementation GiveCoinRequest



- (NSString *)requestURL{
    
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@?coin=%@&uid=%@",[RequestURL urlWithTpye:URLTypeGiveCoin],self.uKey,self.coin,self.uid];
    return url;
}

@end
