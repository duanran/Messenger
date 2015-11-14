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
    
    NSString *ukey=[self.parameters objectForKey:@"ukey"];
    NSString *num=[self.parameters objectForKey:@"num"];
    NSString *page=[self.parameters objectForKey:@"page"];
    NSString *lon=[self.parameters objectForKey:@"lon"];
    NSString *lat=[self.parameters objectForKey:@"lat"];
    
    
    
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@?num=%@&page=%@&lon=%@&lat=%@",[RequestURL urlWithTpye:URLTypeLookPhoneUpDate],ukey,num,page,lon,lat];
    return url;
}

@end
