//
//  BaseResponseObject.h
//  Messenger
//
//  Created by duanran on 15/11/13.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseResponseObject : NSObject
@property(nonatomic,strong)NSString *errorCode;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,strong)NSString *successCode;
@end
