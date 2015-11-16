//
//  updateLookPhoneDate.h
//  Messenger
//
//  Created by duanran on 15/11/14.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseRequest.h"

@interface updateLookPhoneDate : BaseRequest

@property(nonatomic,strong)NSString *uKey;
@property(nonatomic,strong)NSString *num;
@property(nonatomic,strong)NSNumber *page;
@property(nonatomic,strong)NSString *lon;
@property(nonatomic,strong)NSString *lat;


@end
