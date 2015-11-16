//
//  LCLCreateMeetingViewController.m
//  信使
//
//  Created by lichenglong on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLCreateMeetingViewController.h"

#import "LCLMeetTypeView.h"
#import "LCLMapViewController.h"
#import "LCLSelectDateView.h"
#import "LCLSelectAddressView.h"

@interface LCLCreateMeetingViewController () <LCLMapViewControllerDelegate,LCLMeetTypeViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) NSString *cid;

@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *money;
@property (strong, nonatomic) NSDictionary *meetInfoDic;

@property (nonatomic) CGFloat lng;
@property (nonatomic) CGFloat lat;

@property (nonatomic) BOOL isGetMoneyType;

@end

@implementation LCLCreateMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"发布约会"];
    if (self.isInviteMeet) {
        [self.navigationItem setTitle:@"邀请约会"];
    }
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleBordered target:self action:@selector(createAction:)];
    [barItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = barItem;

    self.isGetMoneyType = YES;
    self.money = @"500";
    
    [self loadMeetInfoData];
    
    [self tapTypeButton:self.meetTypeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapMeetMoneyButton:(id)sender{

    @weakify(self);
    
    
    [LCLSelectAddressView showWithTypeCompleteBlock:^(NSString *type) {
       
        if ([type isEqualToString:@"获取红包"]) {
            self_weak_.isGetMoneyType = YES;
        }else{
            self_weak_.isGetMoneyType = NO;
        }
        
        [self_weak_.coinButton setTitle:[NSString stringWithFormat:@"%@[%@美元]", type, self_weak_.money] forState:UIControlStateNormal];
        
    } moneyCompleteBlock:^(NSString *m) {
        
        self_weak_.money = m;

        [self_weak_.coinButton setTitle:[NSString stringWithFormat:@"%@[%@美元]", self_weak_.isGetMoneyType ? @"获取红包" : @"赠送红包", self_weak_.money] forState:UIControlStateNormal];
    }];
}

- (IBAction)createAction:(id)sender{

    
    NSDictionary *userDic=[[LCLCacheDefaults standardCacheDefaults] objectForCacheKey:UserInfoKey];
    
    NSString *freezCoin=[userDic objectForKey:@"freezing_coin"];
    NSString *sxf=[userDic objectForKey:@"sxf"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发布约会" message:[NSString stringWithFormat:@"将冻结保证金【%@信用豆】，约会成功将扣除手续费【%@信用豆】",freezCoin,sxf] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate=self;
    [alertView show];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self createMeeting];
    }
}
- (IBAction)tapTimeButton:(id)sender{

//    @weakify(self);
//    
//    [LCLSelectDateView showFromWindowWithSelectBlock:^(NSString *time) {
//        self_weak_.time = time;
//        
//        [self_weak_.timeButton setTitle:time forState:UIControlStateNormal];
//    }];
    
    @weakify(self);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[NSString stringWithFormat:@"%i", 1]];
    [array addObject:[NSString stringWithFormat:@"%i", 2]];
    [array addObject:[NSString stringWithFormat:@"%i", 8]];
    [array addObject:[NSString stringWithFormat:@"%i", 12]];
    [array addObject:[NSString stringWithFormat:@"%i", 72]];

    
    [LCLPickerView showPickerWithCompleteBlock:^(NSString *object) {
        
        self_weak_.time = object;
    
        [self_weak_.timeButton setTitle:[NSString stringWithFormat:@"%@小时内有效", object] forState:UIControlStateNormal];

    } dataArray:array tag:@"(小时)"];
}

- (IBAction)selectMeetTypeButton:(UIButton *)sender{

    [self.meetTypeButton setTitle:sender.restorationIdentifier forState:UIControlStateNormal];
    [self.meetTypeButton setTag:sender.tag];
    
    [self.typeImageView setImage:sender.imageView.image];
    
    self.cid = [NSString stringWithFormat:@"%li", (long)sender.tag];
    
    [LCLAlertController dismissAlertViewWithTag:SelectMeetTypeViewTag];
}

