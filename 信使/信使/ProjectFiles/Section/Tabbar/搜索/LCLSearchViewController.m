//
//  LCLSearchViewController.m
//  信使
//
//  Created by 李程龙 on 15/5/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLSearchViewController.h"

#import "LCLMapViewController.h"

@interface LCLSearchViewController () <LCLMapViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;
@property (weak, nonatomic) IBOutlet UIButton *heightButton;
@property (weak, nonatomic) IBOutlet UIButton *weightButton;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;

@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *cityID;

@property (strong, nonatomic) NSString *miniage;
@property (strong, nonatomic) NSString *miniheight;
@property (strong, nonatomic) NSString *miniweight;
@property (strong, nonatomic) NSString *maxage;
@property (strong, nonatomic) NSString *maxheight;
@property (strong, nonatomic) NSString *maxweight;

@property (strong, nonatomic) NSString *pic;
@property (strong, nonatomic) NSString *verify;

@property (strong, nonatomic) NSMutableArray *provinceArray;

@end

@implementation LCLSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"搜索"];
    
    [self.resetButton setRoundedRadius:4.0];
    [self.sureButton setRoundedRadius:4.0];
    
    [self getServerCityList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCity:(NSString *)city{
    _city = city;
    if (city) {
        [self.cityButton setTitle:city forState:UIControlStateNormal];
    }else{
        [self.cityButton setTitle:@"不限" forState:UIControlStateNormal];
    }
}

- (void)setMiniage:(NSString *)miniage{
    _miniage = miniage;
    if (miniage) {
        [self.ageButton setTitle:[NSString stringWithFormat:@"%@岁-%@岁", _miniage, _maxage] forState:UIControlStateNormal];
    }else{
        [self.ageButton setTitle:@"不限" forState:UIControlStateNormal];
    }
}

- (void)setMaxage:(NSString *)maxage{
    _maxage = maxage;
    if (maxage) {
        [self.ageButton setTitle:[NSString stringWithFormat:@"%@岁-%@岁", _miniage, _maxage] forState:UIControlStateNormal];
    }else{
        [self.ageButton setTitle:@"不限" forState:UIControlStateNormal];
    }
}

- (void)setMiniheight:(NSString *)miniheight{
    _miniheight = miniheight;
    if (miniheight) {
        [self.heightButton setTitle:[NSString stringWithFormat:@"%@cm-%@cm", _miniheight, _maxheight] forState:UIControlStateNormal];
    }else{
        [self.heightButton setTitle:@"不限" forState:UIControlStateNormal];
    }
}

- (void)setMaxheight:(NSString *)maxheight{
    _maxheight = maxheight;
    if (maxheight) {
        [self.heightButton setTitle:[NSString stringWithFormat:@"%@cm-%@cm", _miniheight, _maxheight] forState:UIControlStateNormal];
    }else{
        [self.heightButton setTitle:@"不限" forState:UIControlStateNormal];
    }
}

- (void)setMiniweight:(NSString *)miniweight{
    _miniweight = miniweight;
    if (miniweight) {
        [self.weightButton setTitle:[NSString stringWithFormat:@"%@kg-%@kg", _miniweight, _maxweight] forState:UIControlStateNormal];
    }else{
        [self.weightButton setTitle:@"不限" forState:UIControlStateNormal];
    }
}

- (void)setMaxweight:(NSString *)maxweight{
    _maxweight = maxweight;
    if (maxweight) {
        [self.weightButton setTitle:[NSString stringWithFormat:@"%@kg-%@kg", _miniweight, _maxweight] forState:UIControlStateNormal];
    }else{
        [self.weightButton setTitle:@"不限" forState:UIControlStateNormal];
    }
}

- (void)setPic:(NSString *)pic{
    _pic = pic;
    if (pic) {
        if ([pic isEqualToString:@"0"]) {
            [self.pictureButton setTitle:@"否" forState:UIControlStateNormal];
        }else if ([pic isEqualToString:@"1"]){
            [self.pictureButton setTitle:@"有" forState:UIControlStateNormal];
        }else if ([pic isEqualToString:@"-1"]){
            [self.pictureButton setTitle:@"不限" forState:UIControlStateNormal];
        }
    }else{
        [self.pictureButton setTitle:@"不限" forState:UIControlStateNormal];
    }
}

- (void)setVerify:(NSString *)verify{
    _verify = verify;
    if (verify) {
        if ([verify isEqualToString:@"0"]) {
            [self.verifyButton setTitle:@"否" forState:UIControlStateNormal];
        }else if ([verify isEqualToString:@"1"]){
            [self.verifyButton setTitle:@"有" forState:UIControlStateNormal];
        }else if ([verify isEqualToString:@"-1"]){
            [self.verifyButton setTitle:@"不限" forState:UIControlStateNormal];
        }
    }else{
        [self.verifyButton setTitle:@"不限" forState:UIControlStateNormal];
    }
}

- (IBAction)tapCityButton:(UIButton *)sender{

//    LCLMapViewController *map = [[LCLMapViewController alloc] initWithNibName:@"LCLMapViewController" bundle:nil];
//    [map setHidesBottomBarWhenPushed:YES];
//    map.mapDelegate = self;
//    [self.navigationController pushViewController:map animated:YES];
    
    @weakify(self);
    
    [LCLAddressPickerView showWithMiniCompleteBlock:^(NSDictionary *province) {
        
        
    } maxCompleteBlock:^(NSDictionary *city) {
        
        self_weak_.city = [city objectForKey:@"areaname"];
        self_weak_.cityID = [city objectForKey:@"no"];

    } provinceArray:self_weak_.provinceArray];

}


- (IBAction)tapAgeButton:(UIButton *)sender{
  
    @weakify(self);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=18; i<50; i++) {
        [array addObject:[NSString stringWithFormat:@"%i", i]];
    }
    
    [LCLSelectPickerView showWithMiniCompleteBlock:^(NSString *miniage) {
        self_weak_.miniage = miniage;
    } miniArray:array maxCompleteBlock:^(NSString *maxage) {
        self_weak_.maxage = maxage;
    } maxArray:array tag:@"岁"];

}

