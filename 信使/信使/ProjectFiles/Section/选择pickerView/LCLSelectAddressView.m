//
//  LCLSelectAddressView.m
//  Fruit
//
//  Created by lichenglong on 15/7/20.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLSelectAddressView.h"

@interface LCLSelectAddressView ()

@property (weak, nonatomic) IBOutlet UIPickerView *typeSelectPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *moneySelectPicker;

@property (strong, nonatomic) NSMutableArray *typeArray;
@property (strong, nonatomic) NSMutableArray *moneyArray;

@property (copy, nonatomic) LCLSelectBolck typeSelectBolck;
@property (copy, nonatomic) LCLSelectBolck moneySelectBolck;

@end

@implementation LCLSelectAddressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)showWithTypeCompleteBlock:(LCLSelectBolck)typeBlock moneyCompleteBlock:(LCLSelectBolck)moneyBlock{

    NSMutableArray *type = [[NSMutableArray alloc] initWithObjects:@"获取红包", @"赠送红包", nil];
    NSMutableArray *money = [[NSMutableArray alloc] initWithObjects:@"100", @"200", @"300", @"400", @"500", @"800", @"1000", nil];

    [LCLAlertController setHideStatusBar:NO];

    LCLSelectAddressView *addressView = [LCLSelectAddressView loadXibView];
    [addressView setFrame:CGRectMake(0, 0, kDeviceWidth, 210)];
    [addressView setTypeSelectBolck:typeBlock];
    [addressView setMoneySelectBolck:moneyBlock];
    [addressView setTypeArray:type];
    [addressView setMoneyArray:money];
    [LCLAlertController alertFromWindowWithView:addressView alertStyle:LCLAlertStyleMoveBottomFull tag:AlertMoneyTypeViewTag];
}

- (void)dealloc{

    self.typeArray = nil;
    self.moneyArray = nil;
    self.typeSelectBolck  =nil;
    self.moneySelectBolck = nil;
}

- (void)awakeFromNib{

    [self setBackgroundColor:APPPurpleColor];
}

- (IBAction)tapCancleButton:(UIButton *)sender{

    self.typeArray = nil;
    self.moneyArray = nil;
    self.typeSelectBolck  =nil;
    self.moneySelectBolck = nil;
    
    [LCLAlertController dismissAlertViewWithTag:AlertMoneyTypeViewTag];
}

- (IBAction)tapSaveButton:(id)sender{
    
    NSInteger typerow = [self.typeSelectPicker selectedRowInComponent:0];
    NSString *type = [self.typeArray objectAtIndex:typerow];

    if (self.typeSelectBolck) {
        self.typeSelectBolck(type);
    }
    
    NSInteger moneyrow = [self.moneySelectPicker selectedRowInComponent:0];
    NSString *money = [self.moneyArray objectAtIndex:moneyrow];
    
    if (self.moneySelectBolck) {
        self.moneySelectBolck(money);
    }
    
    [self tapCancleButton:sender];
    
    self.typeArray = nil;
    self.moneyArray = nil;
    self.typeSelectBolck  =nil;
    self.moneySelectBolck = nil;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag==100) {
        return self.typeArray.count;
    }
    return self.moneyArray.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerView.tag==100) {
        NSString *str = [self.typeArray objectAtIndex:row];
        return str;
    }else{
        NSString *str = [self.moneyArray objectAtIndex:row];
        return [str stringByAppendingString:@"信用豆"];
    }
}

@end