- (IBAction)tapTypeButton:(id)sender{

    @weakify(self);
    
    [LCLAlertController setHideStatusBar:NO];

    LCLMeetTypeView *meet = [LCLMeetTypeView loadXibView];
    meet.delegate=self;
    [meet setSelectBlock:^(UIButton *button){
    
        [self_weak_ selectMeetTypeButton:button];
    }];
    [meet getMeetType];
    
    
    [meet setFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    
    [LCLAlertController alertFromWindowWithView:meet alertStyle:LCLAlertStyleCustom tag:SelectMeetTypeViewTag];
}
-(void)goBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tapMapButton:(id)sender{

    LCLMapViewController *map = [[LCLMapViewController alloc] initWithNibName:@"LCLMapViewController" bundle:nil];
    [map setHidesBottomBarWhenPushed:YES];
    map.mapDelegate = self;
    [self.navigationController pushViewController:map animated:YES];
}

- (void)didSelectLng:(CGFloat)lng lat:(CGFloat)lat place:(NSString *)place{

    self.place = place;
    self.lng = lng;
    self.lat = lat;
    
    [self.addressButton setTitle:place forState:UIControlStateNormal];
}

- (void)createMeeting{

    if (!self.cid) {
        
        [LCLTipsView showTips:@"请选择约会类型" location:LCLTipsLocationMiddle];
        
        return;
    }
    
    if (!self.place) {
        
        [LCLTipsView showTips:@"请选择约会地点" location:LCLTipsLocationMiddle];

        return;
    }

    if (!self.time) {
        
        [LCLTipsView showTips:@"请选择约会时间" location:LCLTipsLocationMiddle];

        return;
    }
    
    @weakify(self);
    
    NSDictionary *myInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (myInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:myInfo];
        
        [LCLWaitView showIndicatorView:YES];
        
        NSString *type = @"1";
        if (self_weak_.isInviteMeet) {
            type = @"2";
        }
        
        NSString *moneytype = @"1";
        if (self_weak_.isGetMoneyType) {
            moneytype = @"2";
        }

        NSString *registString = [[NSString alloc] initWithFormat:@"type=%@&cid=%@&redbag_type=%@&redbag=%@&place=%@&days=%@&lng=%f&lat=%f", type, self_weak_.cid, moneytype, self.money, self_weak_.place, self_weak_.time, self_weak_.lng, self_weak_.lat];
        if (self_weak_.isInviteMeet) {
            registString = [NSString stringWithFormat:@"%@&inviteuid=%@", registString, self_weak_.inviteuid];
        }
        
        LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:CreateMeetURL(userObj.ukey)];
        [login setHttpMehtod:LCLHttpMethodPost];
        [login setEncryptType:LCLEncryptTypeNone];
        [login setHttpBodyData:[registString dataUsingEncoding:NSUTF8StringEncoding]];
        [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
            
            NSDictionary *dataDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:self_weak_.isGetMoneyType ? @"发布成功" : @"邀请约会成功" error:@""];
            if (dataDic) {
                
                [self_weak_.navigationController popViewControllerAnimated:YES];
            }
            
            [LCLWaitView showIndicatorView:NO];
            
        }];
        [login startToDownloadWithIntelligence:NO];
    }
}


- (void)loadMeetInfoData{
    
    @weakify(self);
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", MeetInfoURL(userObj.ukey)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                self_weak_.meetInfoDic = [dataSourceDic objectForKey:@"info"];
                
                [self_weak_.topMeetInfoLabel setText:[self_weak_.meetInfoDic objectForKey:@"head"]];
                
                //自适应label高度
                CGRect oriFram=self_weak_.topMeetInfoLabel.frame;
                UILabel *contentLabel=[[UILabel alloc]init];
                contentLabel.frame=oriFram;
                contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
                contentLabel.numberOfLines=0;
                NSString *describeStr=self_weak_.topMeetInfoLabel.text;
                contentLabel.text=describeStr;
                contentLabel.font = [UIFont systemFontOfSize:13];
                CGSize size = [contentLabel sizeThatFits:CGSizeMake(contentLabel.frame.size.width, MAXFLOAT)];
                
                [self_weak_.topMeetInfoLabel setFrame:CGRectMake(oriFram.origin.x, oriFram.origin.y,oriFram.size.width, size.height)];
                
                
                
                
                
                
                [self_weak_.bottomMeetInfoLabel setText:[self_weak_.meetInfoDic objectForKey:@"bottom"]];
            }
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
}

-(IBAction)swithFunctionBtn:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
            [self tapTypeButton:btn];
            break;
        case 1:
            [self tapMeetMoneyButton:btn];
            break;
        case 2:
            [self tapMapButton:btn];
            break;
        case 3:
            [self tapTimeButton:btn];
            break;
        default:
            break;
    }

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