- (IBAction)tapHeightButton:(UIButton *)sender{
    
    @weakify(self);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=140; i<190; i++) {
        [array addObject:[NSString stringWithFormat:@"%i", i]];
    }
    
    [LCLSelectPickerView showWithMiniCompleteBlock:^(NSString *miniage) {
        self_weak_.miniheight = miniage;
    } miniArray:array maxCompleteBlock:^(NSString *maxage) {
        self_weak_.maxheight = maxage;
    } maxArray:array tag:@"cm"];

}

- (IBAction)tapWeightButton:(UIButton *)sender{
    
    @weakify(self);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=40; i<70; i++) {
        [array addObject:[NSString stringWithFormat:@"%i", i]];
    }
    
    [LCLSelectPickerView showWithMiniCompleteBlock:^(NSString *miniage) {
        self_weak_.miniweight = miniage;
    } miniArray:array maxCompleteBlock:^(NSString *maxage) {
        self_weak_.maxweight = maxage;
    } maxArray:array tag:@"kg"];
}

- (IBAction)tapPictureButton:(UIButton *)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否有图片" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"有", @"没有", @"不限", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *indexButton) {
        NSInteger tag = [indexButton integerValue];
        if (tag==0) {
            //是
            self.pic = @"1";
        }else if (tag==1){
            //否
            self.pic = @"0";
        }else if (tag==2){
            //不限
            self.pic = @"-1";
        }
    }];
}

- (IBAction)tapVerifyButton:(UIButton *)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否认证" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"有", @"没有", @"不限", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *indexButton) {
        NSInteger tag = [indexButton integerValue];
        if (tag==0) {
            //是
            self.verify = @"1";
        }else if (tag==1){
            //否
            self.verify = @"0";
        }else if (tag==2){
            //不限
            self.verify = @"-1";
        }
    }];
}

- (IBAction)tapResetButton:(id)sender{
    
    self.city = nil;
    self.miniage = nil;
    self.maxage = nil;
    self.miniheight = nil;
    self.maxheight = nil;
    self.miniweight = nil;
    self.maxweight = nil;
    self.pic = @"-1";
    self.verify = @"-1";
}

- (IBAction)tapSureButton:(id)sender{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (self.city) {
        [dic setObject:self.cityID forKey:@"place"];
    }
    
    if (self.miniage) {
        [dic setObject:self.miniage forKey:@"min_age"];
    }
    
    if (self.maxage) {
        [dic setObject:self.maxage forKey:@"max_age"];
    }
    
    if (self.miniheight) {
        [dic setObject:self.miniheight forKey:@"min_height"];
    }
    
    if (self.maxheight) {
        [dic setObject:self.maxheight forKey:@"max_height"];
    }
    
    if (self.miniweight) {
        [dic setObject:self.miniweight forKey:@"min_weight"];
    }
    
    if (self.maxweight) {
        [dic setObject:self.maxweight forKey:@"max_weight"];
    }

    if ([self.pic isEqualToString:@"0"]) {
        [dic setObject:@"2" forKey:@"headimg"];
    }else if ([self.pic isEqualToString:@"1"]){
        [dic setObject:@"1" forKey:@"headimg"];
    }else{
        [dic setObject:@"0" forKey:@"headimg"];
    }
    
    if ([self.verify isEqualToString:@"0"]) {
        [dic setObject:@"2" forKey:@"verify"];
    }else if ([self.verify isEqualToString:@"1"]){
        [dic setObject:@"1" forKey:@"verify"];
    }else{
        [dic setObject:@"0" forKey:@"verify"];
    }
    
    if (dic.count>0) {
        [self postNotificationWithName:SearchNotificationKey object:dic];
        [self.tabBarController setSelectedIndex:0];
    }
}

- (void)didSelectLng:(CGFloat)lng lat:(CGFloat)lat place:(NSString *)place{

    self.city = place;
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
    [login startToDownloadWithIntelligence:YES];
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













