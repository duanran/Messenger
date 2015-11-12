//
//  BaseViewController.h
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/4/16.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//是否显示navigationBar
@property (nonatomic) BOOL canShowNavBar;

//是否显示navigationBarBackItem
@property (nonatomic) BOOL canShowNavBackItem;

/**
 *  统一设置背景图片
 *
 *  @param backgroundImage 目标背景图片
 */
@property (nonatomic, strong) UIImageView *lclBackgroundImageView;


//设置左消息item
- (void)setNotifyMessageNavigationItem;

//报名约会
- (void)baomingWithID:(NSString *)meetID;

//查看相册图片
- (void)lookPicWithUID:(NSString *)uid fromImageView:(UIImageView *)imageView index:(NSInteger)index;

@end





