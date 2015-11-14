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
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "LCLVideoViewController.h"
#import "updateLookPhoneDate.h"

#define contentImageViewTag 1000
#define dateBtnTag 2000
#define homeBtnTag 3000
#define phoneBtnTag 4000
#define cellSubViewTag 5000
#define contentLableTag 6000



@interface LCLHomeViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate,UIGestureRecognizerDelegate,MJPhotoBrowserDelegate,UIAlertViewDelegate,LCLPeopinfoDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (strong, nonatomic) UIButton *messageBtn;
@property (nonatomic) NSInteger page;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) NSString *lat;

@property (strong, nonatomic) CLLocationManager *locationManager;//定义Manager

@end

@implementation LCLHomeViewController

-(instancetype)init
{
    self=[super init];
    if (self) {
    
    
    }
    return self;
}
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
        //add by duanran begin
        if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
            [self.locationManager requestWhenInUseAuthorization];//添加这句
        }
        //end
        
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

    NSDictionary *dic = [self.dataArray objectAtIndex:sender.tag-homeBtnTag];

    LCLPeopleInfoViewController *people = [[LCLPeopleInfoViewController alloc] initWithNibName:@"LCLPeopleInfoViewController" bundle:nil];
    [people setUserInfo:dic];
    [people setTitle:@"个人主页"];
    people.UpDatedelegate=self;
    [people setHidesBottomBarWhenPushed:YES];
    [people setIsFromMe:NO];
    [self.navigationController pushViewController:people animated:YES];
}
-(void)upDateLookPhoneData
{
    [self updateData];
}
- (IBAction)tapYueHuiButton:(UIButton *)sender{
    
    NSDictionary *dic = [self.dataArray objectAtIndex:sender.tag-dateBtnTag];
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
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"报名约会需要%@信用豆，确定报名？", indexObj.redbag] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
-(void)playVideo:(NSString *)videoPath
{
    LCLVideoViewController *videoController=[[LCLVideoViewController alloc]init];
    videoController.videoUrl=videoPath;
    [self.navigationController pushViewController:videoController animated:YES];
}



- (IBAction)tapPhoneButton:(UIButton *)sender{
    
    @weakify(self);

    NSDictionary *dic = [self.dataArray objectAtIndex:sender.tag-phoneBtnTag];
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
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"查看手机需要%@信用豆，确定查看？", [dataSourceDic objectForKey:@"coin"]] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
        
        //add by duanran begin
        UIImageView *cellContentImageView=[[UIImageView alloc]init];
        [cellContentImageView setFrame:cell.contentImageView.frame];
        cellContentImageView.tag=indexPath.row+contentImageViewTag;
        [cell addSubview:cellContentImageView];
        UIView *CellSubView=cell.cellSubView;
        CellSubView.tag=indexPath.row+cellSubViewTag;
        [cell addSubview:CellSubView];

        UIButton *homeBtn=cell.homeButton;
        [homeBtn setFrame:cell.homeButton.frame];
        homeBtn.tag=indexPath.row+homeBtnTag;
        [CellSubView addSubview:homeBtn];
        
        UIButton *yueHuiBtn=[[UIButton alloc]init];
        [yueHuiBtn setFrame:cell.yuehuiButton.frame];
        yueHuiBtn.tag=indexPath.row+dateBtnTag;
        [CellSubView addSubview:yueHuiBtn];
        
        UIButton *phoneBtn=[[UIButton alloc]init];
        [phoneBtn setFrame:cell.phoneButton.frame];
        phoneBtn.tag=indexPath.row+phoneBtnTag;
        [CellSubView addSubview:phoneBtn];
        
        UILabel *contentLabel=cell.contentLabel;
        [contentLabel setFrame:cell.contentLabel.frame];
        contentLabel.tag=indexPath.row+contentLableTag;
        [CellSubView addSubview:contentLabel];
        
        
        
        
    }
    
    

