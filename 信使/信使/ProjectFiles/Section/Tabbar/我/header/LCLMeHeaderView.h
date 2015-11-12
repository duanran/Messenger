//
//  LCLMeHeaderView.h
//  信使
//
//  Created by lichenglong on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLMeHeaderView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIButton *editNameButton;
@property (weak, nonatomic) IBOutlet UIButton *editPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *headButton;

@end
