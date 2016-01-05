//
//  LCLShopTableViewCell.h
//  信使
//
//  Created by lichenglong on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLShopTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coinImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property(nonatomic,strong) IBOutlet UILabel *describetionLabel;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint *describeConstant;

@end
