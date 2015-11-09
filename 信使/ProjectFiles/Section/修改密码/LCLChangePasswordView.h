//
//  LCLChangePasswordView.h
//  信使
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLChangePasswordView : UIView

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordsTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordsLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic) BOOL isEditNickName;

@end
