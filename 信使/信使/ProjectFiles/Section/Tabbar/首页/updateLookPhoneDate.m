//
//  updateLookPhoneDate.m
//  Messenger
//
//  Created by duanran on 15/11/14.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "updateLookPhoneDate.h"

@implementation updateLookPhoneDate
- (NSString *)requestURL{
    
    
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@?num=%@&page=%@&lon=%@&lat=%@",[RequestURL urlWithTpye:URLTypeLookPhoneUpDate],self.uKey,self.num,self.page,self.lon,self.lat];
    return url;
}

@end
