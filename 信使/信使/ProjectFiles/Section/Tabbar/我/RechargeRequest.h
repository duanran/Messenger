//
//  RechargeRequest.h
//  Messenger
//
//  Created by duanran on 15/12/4.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseRequest.h"

@interface RechargeRequest : BaseRequest
@property(nonatomic,strong)NSString *ukey;
@property(nonatomic,strong)NSString *page;
@property(nonatomic,strong)NSString *time;
@end
