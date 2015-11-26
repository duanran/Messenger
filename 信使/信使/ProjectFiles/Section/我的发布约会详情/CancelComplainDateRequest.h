//
//  CancelComplainDateRequest.h
//  Messenger
//
//  Created by duanran on 15/11/26.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseRequest.h"

@interface CancelComplainDateRequest : BaseRequest
@property(nonatomic,strong)NSString *ukey;
@property(nonatomic,strong)NSString *dateId;
@property(nonatomic,strong)NSString *reason;
@property(nonatomic,strong)NSString *foruid;
@end
