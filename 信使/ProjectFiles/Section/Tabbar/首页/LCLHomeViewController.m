//
//  LCLHomeViewController.m
//  信使
//
//  Created by 李程龙 on 15/5/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLHomeViewController.h"

#import "LCLHomeTableViewCell.h"
#import "LCLPeopleInfoViewController.h"
#import "LCLCreateMeetingViewController.h"

#import <MapKit/MapKit.h>


@interface LCLHomeViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (strong, nonatomic) UIButton *messageBtn;
@property (nonatomic) NSInteger page;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) NSString *lat;

@property (strong, nonatomic) CLLocationManager *locationManager;//定义Manager

@end

@implementation LCLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        }
        
        self.locationManager.delegate=self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=10;
        [self.locationManager requestWhenInUseAuthorization];//添加这句
        [self.locationManager startUpdatingLocation];
        
    }else {
        //提示用户无法进行定位操作
        
        [LCLTipsView showTips:@"亲，定位服务还没打开呢" location:LCLTipsLocationMiddle];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSearchNotify:) name:SearchNotificationKey object:nil];
    
    self.page = 1;
    
    [self.navigationItem setTitle:@"首页"];
    
    [self.view addSubview:self.tableView];
    
    [self setNotifyMessageNavigationItem];
    
    [self setMessageNavigationItem];
    
    @weakify(self);
    
    [self_weak_.tableView addHeaderWithCallback:^{
        
        [self_weak_ loadServerData];
    }];
    
    [self_weak_.tableView addFooterWithCallback:^{
        
        [self_weak_ loadMoreData];
    }];
    
    [self_weak_.tableView headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)receiveSearchNotify:(NSNotification *)notify{

    NSDictionary *obj = [notify object];
    if (obj.count>0) {
        [self loadSearchDataWithDic:obj];
    }
}

//设置右侧消息item
- (void)setMessageNavigationItem{
    
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.messageBtn.frame = CGRectMake(0, 0, 25, 25);
    [self.messageBtn setImage:[UIImage imageNamed:@"im"] forState:UIControlStateNormal];
    [self.messageBtn setImage:[UIImage imageNamed:@"im"] forState:UIControlStateHighlighted];
    [self.messageBtn setShouldAllowMaxNumber:YES];
    NSString *num = [[LCLCacheDefaults standardCacheDefaults] objectForCacheKey:ReceiveNotificationKey];
    if ([num intValue]==1) {
        [self.messageBtn setBadgeValue:@"100"];
    }
    [self.messageBtn addTarget:self action:@selector(tapMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *messageItme = [[UIBarButtonItem alloc]initWithCustomView:self.messageBtn] ;
    self.navigationItem.rightBarButtonItem = messageItme;
}

- (IBAction)tapMessageAction:(id)sender{
   
    [LCLTipsView showTips:@"正在开发中" location:LCLTipsLocationMiddle];
}

- (IBAction)tapHomeButton:(UIButton *)sender{

    NSDictionary *dic = [self.dataArray objectAtIndex:sender.tag];

    LCLPeopleInfoViewController *people = [[LCLPeopleInfoViewController alloc] initWithNibName:@"LCLPeopleInfoViewController" bundle:nil];
    [people setUserInfo:dic];
    [people setTitle:@"个人主页"];
    [people setHidesBottomBarWhenPushed:YES];
    [people setIsFromMe:NO];
    [self.navigationController pushViewController:people animated:YES];
}

- (IBAction)tapYueHuiButton:(UIButton *)sender{
    
    NSDictionary *dic = [self.dataArray objectAtIndex:sender.tag];
    LCLIndexObject *indexObj = [LCLIndexObject allocModelWithDictionary:dic];

    if ([indexObj.style integerValue]==2) {
        
        LCLCreateMeetingViewController *createMeet = [[LCLCreateMeetingViewController alloc] initWithNibName:@"LCLCreateMeetingViewController" bundle:nil];
        [createMeet setInviteuid:indexObj.uid];
        [createMeet setIsInviteMeet:YES];
        [createMeet setCanShowNavBackItem:YES];
        [createMeet setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:createMeet animated:NO];
        
    }else{
    
        @weakify(self);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"报名约会需要%@金币，确定报名？", indexObj.redbag] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
            if ([index integerValue]==1) {
                [self_weak_ baomingWithID:indexObj.iD];
            }
        }];
        [alertView show];
        
//        if ([indexObj.is_follow intValue]==1) {
//            
//            [LCLTipsView showTips:@"您已报名" location:LCLTipsLocationMiddle];
//        }else{
//
//            [self baomingWithID:indexObj.iD];
//        }
    }
}

- (IBAction)tapImageViewGesture:(UITapGestureRecognizer *)gesture{

    UIImageView *imageView = (UIImageView *)gesture.view;
    NSString *uid = imageView.restorationIdentifier;
    
    [self lookPicWithUID:uid fromImageView:imageView index:0];
}

