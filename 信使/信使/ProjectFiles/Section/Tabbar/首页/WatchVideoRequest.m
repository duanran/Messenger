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
    
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@/id/%@",[RequestURL urlWithTpye:URLTypeWatchVideo],self.uKey,self.videoId];
    return url;
}

@end
