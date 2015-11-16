//
//  MapTableViewCell.m
//  Messenger
//
//  Created by duanran on 15/11/16.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "MapTableViewCell.h"

@implementation MapTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.selectImageView.image = [UIImage imageNamed:@"Check_yes"];
    }
    else
        
    {
        self.selectImageView.image = [UIImage imageNamed:@"icon_unSelect_filter"];
    }
    // Configure the view for the selected state
}

@end
