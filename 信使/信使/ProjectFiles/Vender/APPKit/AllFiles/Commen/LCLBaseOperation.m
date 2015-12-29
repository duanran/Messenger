//
//  LCLBaseOperation.m
//  碧桂园售楼
//
//  Created by 李程龙 on 14-9-24.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "LCLBaseOperation.h"

@implementation LCLBaseOperation

//完成下载，从队列删除
- (void)finishOperation:(BOOL)flag{


}

@end

@implementation NSData (Download)

//返回json对象
- (id)jsonObject{
    

    id obj = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:nil];
    
    return obj;
}



@end





