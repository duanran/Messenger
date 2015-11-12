//
//  LCLMeetingDetailTableViewCell.m
//  信使
//
//  Created by 李程龙 on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMeetingDetailTableViewCell.h"

@implementation LCLMeetingDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
    
    [self.meetNumberBGLabel setRoundedRadius:4.0];
    [self.meetStatusLabel setRoundedRadius:4.0];

    CGRect frame = self.lineLabel.frame;
    frame.size.height = 0.5;
    [self.lineLabel setFrame:frame];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
