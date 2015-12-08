//
//  CustomAlertView.m
//  Messenger
//
//  Created by duanran on 15/12/8.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "CustomAlertView.h"




@implementation CustomAlertView




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self=[super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    
    self.headView=[[UIView alloc]initWithFrame:CGRectMake(50, 0,[UIScreen mainScreen].bounds.size.width-100, 50)];
    [self addSubview:self.headView];
    
    self.bodyView=[[UIView alloc]initWithFrame:CGRectMake(50,CGRectGetMaxY(self.headView.frame), [UIScreen mainScreen].bounds.size.width-100, 80)];
    [self addSubview:self.bodyView];
    
    self.footView=[[UIView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(self.bodyView.frame), [UIScreen mainScreen].bounds.size.width-100, 40)];
    
    [self addSubview:self.footView];
    
    
    
    
    return self;
}
@end
