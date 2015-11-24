//
//  ComplainRequest.m
//  Messenger
//
//  Created by duanran on 15/11/24.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "ComplainRequest.h"

@implementation ComplainRequest
- (NSString *)requestURL{
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@?pic_id=%@&msg=%@",[RequestURL urlWithTpye:URLTypeComplain],self.uKey,self.pic_id,self.reason];
    return url;
}
@end
