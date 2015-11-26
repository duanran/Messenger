//
//  LCLMyMeetDetailsTableViewCell.m
//  信使
//
//  Created by apple on 15/10/22.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMyMeetDetailsTableViewCell.h"

@implementation LCLMyMeetDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.rejectButton setRoundedRadius:3.0];
    [self.acceptButton setRoundedRadius:3.0];
    [self.passwordLabel setRoundedRadius:3.0];
    [self.headButton setRoundedRadius:3.0];
    [self.complainBtn setRoundedRadius:3.0];
    
    CGRect frame = self.lineLabel.frame;
    frame.size.height = 0.5;
    [self.lineLabel setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
