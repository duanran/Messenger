//
//  LCLSelectDateView.m
//  Fruit
//
//  Created by lichenglong on 15/7/11.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLSelectDateView.h"

@interface LCLSelectDateView ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (copy, nonatomic) LCLSelectBolck selectBlock;

@end

@implementation LCLSelectDateView

- (void)dealloc{

    self.selectBlock = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{

    [self setBackgroundColor:APPPurpleColor];
    [self bringSubviewToFront:self.cancleButton];
    [self bringSubviewToFront:self.selectButton];
}

+ (void)showFromWindowWithSelectBlock:(LCLSelectBolck)selectBolck{

    [LCLAlertController setHideStatusBar:NO];

    LCLSelectDateView *datePickerView = [LCLSelectDateView loadXibView];
    datePickerView.selectBlock = selectBolck;
    
    [LCLAlertController alertFromWindowWithView:datePickerView alertStyle:LCLAlertStyleMoveBottomFull tag:AlertDateTag];
}


- (IBAction)cancleButton:(id)sender{
    
    [LCLAlertController dismissAlertViewWithTag:AlertDateTag];
}

- (IBAction)selectDateAction:(id)sender{

    if (self.selectBlock) {
        
        NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
        [dateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *currentTime = [dateformat stringFromDate:self.datePicker.date];
        dateformat = nil;
        
        self.selectBlock(currentTime);
    }
    
    [self cancleButton:sender];
}

@end






