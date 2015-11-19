//
//  BaiduPushBindRequest.h
//  Messenger
//
//  Created by duanran on 15/11/19.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseRequest.h"

@interface BaiduPushBindRequest : BaseRequest

@property(nonatomic,strong)NSString *uKey;
@property(nonatomic,strong)NSString *token;
@end
