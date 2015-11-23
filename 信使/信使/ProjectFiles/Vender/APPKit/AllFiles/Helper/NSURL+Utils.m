//
//  NSURL+Utils.m
//  LCLAppKit
//
//  Created by apple on 15/9/12.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "NSURL+Utils.h"

@implementation NSURL (Utils)

- (NSDictionary *)parseQueryToDic{

    if (self) {
        NSString *query = [self query];
        if (query.length>0) {
            NSArray *equalArray = [query componentsSeparatedByString:@"&"];
            if (equalArray.count>0) {
                NSMutableDictionary *keyAndValueDic = [[NSMutableDictionary alloc] init];
                for (NSString *equal in equalArray) {
                    NSArray *keyAndValueArray = [equal componentsSeparatedByString:@"="];
                    if (keyAndValueArray.count>1) {
                        NSString *key = [keyAndValueArray objectAtIndex:0];
                        NSString *value = [keyAndValueArray objectAtIndex:1];
                        if (key.length>0 && ![key isKindOfClass:[NSNull class]] && value.length>0 && ![value isKindOfClass:[NSNull class]]) {
                            [keyAndValueDic setObject:value forKey:key];
                        }
                    }
                }
                return keyAndValueDic;
            }
        }
    }
    
    return nil;
}

@end
