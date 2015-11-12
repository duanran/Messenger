//
//  LCLEditMyInfoViewController.m
//  信使
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLEditMyInfoViewController.h"

@interface LCLEditMyInfoViewController ()

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;
@property (weak, nonatomic) IBOutlet UIButton *weightButton;
@property (weak, nonatomic) IBOutlet UIButton *heightButton;

@property (strong, nonatomic) NSMutableArray *provinceArray;

@property (strong, nonatomic) NSString *provinceID;
@property (strong, nonatomic) NSString *provinceName;
@property (strong, nonatomic) NSString *cityID;
@property (strong, nonatomic) NSString *cityName;

@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *height;

@end

@implementation LCLEditMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"修改个人资料"];
    
    [self.submitButton setRoundedRadius:4.0];
    
    [self setMyInfo];
    
    [self getServerCityList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMyInfo{

    NSDictionary *dic = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:dic];
    
    if (![userObj.cityname isEqualToString:@""]) {
        [self.addressButton setTitle:userObj.cityname forState:UIControlStateNormal];
    }
    if (![userObj.age isEqualToString:@""]) {
        [self.ageButton setTitle:userObj.age forState:UIControlStateNormal];
    }
    if (![userObj.height isEqualToString:@""]) {
        [self.heightButton setTitle:userObj.height forState:UIControlStateNormal];
    }
    if (![userObj.weight isEqualToString:@""]) {
        [self.weightButton setTitle:userObj.weight forState:UIControlStateNormal];
    }
}

- (void)setProvinceName:(NSString *)provinceName{
    _provinceName = provinceName;
    if (provinceName) {
        [self.addressButton setTitle:[NSString stringWithFormat:@"%@ %@", _provinceName, _cityName] forState:UIControlStateNormal];
    }else{
        [self.addressButton setTitle:@"请选择" forState:UIControlStateNormal];
    }
}

- (void)setCityName:(NSString *)cityName{
    _cityName = cityName;
    if (cityName) {
        [self.addressButton setTitle:[NSString stringWithFormat:@"%@ %@", _provinceName, _cityName] forState:UIControlStateNormal];
    }else{
        [self.addressButton setTitle:@"请选择" forState:UIControlStateNormal];
    }
}

- (void)setAge:(NSString *)age{
    _age = age;
    if (age) {
        [self.ageButton setTitle:[NSString stringWithFormat:@"%@岁", _age] forState:UIControlStateNormal];
    }else{
        [self.ageButton setTitle:@"请选择" forState:UIControlStateNormal];
    }
}

- (void)setWeight:(NSString *)weight{
    _weight = weight;
    if (weight) {
        [self.weightButton setTitle:[NSString stringWithFormat:@"%@kg", _weight] forState:UIControlStateNormal];
    }else{
        [self.weightButton setTitle:@"请选择" forState:UIControlStateNormal];
    }
}

- (void)setHeight:(NSString *)height{
    _height = height;
    if (height) {
        [self.heightButton setTitle:[NSString stringWithFormat:@"%@cm", _height] forState:UIControlStateNormal];
    }else{
        [self.heightButton setTitle:@"请选择" forState:UIControlStateNormal];
    }
}

- (IBAction)tapAddressButton:(id)sender{

    @weakify(self);
    
    [LCLAddressPickerView showWithMiniCompleteBlock:^(NSDictionary *province) {
        
        self_weak_.provinceName = [province objectForKey:@"areaname"];
        self_weak_.provinceID = [province objectForKey:@"no"];

    } maxCompleteBlock:^(NSDictionary *city) {
        
        self_weak_.cityName = [city objectForKey:@"areaname"];
        self_weak_.cityID = [city objectForKey:@"no"];
        
    } provinceArray:self_weak_.provinceArray];
}

- (IBAction)tapAgeButton:(id)sender{

    @weakify(self);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=18; i<60; i++) {
        [array addObject:[NSString stringWithFormat:@"%i", i]];
    }
    
    [LCLPickerView showPickerWithCompleteBlock:^(NSString *age) {
        
        self_weak_.age = age;
        
    } dataArray:array tag:@"岁"];
}

- (IBAction)tapHeightButton:(id)sender{
    
    @weakify(self);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=140; i<200; i++) {
        [array addObject:[NSString stringWithFormat:@"%i", i]];
    }
    
    [LCLPickerView showPickerWithCompleteBlock:^(NSString *object) {
        
        self_weak_.height = object;

    } dataArray:array tag:@"cm"];
}

- (IBAction)tapWeightButton:(id)sender{
    
    @weakify(self);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=40; i<80; i++) {
        [array addObject:[NSString stringWithFormat:@"%i", i]];
    }
    
    [LCLPickerView showPickerWithCompleteBlock:^(id object) {
        
        self_weak_.weight = object;
        
    } dataArray:array tag:@"kg"];
}

- (IBAction)tapSubmitButton:(id)sender{

    [self editAction];
}

#pragma mark - 获取城市列表
- (void)getServerCityList{
    
    @weakify(self);
    
    [LCLWaitView showIndicatorView:YES];
    
    LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:GetCityURL];
    [login setHttpMehtod:LCLHttpMethodGet];
    [login setEncryptType:LCLEncryptTypeNone];
    [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
        
        NSDictionary *dataDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
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
                        
                        NSDictionary *dataDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
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

- (void)editAction{
    
    @weakify(self);

    [LCLWaitView showIndicatorView:YES];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LCLGetToken checkHaveLoginWithShowLoginView:NO]];
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:dic];
    
    NSString *registString = [NSString stringWithFormat:@"password=%@", userObj.password];
    
    if (self.age) {
        [dic setObject:self.age forKey:@"age"];
        registString = [NSString stringWithFormat:@"%@&age=%@", registString, self.age];
    }
    if (self.height) {
        [dic setObject:self.height forKey:@"height"];
        registString = [NSString stringWithFormat:@"%@&height=%@", registString, self.height];
    }
    if (self.weight) {
        [dic setObject:self.weight forKey:@"weight"];
        registString = [NSString stringWithFormat:@"%@&weight=%@", registString, self.weight];
    }
    if (self.cityID) {
        [dic setObject:self.cityID forKey:@"city"];
        registString = [NSString stringWithFormat:@"%@&city=%@", registString, self.cityID];
        [dic setObject:self_weak_.cityName forKey:@"cityname"];
    }
    if (self.provinceID) {
        [dic setObject:self.provinceID forKey:@"province"];
        registString = [NSString stringWithFormat:@"%@&province=%@", registString, self.provinceID];
    }
    
    NSString *editURL = [NSString stringWithFormat:@"%@?%@", EditMyInfoURL(userObj.ukey), registString];
    LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:editURL];
    [login setHttpMehtod:LCLHttpMethodPost];
    [login setEncryptType:LCLEncryptTypeNone];
    [login setHttpBodyData:[registString dataUsingEncoding:NSUTF8StringEncoding]];
    [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
        
        NSDictionary *dataDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:@"修改成功" error:@""];
        if (dataDic) {
            
            [[LCLCacheDefaults standardCacheDefaults] setCacheObject:dic forKey:UserInfoKey];
            
            [self_weak_.navigationController popViewControllerAnimated:YES];
        }
        
        [LCLWaitView showIndicatorView:NO];
        
    }];
    [login startToDownloadWithIntelligence:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end













