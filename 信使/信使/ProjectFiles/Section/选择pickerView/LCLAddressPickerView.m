//
//  LCLSelectPickerView.m
//  信使
//
//  Created by apple on 15/9/25.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLAddressPickerView.h"

@interface LCLAddressPickerView () <UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *miniSelectPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *maxSelectPicker;

@property (strong, nonatomic) NSMutableArray *provinceArray;
@property (strong, nonatomic) NSMutableArray *cityArray;

@property (copy, nonatomic) LCLSelectBolck miniSelectBolck;
@property (copy, nonatomic) LCLSelectBolck maxSelectBolck;

@end

@implementation LCLAddressPickerView

+ (void)showWithMiniCompleteBlock:(LCLSelectBolck)miniBlock  maxCompleteBlock:(LCLSelectBolck)maxBlock provinceArray:(NSMutableArray *)provinceArray{

    LCLAddressPickerView *addressView = [LCLAddressPickerView loadXibView];
    [addressView setFrame:CGRectMake(0, 0, kDeviceWidth, 210)];
    [addressView setMiniSelectBolck:miniBlock];
    [addressView setMaxSelectBolck:maxBlock];
    if (provinceArray.count==0) {
        [addressView getServerCityList];
    }else{
        NSDictionary *dic = [provinceArray objectAtIndex:0];
        [addressView setProvinceArray:provinceArray];
        [addressView setCityArray:[dic objectForKey:@"list"]];
    }
    
    [LCLAlertController setHideStatusBar:NO];
    [LCLAlertController alertFromWindowWithView:addressView alertStyle:LCLAlertStyleMoveBottomFull tag:AlertAddressPickerViewTag];
}

- (void)dealloc{
    
    self.provinceArray  =nil;
    
    self.miniSelectBolck = nil;
    self.maxSelectBolck = nil;
}

- (void)awakeFromNib{
    
    [self setBackgroundColor:APPPurpleColor];
}

- (IBAction)tapCancleButton:(UIButton *)sender{
    
    self.provinceArray  =nil;
    
    self.miniSelectBolck = nil;
    self.maxSelectBolck = nil;
    
    [LCLAlertController dismissAlertViewWithTag:AlertAddressPickerViewTag];
}

- (IBAction)tapSaveButton:(id)sender{
    
    if (self.provinceArray.count>0 && self.cityArray.count>0) {
        
        NSInteger minirow = [self.miniSelectPicker selectedRowInComponent:0];
        NSDictionary *miniDic = [self.provinceArray objectAtIndex:minirow];
        
        NSInteger maxrow = [self.maxSelectPicker selectedRowInComponent:0];
        NSDictionary *maxDic = [self.cityArray objectAtIndex:maxrow];
        
        if (self.miniSelectBolck) {
            self.miniSelectBolck(miniDic);
        }
        
        if (self.maxSelectBolck) {
            self.maxSelectBolck(maxDic);
        }
        
        [self tapCancleButton:sender];
        
        self.provinceArray = nil;
        
        self.miniSelectBolck = nil;
        self.maxSelectBolck = nil;

    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag==100) {
        return self.provinceArray.count;
    }

    return self.cityArray.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerView.tag==100) {
        NSDictionary *dic = [self.provinceArray objectAtIndex:row];
        return [dic objectForKey:@"areaname"];
    }else{
        NSDictionary *dic = [self.cityArray objectAtIndex:row];
        return [dic objectForKey:@"areaname"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView.tag==100) {
        NSDictionary *dic = [self.provinceArray objectAtIndex:row];
        self.cityArray  = [dic objectForKey:@"list"];
        [self.maxSelectPicker reloadAllComponents];
    }
}




#pragma mark - 获取城市列表
- (void)getServerCityList{
    
    @weakify(self);
    
    [LCLWaitView showIndicatorView:YES];
    
    LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:GetCityURL];
    [login setHttpMehtod:LCLHttpMethodGet];
    [login setEncryptType:LCLEncryptTypeNone];
    [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
        
        NSDictionary *dataDic = [self_weak_ getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
        if (dataDic) {
            
            self_weak_.provinceArray = [[NSMutableArray alloc] initWithArray:[dataDic objectForKey:@"list"]];
            if (self_weak_.provinceArray.count>0) {
                
                for (int i=0; i<self_weak_.provinceArray.count; i++) {
                    
                    NSMutableDictionary *provinceDic = [[NSMutableDictionary alloc] initWithDictionary:[self_weak_.provinceArray objectAtIndex:i]];
                    NSString *num = [provinceDic objectForKey:@"no"];
                    if (!num) {
                        num = @"";
                    }
                    
                    LCLDownloader *download = [[LCLDownloader alloc] initWithURLString:[NSString stringWithFormat:@"%@no=%@", GetCityURL, num]];
                    [download setHttpMehtod:LCLHttpMethodGet];
                    [download setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
                        
                        NSDictionary *dataDic = [self_weak_ getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
                        if (dataDic) {
                            NSArray *list = [dataDic objectForKey:@"list"];
                            if (list) {
                                [provinceDic setObject:list forKey:@"list"];
                            }else{
                                [provinceDic setObject:[[NSArray alloc]init] forKey:@"list"];
                            }
                        }else{
                            [provinceDic setObject:[[NSArray alloc]init] forKey:@"list"];
                        }
                        
                        [self_weak_.provinceArray replaceObjectAtIndex:i withObject:provinceDic];
                        
                        if ([[LCLNetworkManager sharedLCLARCNetManager] operationQueue].operationCount==1) {
                            [LCLWaitView showIndicatorView:NO];
                            
                            NSDictionary *dic = [self_weak_.provinceArray objectAtIndex:0];
                            [self_weak_ setCityArray:[dic objectForKey:@"list"]];
                            
                            [self_weak_.miniSelectPicker reloadAllComponents];
                            [self_weak_.maxSelectPicker reloadAllComponents];
                        }
                    }];
                    [download startToDownloadWithIntelligence:NO];
                }
            }else{
                [LCLWaitView showIndicatorView:NO];
            }
        }else{
            [LCLWaitView showIndicatorView:NO];
        }
    }];
    [login startToDownloadWithIntelligence:NO];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
