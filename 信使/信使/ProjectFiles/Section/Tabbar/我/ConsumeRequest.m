//
//  ConsumeRequest.m
//  Messenger
//
//  Created by duanran on 15/12/7.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "ConsumeRequest.h"

@implementation ConsumeRequest
- (NSString *)requestURL{
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@/page/%@/month/%@",[RequestURL urlWithTpye:URLTypeConsumeRecord],self.ukey,self.page,self.time];

    return url;
}
@end
