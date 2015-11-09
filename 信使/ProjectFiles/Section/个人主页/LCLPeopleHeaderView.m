//
//  LCLMeHeaderView.m
//  信使
//
//  Created by lichenglong on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLPeopleHeaderView.h"


@implementation LCLPeopleHeaderView

- (void)awakeFromNib{

    [self.addressLabel.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.headButton setRoundedRadius:4.0];
}


- (void)setPeopleNameWithName:(NSString *)name{
    
    if (name && ![name isKindOfClass:[NSNull class]]) {
        
        CGSize size = [self getStringSizeWithString:name fontSize:15 bounce:CGSizeMake(CGFLOAT_MAX, 20)];
        CGRect nameFrame = self.nameLabel.frame;
        nameFrame.size.width = size.width+10;
        CGFloat orgx = (kDeviceWidth-nameFrame.size.width)/2.0;
        nameFrame.origin.x = orgx;
        [self.nameLabel setFrame:nameFrame];
        
        CGRect levelFrame = self.levelImageView.frame;
        levelFrame.origin.x = nameFrame.origin.x+nameFrame.size.width;
        [self.levelImageView setFrame:levelFrame];
        
        CGRect movieFrame = self.movieImageView.frame;
        movieFrame.origin.x = levelFrame.origin.x+levelFrame.size.width+10;
        [self.movieImageView setFrame:movieFrame];
    }
    
    [self.nameLabel setText:name];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
