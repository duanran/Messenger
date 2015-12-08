//
//  CustomAlertView.h
//  Messenger
//
//  Created by duanran on 15/12/8.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIAlertView<UIAlertViewDelegate>

@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIView *bodyView;
@property(nonatomic,strong)UIView *footView;

@end
