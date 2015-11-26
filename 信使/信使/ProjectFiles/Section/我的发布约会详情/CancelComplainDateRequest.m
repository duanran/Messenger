//
//  CancelComplainDateRequest.m
//  Messenger
//
//  Created by duanran on 15/11/26.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "CancelComplainDateRequest.h"

@implementation CancelComplainDateRequest
- (NSString *)requestURL{
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@?date_id=%@&foruid=%@&reason=%@",[RequestURL urlWithTpye:URLTypeCancelComplain],self.ukey,self.dateId,self.foruid,self.reason];
    return url;
}
@end
