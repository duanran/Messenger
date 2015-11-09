//
//  UIView+ResponseData.m
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/22.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "UIView+ResponseData.h"

@implementation UIView (ResponseData)

//处理下载回来的数据
- (id)getResponseDataDictFromResponseData:(NSMutableData *)responseData withSuccessString:(NSString *)successString error:(NSString *)error{
    
    LCLTipsLocation location = LCLTipsLocationMiddle;
    
    if (responseData) {
        NSDictionary *responseDic = [responseData jsonObject];
        if (responseDic) {
            int code = [[responseDic objectForKey:@"success"] intValue];
            if (code==1) {
                
                if (successString) {
                    if ([successString isEqualToString:@""]) {
                        [LCLTipsView showTips:[responseDic objectForKey:@"message"] location:location];
                    }else{
                        [LCLTipsView showTips:successString location:location];
                    }
                }
                
                return responseDic;
            }else{
                
                if (error) {
                    if ([error isEqualToString:@""]) {
                        [LCLTipsView showTips:[responseDic objectForKey:@"message"] location:location];
                    }else{
                        [LCLTipsView showTips:error location:location];
                    }
                }
            }
        }else{
            
            NSLog(@"%@", [NSString stringWithFormat:@"解析数据出错：==%@==", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]]);
            
            [LCLTipsView showTips:[NSString stringWithFormat:@"解析数据出错：%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]] location:location];
        }
    }else{
        
        [LCLTipsView showTips:@"网络不给力，连接失败" location:location];
    }
    
    return nil;
}

@end








