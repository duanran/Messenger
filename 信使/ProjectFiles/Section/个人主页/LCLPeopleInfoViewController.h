//
//  LCLPeopleInfoViewController.h
//  信使
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "BaseViewController.h"

@interface LCLPeopleInfoViewController : BaseViewController

@property (nonatomic) BOOL isFromMe;
@property (nonatomic) BOOL refresh;

@property (nonatomic, strong) NSDictionary *userInfo;

@end
