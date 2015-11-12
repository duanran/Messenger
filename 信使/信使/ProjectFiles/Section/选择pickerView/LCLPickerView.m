//
//  LCLPickerView.m
//  信使
//
//  Created by apple on 15/9/27.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLPickerView.h"

@interface LCLPickerView ()

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (copy, nonatomic) LCLSelectBolck selectBolck;

@property (strong, nonatomic) NSString *identifyTag;

@end

@implementation LCLPickerView

+ (void)showPickerWithCompleteBlock:(LCLSelectBolck)block dataArray:(NSMutableArray *)dataArray tag:(NSString *)tag{

    [LCLAlertController setHideStatusBar:NO];

    LCLPickerView *addressView = [LCLPickerView loadXibView];
    [addressView setFrame:CGRectMake(0, 0, kDeviceWidth, 210)];
    [addressView setDataArray:dataArray];
    [addressView setSelectBolck:block];
    [addressView setIdentifyTag:tag];
    [LCLAlertController alertFromWindowWithView:addressView alertStyle:LCLAlertStyleMoveBottomFull tag:AlertPickerViewTag];
}

- (void)dealloc{
    
    self.dataArray  =nil;
    
    self.selectBolck = nil;
}

- (void)awakeFromNib{
    
    [self setBackgroundColor:APPPurpleColor];
}

- (IBAction)tapCancleButton:(UIButton *)sender{
    
    self.dataArray  =nil;
    
    self.selectBolck = nil;
    
    [LCLAlertController dismissAlertViewWithTag:AlertPickerViewTag];
}

- (IBAction)tapSaveButton:(id)sender{
    
    NSInteger minirow = [self.picker selectedRowInComponent:0];
    NSString *mini = [self.dataArray objectAtIndex:minirow];
    
    if (self.selectBolck) {
        self.selectBolck(mini);
    }

    [self tapCancleButton:sender];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.dataArray.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *str = [self.dataArray objectAtIndex:row];
    return [str stringByAppendingString:self.identifyTag];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
