//
//  SearchNearPeopleRequest.h
//  Messenger
//
//  Created by duanran on 15/11/27.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseRequest.h"

@interface SearchNearPeopleRequest : BaseRequest

@property(nonatomic,strong)NSString *ukey;
@property(nonatomic,strong)NSString *lon;
@property(nonatomic,strong)NSString *lat;
@end
