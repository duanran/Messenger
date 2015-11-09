//
//  LCLMeHeaderView.m
//  信使
//
//  Created by lichenglong on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMeHeaderView.h"

@implementation LCLMeHeaderView

- (void)awakeFromNib{

    [self.headButton setRoundedRadius:4.0];
    [self.editNameButton setRoundedRadius:4.0];
    [self.editPasswordButton setRoundedRadius:4.0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
