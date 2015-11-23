//
//  LCLBaseOperation.h
//  碧桂园售楼
//
//  Created by 李程龙 on 14-9-24.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LCLHttpMethod) {
    LCLHttpMethodGet = 1,
    LCLHttpMethodPost = 2,
    LCLHttpMethodRestGet = 3,
    LCLHttpMethodRestPost = 4,
    LCLHttpMethodRestDelete = 5,
    LCLHttpMethodRestPut = 6,
};

typedef NS_ENUM(NSInteger, LCLEncryptType) {
    LCLEncryptTypeAES = 1,
    LCLEncryptType16MD5 = 2,
    LCLEncryptType32MD5 = 3,
    LCLEncryptType64 = 4,
    LCLEncryptTypeNone = 5,
};

@interface LCLBaseOperation : NSOperation

//完成下载，从队列删除
- (void)finishOperation:(BOOL)flag;

@end

@interface NSData (Download)

//返回json对象
- (id)jsonObject;

@end




