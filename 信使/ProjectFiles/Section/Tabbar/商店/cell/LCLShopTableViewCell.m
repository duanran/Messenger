//
//  LCLShopTableViewCell.m
//  信使
//
//  Created by lichenglong on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLShopTableViewCell.h"

@implementation LCLShopTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.buyButton setRoundedRadius:3.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