- (IBAction)tapPhoneButton:(UIButton *)sender{
    
    @weakify(self);

    NSDictionary *dic = [self.dataArray objectAtIndex:sender.tag];
    LCLIndexObject *indexObj = [LCLIndexObject allocModelWithDictionary:dic];
    
    if ([indexObj.phone integerValue]==0) {
        
        [LCLWaitView showIndicatorView:YES];
        
        NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
        if (userInfo) {
            
            LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
            
            NSString *listURL = [NSString stringWithFormat:@"%@", LookPhoneMoneyURL(userObj.ukey)];
            
            LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
            [downloader setHttpMehtod:LCLHttpMethodGet];
            [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
                
                [LCLWaitView showIndicatorView:NO];
                
                NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
                if (dataSourceDic) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"查看手机需要%@金币，确定查看？", [dataSourceDic objectForKey:@"coin"]] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
                        if ([index integerValue]==1) {
                            [self_weak_ lookPhoneWithUID:indexObj.uid phone:indexObj.phone];
                        }
                    }];
                    [alertView show];
                }
            }];
            [downloader startToDownloadWithIntelligence:NO];
        }
    }else{
    
        [self_weak_ lookPhoneWithUID:indexObj.uid phone:indexObj.phone];
    }
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 288-128+kDeviceWidth*270/360.0+10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    LCLHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = (LCLHomeTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"LCLHomeTableViewCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell.homeButton setTag:indexPath.row];
    [cell.yuehuiButton setTag:indexPath.row];
    [cell.phoneButton setTag:indexPath.row];

    [cell.homeButton addTarget:self action:@selector(tapHomeButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.yuehuiButton addTarget:self action:@selector(tapYueHuiButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.phoneButton addTarget:self action:@selector(tapPhoneButton:) forControlEvents:UIControlEventTouchUpInside];

    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    LCLIndexObject *indexObj = [LCLIndexObject allocModelWithDictionary:dic];
    
    [cell.contentLabel setText:indexObj.title];
    [cell setPeopleNameWithName:indexObj.nickname];
    [cell.peopleInfoLabel setText:[NSString stringWithFormat:@"%@岁  %@cm  %@kg", indexObj.age, indexObj.height, indexObj.weight]];
    [cell.imageNumberLabel setText:[NSString stringWithFormat:@"%@张", indexObj.pic_count]];
    if ([indexObj.pic_count integerValue]<=1) {
        [cell.imageNumberLabel setHidden:YES];
    }
    
    NSDictionary *vipInfo = indexObj.vipInfo;
    if (vipInfo) {
        [cell.levelImageView setImageWithURL:[vipInfo objectForKey:@"pic"] defaultImagePath:DefaultImagePath];
    }else{
        [cell.levelImageView setHidden:YES];
    }
    if ([indexObj.video integerValue]==1) {
        [cell.movieImageView setHidden:NO];
    }else{
        [cell.movieImageView setHidden:YES];
    }
    
    if ([indexObj.style integerValue]==2) {
        [cell.yuehuiButton setTitle:@"邀请约会" forState:UIControlStateNormal];
    }
    
    [cell.addressLabel setText:indexObj.place];
    [cell.timeLabel setTitle:[NSString stringWithFormat:@"%@ km|%@", indexObj.len, indexObj.times] forState:UIControlStateNormal];
    if ([[NSString stringWithFormat:@"%@", indexObj.len] isEqualToString:@"未知"]) {
        [cell.timeLabel setTitle:[NSString stringWithFormat:@"%@|%@", indexObj.len, indexObj.times] forState:UIControlStateNormal];
    }
    
    CGRect frame = cell.contentImageView.frame;
    frame.size.height = kDeviceWidth*270/360.0;
    [cell.contentImageView setFrame:frame];
    
    NSDictionary *picInfo = indexObj.pic;
    NSString *cansee = [picInfo objectForKey:@"see"];
    if ([cansee integerValue]==1) {
        [cell.contentImageView setImageWithURL:[picInfo objectForKey:@"thumb_360"] defaultImagePath:DefaultImagePath];
    }else{
        [cell.contentImageView setImageWithURL:[picInfo objectForKey:@"thumb_360"] defaultImagePath:DefaultImagePath];
//        [cell.contentImageView setImageWithURL:[picInfo objectForKey:@"thumb_360"] defaultImagePath:DefaultImagePath blur:0.1];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewGesture:)];
    [cell.contentImageView setUserInteractionEnabled:YES];
    [cell.contentImageView addGestureRecognizer:tapGesture];
    [cell.contentImageView setRestorationIdentifier:indexObj.uid];
    
    NSString *peopleURL = GetDownloadPicURL(indexObj.headimg);
    [cell.peopleHeadButton setBackgroundImageWithURL:peopleURL
                             defaultImagePath:DefaultImagePath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    [manager stopUpdatingLocation];
    
    NSString *strLat = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.latitude];
    NSString *strLng = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude];
    NSLog(@"Lat: %@ Lng: %@", strLat, strLng);

    self.lat = strLat;
    self.lng = strLng;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *newLocation = [locations lastObject];
    
    [manager stopUpdatingLocation];
    
    NSString *strLat = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.latitude];
    NSString *strLng = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude];
    NSLog(@"Lat: %@ Lng: %@", strLat, strLng);

    self.lat = strLat;
    self.lng = strLng;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status==3 || status==4) {
        
        [manager startUpdatingLocation];
        
    }else{
        
        [LCLTipsView showTips:@"亲，请打开位置服务" location:LCLTipsLocationMiddle];
        
        [manager stopUpdatingLocation];
    }
}