//    [cell.homeButton setTag:indexPath.row];
//    [cell.yuehuiButton setTag:indexPath.row];
//    [cell.phoneButton setTag:indexPath.row];
    
    UIButton *homeBtn=(UIButton *)[cell viewWithTag:indexPath.row+homeBtnTag];
    UIButton *yeHuiBtn=(UIButton *)[cell viewWithTag:indexPath.row+dateBtnTag];
    UIButton *phoneBtn=(UIButton *)[cell viewWithTag:indexPath.row+phoneBtnTag];
    UILabel *contentLabel=[(UILabel *)cell viewWithTag:indexPath.row+contentLableTag];

    
    

    [homeBtn addTarget:self action:@selector(tapHomeButton:) forControlEvents:UIControlEventTouchUpInside];
    [yeHuiBtn addTarget:self action:@selector(tapYueHuiButton:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn addTarget:self action:@selector(tapPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    LCLIndexObject *indexObj = [LCLIndexObject allocModelWithDictionary:dic];
    
    [contentLabel setText:indexObj.title];
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
    [cell.timeLabel setTitle:[NSString stringWithFormat:@"%@ |%@", indexObj.len, indexObj.times] forState:UIControlStateNormal];
    if ([[NSString stringWithFormat:@"%@", indexObj.len] isEqualToString:@"未知"]) {
        [cell.timeLabel setTitle:[NSString stringWithFormat:@"%@|%@", indexObj.len, indexObj.times] forState:UIControlStateNormal];
    }
    
    
    
    
    
    
    CGRect frame = cell.contentImageView.frame;
    frame.size.height = kDeviceWidth*270/360.0;
    [cell.contentImageView setFrame:frame];
    
    UIImageView *contentImageView=(UIImageView *)[cell viewWithTag:indexPath.row+1000];
    [contentImageView setFrame:frame];
    
    
    
    
    NSDictionary *picInfo = indexObj.pic;
    NSString *cansee = [picInfo objectForKey:@"see"];
    if ([cansee integerValue]==1) {
        [contentImageView setImageWithURL:[picInfo objectForKey:@"thumb_360"] defaultImagePath:DefaultImagePath];
    }else{
        [contentImageView setImageWithURL:[picInfo objectForKey:@"thumb_360"] defaultImagePath:DefaultImagePath];
//        [cell.contentImageView setImageWithURL:[picInfo objectForKey:@"thumb_360"] defaultImagePath:DefaultImagePath blur:0.1];
    }
    
    
    
//    UIImageView *contentImageView=[]
    

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewGesture:)];
    tapGesture.delegate=self;
    


    [contentImageView setUserInteractionEnabled:YES];
    [contentImageView addGestureRecognizer:tapGesture];
    [contentImageView setRestorationIdentifier:indexObj.uid];

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
                
                [self updateData];

            }
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
}

-(void)updateData
{
    
    @weakify(self);
    
    [self_weak_.tableView hideEmptyDataTips];
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        NSInteger currentPage=self.page-1;
        
        
        NSString *listURL = [NSString stringWithFormat:@"%@?num=5&page=%li", IndexListURL(userObj.ukey), currentPage];
        
        if (self_weak_.lng && self_weak_.lat) {
            listURL = [NSString stringWithFormat:@"%@&lon=%@&lat=%@", listURL, self.lng, self.lat];
        }
        updateLookPhoneDate *request=[[updateLookPhoneDate alloc]init];
        request.parameters=@{
                             @"ukey":userObj.ukey,
                             @"num":@"5",
                             @"page":[NSNumber numberWithInteger:currentPage],
                             @"lon":self.lng,
                             @"lat":self.lat
                
                             };
        [request GETRequest:^(id reponseObject) {
            
            NSDictionary *dataSourceDic = (NSDictionary *)reponseObject;
            if (dataSourceDic) {
                self_weak_.dataArray = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"list"]];
                [self_weak_.tableView reloadData];
            }

        } failureCallback:^(NSString *errorMessage) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
        
        
        
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                self_weak_.dataArray = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"list"]];
                [self_weak_.tableView reloadData];
            }
            
        }];
    }else{
        
        [self_weak_.tableView hideEmptyDataTips];
        [self_weak_.view showUnloginInfoView:YES];
        
        LCLMainQueue(^{
            [self_weak_.tableView headerEndRefreshing];
        });
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
- (void)lookPicWithUID:(NSString *)uid fromImageView:(UIImageView *)imageView index:(NSInteger)index{
    
    [LCLWaitView showIndicatorView:YES];
    
    @weakify(self);
    
    NSDictionary *myInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    LCLUserInfoObject *myObj = [LCLUserInfoObject allocModelWithDictionary:myInfo];
    
    NSString *listURL = [NSString stringWithFormat:@"%@", LookUserPhotosURL(myObj.ukey, uid)];
    
    
    
    
    LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
    [downloader setHttpMehtod:LCLHttpMethodGet];
    [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
        
        [LCLWaitView showIndicatorView:NO];
        
        NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
        if (dataSourceDic) {
            
            NSArray *picArray = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"list"]];
            
            NSString *videoConin=[NSString stringWithFormat:@"%@",[dataSourceDic objectForKey:@"video_coin"]];
            
            
            
            // 1.封装图片数据
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:picArray.count];
            for (int i = 0; i<picArray.count; i++) {
                // 替换为中等尺寸图片
                
                NSDictionary *dic = [picArray objectAtIndex:i];
                LCLPhotoObject *photoObj = [LCLPhotoObject allocModelWithDictionary:dic];
                
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:photoObj.path]; // 图片路径
                //添加图片类型和视频路径
                photo.photoStyle=photoObj.style;
                photo.videoUrl=photoObj.video_path;
                photo.IsSee=photoObj.see;
                photo.videoCoin=videoConin;
                photo.videoId=photoObj.iD;
                photo.srcImageView = imageView; // 来源于哪个UIImageView
                [photos addObject:photo];
            }
            
            NSInteger t = index;
            if (index>=photos.count) {
                t = photos.count-1;
            }
            
            // 2.显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = t; // 弹出相册时显示的第一张图片是？
            browser.photos = photos; // 设置所有的图片
            browser.delegate=self;
            [browser show];
            
        }
    }];
    [downloader startToDownloadWithIntelligence:NO];
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







