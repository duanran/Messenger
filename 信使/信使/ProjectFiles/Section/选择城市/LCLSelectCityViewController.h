//
//  LCLSelectCityViewController.h
//  信使
//
//  Created by 李程龙 on 15/5/27.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "BaseViewController.h"

@protocol LCLSelectCityViewDelegate <NSObject>

- (void)didSelectCity:(NSDictionary *)cityDic;

@end

@interface LCLSelectCityViewController : BaseViewController

@property (strong, nonatomic) NSMutableArray *lclMenuDataSourceArray;

@property (assign, nonatomic) id<LCLSelectCityViewDelegate> selectCityDelegate;

@end
