//
//  LCLPeopleInfoMeetTableViewCell.m
//  信使
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLPeopleInfoMeetTableViewCell.h"

@implementation LCLPeopleInfoMeetTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.meeButton setRoundedRadius:4.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
