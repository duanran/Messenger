//
//  NSURL+Utils.h
//  LCLAppKit
//
//  Created by apple on 15/9/12.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Utils)

//把查询请求转换为字典 例如 tag=1&name=lcl 转换为key为tag和name的字典
- (NSDictionary *)parseQueryToDic;

@end

