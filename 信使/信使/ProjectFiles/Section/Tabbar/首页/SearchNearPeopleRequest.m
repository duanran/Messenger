//
//  SearchNearPeopleRequest.m
//  Messenger
//
//  Created by duanran on 15/11/27.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "SearchNearPeopleRequest.h"

@implementation SearchNearPeopleRequest
- (NSString *)requestURL{
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@?near=1&num=30&page=1&lon=%@&lat=%@",[RequestURL urlWithTpye:URLTypeSearchNearPeople],self.ukey,self.lon,self.lat];
    return url;
}
@end