#pragma mark GETTER
- (UITableView *)tableView{

    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
        [_tableView setSeparatorColor:[UIColor clearColor]];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

#pragma mark -下载数据
- (void)loadServerData{
    
    self.page = 1;
    
    @weakify(self);
    
    [self_weak_.tableView hideEmptyDataTips];
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@?num=5&page=%li", IndexListURL(userObj.ukey), self.page];
        
        if (self_weak_.lng && self_weak_.lat) {
            listURL = [NSString stringWithFormat:@"%@&lon=%@&lat=%@", listURL, self.lng, self.lat];
        }
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                self_weak_.dataArray = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"list"]];
                [self_weak_.tableView reloadData];
            }
            
            if (self_weak_.dataArray.count>0) {
                self_weak_.page = self_weak_.page+1;
                [self_weak_.tableView hideEmptyDataTips];
            }else{
                [self_weak_.tableView showEmptyDataTips:DefaultEmptyDataText tipsFrame:DefaultEmptyDataFrame];
            }
            
            [self_weak_.tableView headerEndRefreshing];
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }else{
        
        [self_weak_.tableView hideEmptyDataTips];
        [self_weak_.view showUnloginInfoView:YES];
        
        LCLMainQueue(^{
            [self_weak_.tableView headerEndRefreshing];
        });
    }
}

- (void)loadMoreData{
    
    @weakify(self);
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
    
    NSString *listURL = [NSString stringWithFormat:@"%@?num=5&page=%li", IndexListURL(userObj.ukey), self.page];
    
    if (self_weak_.lng && self_weak_.lat) {
        listURL = [NSString stringWithFormat:@"%@&lon=%@&lat=%@", listURL, self.lng, self.lat];
    }

    LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
    [downloader setHttpMehtod:LCLHttpMethodGet];
    [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
        
        NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
        if (dataSourceDic) {
            
            if (self_weak_.dataArray.count>0) {
                self_weak_.page = self_weak_.page+1;
                [self_weak_.dataArray addObjectsFromArray:[dataSourceDic objectForKey:@"list"]];
            }else{
                self_weak_.dataArray = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"list"]];
            }
            
            [self_weak_.tableView reloadData];
        }
        
        [self_weak_.tableView footerEndRefreshing];
    }];
    [downloader startToDownloadWithIntelligence:NO];
}



- (void)lookPhoneWithUID:(NSString *)uid phone:(NSString *)phone{
    
    @weakify(self);
    
    [LCLWaitView showIndicatorView:YES];
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", LookPhoneURL(userObj.ukey, uid)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            [LCLWaitView showIndicatorView:NO];
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[dataSourceDic objectForKey:@"phone"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
}


- (void)loadSearchDataWithDic:(NSDictionary *)dic{
    
    @weakify(self);
    
    [self_weak_.tableView hideEmptyDataTips];
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        [LCLWaitView showIndicatorView:YES];

        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        __block NSString *listURL = [NSString stringWithFormat:@"%@?num=50", IndexListURL(userObj.ukey)];
        
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            
            listURL = [listURL stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, obj]];
        }];
        
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            [LCLWaitView showIndicatorView:NO];

            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                self_weak_.dataArray = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"list"]];
            }
            
            if (self_weak_.dataArray.count>0) {
                [self_weak_.tableView hideEmptyDataTips];
            }else{
                [self_weak_.tableView showEmptyDataTips:DefaultEmptyDataText tipsFrame:DefaultEmptyDataFrame];
            }
            
            [self_weak_.tableView reloadData];

            [self_weak_.tableView headerEndRefreshing];
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }else{
        
        [self_weak_.tableView hideEmptyDataTips];
        [self_weak_.view showUnloginInfoView:YES];
        
        LCLMainQueue(^{
            [self_weak_.tableView headerEndRefreshing];
        });
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







