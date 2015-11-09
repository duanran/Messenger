//
//  LCLSelectPickerView.m
//  信使
//
//  Created by apple on 15/9/25.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLSelectPickerView.h"

@interface LCLSelectPickerView ()

@property (weak, nonatomic) IBOutlet UIPickerView *miniSelectPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *maxSelectPicker;

@property (strong, nonatomic) NSMutableArray *miniArray;
@property (strong, nonatomic) NSMutableArray *maxArray;

@property (strong, nonatomic) NSString *identifyTag;

@property (copy, nonatomic) LCLSelectBolck miniSelectBolck;
@property (copy, nonatomic) LCLSelectBolck maxSelectBolck;

@end

@implementation LCLSelectPickerView

+ (void)showWithMiniCompleteBlock:(LCLSelectBolck)miniBlock miniArray:(NSMutableArray *)miniArray maxCompleteBlock:(LCLSelectBolck)maxBlock maxArray:(NSMutableArray *)maxArray  tag:(NSString *)tag{

    [LCLAlertController setHideStatusBar:NO];

    LCLSelectPickerView *addressView = [LCLSelectPickerView loadXibView];
    [addressView setFrame:CGRectMake(0, 0, kDeviceWidth, 210)];
    [addressView setMiniArray:miniArray];
    [addressView setMaxArray:maxArray];
    [addressView setMiniSelectBolck:miniBlock];
    [addressView setMaxSelectBolck:maxBlock];
    [addressView setIdentifyTag:tag];
    [LCLAlertController alertFromWindowWithView:addressView alertStyle:LCLAlertStyleMoveBottomFull tag:AlertTypePickerViewTag];
}

- (void)dealloc{
    
    self.miniArray = nil;
    self.maxArray  =nil;
    
    self.miniSelectBolck = nil;
    self.maxSelectBolck = nil;
}

- (void)awakeFromNib{
    
    [self setBackgroundColor:APPPurpleColor];
}

- (IBAction)tapCancleButton:(UIButton *)sender{
    
    self.miniArray = nil;
    self.maxArray  =nil;
    
    self.miniSelectBolck = nil;
    self.maxSelectBolck = nil;
    
    [LCLAlertController dismissAlertViewWithTag:AlertTypePickerViewTag];
}

- (IBAction)tapSaveButton:(id)sender{
    
    NSInteger minirow = [self.miniSelectPicker selectedRowInComponent:0];
    NSString *mini = [self.miniArray objectAtIndex:minirow];
    
    NSInteger maxrow = [self.maxSelectPicker selectedRowInComponent:0];
    NSString *max = [self.maxArray objectAtIndex:maxrow];
    
    if ([max integerValue]<[mini integerValue]) {
        
        [LCLTipsView showTips:@"最小值不能大于最大值" location:LCLTipsLocationMiddle];
        
        return;
    }
    
    if (self.miniSelectBolck) {
        self.miniSelectBolck(mini);
    }

    if (self.maxSelectBolck) {
        self.maxSelectBolck(max);
    }

    [self tapCancleButton:sender];
    
    self.miniArray = nil;
    self.maxArray  =nil;
    
    self.miniSelectBolck = nil;
    self.maxSelectBolck = nil;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag==100) {
        return self.miniArray.count;
    }
    return self.maxArray.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerView.tag==100) {
        NSString *str = [self.miniArray objectAtIndex:row];
        return [str stringByAppendingString:self.identifyTag];
    }else{
        NSString *str = [self.maxArray objectAtIndex:row];
        return [str stringByAppendingString:self.identifyTag];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
