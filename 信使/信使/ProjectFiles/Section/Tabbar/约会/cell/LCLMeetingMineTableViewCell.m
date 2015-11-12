//
//  LCLMeetingMineTableViewCell.m
//  信使
//
//  Created by 李程龙 on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMeetingMineTableViewCell.h"

@implementation LCLMeetingMineTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.rejectButton setRoundedRadius:3.0];
    [self.acceptButton setRoundedRadius:3.0];
    [self.passwordLabel setRoundedRadius:3.0];
    [self.yuewoButton setRoundedRadius:3.0];
    [self.headButton setRoundedRadius:3.0];
    
    CGRect frame = self.lineLabel.frame;
    frame.size.height = 0.5;
    [self.lineLabel setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
