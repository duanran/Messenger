//
//  WatchVideoRequest.m
//  Messenger
//
//  Created by duanran on 15/11/13.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "WatchVideoRequest.h"
#import "RequestURL.h"
@implementation WatchVideoRequest

- (NSString *)requestURL{
    
    NSString *ukey=[self.parameters objectForKey:@"uKey"];
    NSString *videoId=[self.parameters objectForKey:@"id"];
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@/id/%@",[RequestURL urlWithTpye:URLTypeWatchVideo],ukey,videoId];
    return url;
}

@end
