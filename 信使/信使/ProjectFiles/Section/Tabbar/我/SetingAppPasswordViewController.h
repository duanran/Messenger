//
//  SetingAppPasswordViewController.h
//  Messenger
//
//  Created by duanran on 15/12/3.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "BaseViewController.h"

@interface SetingAppPasswordViewController : BaseViewController

@property(nonatomic,strong)IBOutlet UISegmentedControl *segment;
@property(nonatomic,strong)IBOutlet UIButton *cancelBtn;
@property(nonatomic,strong)IBOutlet UIButton *okBtn;
@property(nonatomic,strong)IBOutlet UITextField *passWordTextField;
@property(nonatomic,strong)IBOutlet UIView *passwordView;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint *okBtnToTopConstrant;
@end
