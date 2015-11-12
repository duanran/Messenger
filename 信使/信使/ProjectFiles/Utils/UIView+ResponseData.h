//
//  UIView+ResponseData.h
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/5/22.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ResponseData)

//处理下载回来的数据
- (id)getResponseDataDictFromResponseData:(NSMutableData *)responseData withSuccessString:(NSString *)successString error:(NSString *)error;


@end







