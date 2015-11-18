//
//  LCLMeetingButtonTableViewCell.m
//  信使
//
//  Created by 李程龙 on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMeetingButtonTableViewCell.h"

@implementation LCLMeetingButtonTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.faqiButton setRoundedRadius:4.0];
    [self.jiedongButton setRoundedRadius:4.0];
    
    [self setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
