//
//  SaveVideoRequest.m
//  Messenger
//
//  Created by duanran on 15/11/25.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "SaveVideoRequest.h"

@implementation SaveVideoRequest
- (NSString *)requestURL{
    NSString *url=[NSString stringWithFormat:@"%@/ukey/%@?pic=%@&path=%@&firsturl=%@",[RequestURL urlWithTpye:URLTypeSaveVideo],self.ukey,self.picPath,self.path,self.firstUrl];
    return url;
}
@end
