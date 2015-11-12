//
//  LCLMyFocusTableViewCell.m
//  信使
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMyFocusTableViewCell.h"

@implementation LCLMyFocusTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.timeLabel.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.peopleHeadButton setRoundedRadius:4.0];

    [self.focusButton setRoundedRadius:15.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPeopleNameWithName:(NSString *)name{
    
    if (name && ![name isKindOfClass:[NSNull class]]) {
        
        CGSize size = [self getStringSizeWithString:name fontSize:15 bounce:CGSizeMake(CGFLOAT_MAX, 20)];
        CGRect nameFrame = self.peopleNameLabel.frame;
        nameFrame.size.width = size.width+10;
        [self.peopleNameLabel setFrame:nameFrame];
        
        CGRect levelFrame = self.levelImageView.frame;
        levelFrame.origin.x = nameFrame.origin.x+nameFrame.size.width;
        [self.levelImageView setFrame:levelFrame];
        
        CGRect movieFrame = self.movieImageView.frame;
        movieFrame.origin.x = levelFrame.origin.x+levelFrame.size.width+10;
        [self.movieImageView setFrame:movieFrame];
    }
    
    [self.peopleNameLabel setText:name];
}


@end
