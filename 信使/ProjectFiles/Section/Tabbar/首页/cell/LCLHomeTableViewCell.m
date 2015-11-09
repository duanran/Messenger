//
//  LCLHomeTableViewCell.m
//  信使
//
//  Created by 李程龙 on 15/5/28.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLHomeTableViewCell.h"

@implementation LCLHomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.yuehuiButton setBackgroundColor:APPPurpleColor];
    [self.homeButton setBackgroundColor:[UIColor colorWithRed:205/255.0 green:224/255.0 blue:227/255.0 alpha:1.0]];
    [self.phoneButton setBackgroundColor:[UIColor colorWithRed:205/255.0 green:224/255.0 blue:227/255.0 alpha:1.0]];
    
    [self.yuehuiButton setRoundedRadius:4.0];
    [self.homeButton setRoundedRadius:4.0];
    [self.phoneButton setRoundedRadius:4.0];
    
    [self.timeLabel.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.peopleHeadButton setRoundedRadius:4.0];
    
    
    CGFloat round = self.imageNumberLabel.frame.size.height/2.0;
    UIRectCorner corners =  UIRectCornerBottomLeft | UIRectCornerTopLeft;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imageNumberLabel.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(round, round)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.imageNumberLabel.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.imageNumberLabel.layer.mask = maskLayer;

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




