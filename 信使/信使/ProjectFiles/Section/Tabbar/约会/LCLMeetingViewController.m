//
//  LCLMeetingViewController.m
//  信使
//
//  Created by 李程龙 on 15/5/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMeetingViewController.h"

#import "LCLMeetingButtonTableViewCell.h"
#import "LCLMeetingDetailTableViewCell.h"
#import "LCLMeetingMineTableViewCell.h"

#import "LCLCreateMeetingViewController.h"

#import "LCLVerifyMeetingPasswordView.h"

#import "LCLMyMeetDetailsViewController.h"

@interface LCLMeetingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *myCreateMeetArray;
@property (nonatomic, strong) NSMutableArray *myPrivateMeetArray;

@property (nonatomic, strong) NSDictionary *meetInfoDic;

@property (nonatomic) BOOL isMyPublicMeeting;

@end

@implementation LCLMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"约会"];
    
     [self.view addSubview:self.tableView];
    
    self.isMyPublicMeeting = YES;
    
    [self loadMeetInfoData];
    
    @weakify(self);
    
    [self_weak_.tableView addHeaderWithCallback:^{
        
        [self_weak_ loadServerData];
    }];
    
    [self_weak_.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tabSegmentControl:(UISegmentedControl *)segment{

    if (segment.selectedSegmentIndex==0) {
        self.isMyPublicMeeting = YES;
        
        if (self.myCreateMeetArray.count>0) {
            
            [self.tableView hideEmptyDataTips];

            [self.tableView reloadData];
        }else{
            
            [LCLWaitView showIndicatorView:YES];

            [self loadServerData];
        }
    }else{
        self.isMyPublicMeeting = NO;
        
        if (self.myPrivateMeetArray.count>0) {
            
            [self.tableView hideEmptyDataTips];

            [self.tableView reloadData];
        }else{
            
            [LCLWaitView showIndicatorView:YES];
            
            [self loadServerData];
        }
    }
}

- (IBAction)tapCreateMeetingButton:(id)sender{
    
    LCLCreateMeetingViewController *createMeet = [[LCLCreateMeetingViewController alloc] initWithNibName:@"LCLCreateMeetingViewController" bundle:nil];
    [createMeet setCanShowNavBackItem:YES];
    [createMeet setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:createMeet animated:NO];
}

- (IBAction)tapJieDongButton:(id)sender{
    
    [LCLAlertController setHideStatusBar:NO];

    LCLVerifyMeetingPasswordView *verifyPassword = [LCLVerifyMeetingPasswordView loadXibView];
    [verifyPassword setFrame:[UIScreen mainScreen].bounds];
    [LCLAlertController alertFromWindowWithView:verifyPassword alertStyle:LCLAlertStyleCustom tag:VerifyPasswordViewTag];
}

- (IBAction)tapAcceptButton:(UIButton *)sender{

    NSString *uid = sender.restorationIdentifier;
    NSString *cid = [NSString stringWithFormat:@"%li", sender.tag];
    
    [self answerMeetWithType:@"1" meetID:cid uid:uid];
}

- (IBAction)tapRejectButton:(UIButton *)sender{
    
    NSString *uid = sender.restorationIdentifier;
    NSString *cid = [NSString stringWithFormat:@"%li", sender.tag];
    
    [self answerMeetWithType:@"2" meetID:cid uid:uid];
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return 178;
    }else{
        if(self.isMyPublicMeeting){
            return 127;
        }
        return 162;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isMyPublicMeeting) {
        return self.myCreateMeetArray.count+1;
    }
    return self.myPrivateMeetArray.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.row==0) {
        
        LCLMeetingButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell = (LCLMeetingButtonTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"LCLMeetingButtonTableViewCell" owner:self options:nil] lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        [cell.meetInfoLabel setText:[self.meetInfoDic objectForKey:@"head"]];
        
        [cell.segmentControl addTarget:self action:@selector(tabSegmentControl:) forControlEvents:UIControlEventValueChanged];
        
        [cell.faqiButton addTarget:self action:@selector(tapCreateMeetingButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.jiedongButton addTarget:self action:@selector(tapJieDongButton:) forControlEvents:UIControlEventTouchUpInside];

        if (self.isMyPublicMeeting) {
            [cell.segmentControl setSelectedSegmentIndex:0];
        }else{
            [cell.segmentControl setSelectedSegmentIndex:1];
        }
        
        return cell;
        
    }else{
    
        if (self.isMyPublicMeeting) {
            
            LCLMeetingDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell==nil) {
                cell = (LCLMeetingDetailTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"LCLMeetingDetailTableViewCell" owner:self options:nil] lastObject];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }

            NSDictionary *dic = [self.myCreateMeetArray objectAtIndex:indexPath.row-1];
            LCLCreateMeetObject *meetObj = [LCLCreateMeetObject allocModelWithDictionary:dic];
            
            int status = [meetObj.status intValue];
            NSString *ss = @"已过期";
            if (status==3) {
                ss = @"完成";
                [cell.meetNumberBGLabel setBackgroundColor:[UIColor lightGrayColor]];
                [cell.meetStatusLabel setBackgroundColor:[UIColor lightGrayColor]];
            }
            else if (status==1){
                ss = @"正常";
            }
            else if (status==2){
                ss = @"进行中";
            }else{
                [cell.meetNumberBGLabel setBackgroundColor:[UIColor lightGrayColor]];
                [cell.meetStatusLabel setBackgroundColor:[UIColor lightGrayColor]];
            }
            
            [cell.meetAcceptNOLabel setText:[NSString stringWithFormat:@"已接受了%@人报名", meetObj.onDateCount]];
            [cell.meetAddressLabel setText:[NSString stringWithFormat:@"地点：%@", meetObj.place]];
            [cell.meetCreateTimeLabel setText:[NSString stringWithFormat:@"%@", meetObj.create_time]];
            [cell.meetNumberLabel setText:[NSString stringWithFormat:@"%@", meetObj.signCount]];
            [cell.meetStatusLabel setText:[NSString stringWithFormat:@"%@", ss]];
            [cell.meetTimeLabel setText:[NSString stringWithFormat:@"结束时间：%@", meetObj.date_time]];
            [cell.meetTitleLabel setText:[NSString stringWithFormat:@"礼物：%@", meetObj.title]];

            
            [cell setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
            
            return cell;

        }else{
            
            LCLMeetingMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell==nil) {
                cell = (LCLMeetingMineTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"LCLMeetingMineTableViewCell" owner:self options:nil] lastObject];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            NSDictionary *dic = [self.myPrivateMeetArray objectAtIndex:indexPath.row-1];
            LCLCreateMeetObject *meetObj = [LCLCreateMeetObject allocModelWithDictionary:dic];

            [cell.rejectButton setTag:[meetObj.iD integerValue]];
            [cell.acceptButton setTag:[meetObj.iD integerValue]];
            [cell.rejectButton setRestorationIdentifier:meetObj.inviteuid];
            [cell.acceptButton setRestorationIdentifier:meetObj.inviteuid];

            int status = [meetObj.ondate intValue];
            [cell.acceptButton setEnabled:NO];
            [cell.rejectButton setHidden:YES];
            NSString *ss = @"接受";
            if (status==3) {
                ss = @"已完成";
                [cell.acceptButton setBackgroundColor:[UIColor lightGrayColor]];
            }
            else if (status==1){
                ss = @"已接受";
                [cell.acceptButton setBackgroundColor:[UIColor lightGrayColor]];
            }
            else if (status==2){
                ss = @"已拒绝";
                [cell.acceptButton setBackgroundColor:[UIColor lightGrayColor]];
            }
            else if(status==0){
                [cell.rejectButton setHidden:NO];
                [cell.acceptButton setEnabled:YES];
                
                if ([meetObj.type isEqualToString:@"我约"]) {
                    [cell.rejectButton setHidden:YES];
                    [cell.acceptButton setHidden:YES];
                }
            }
            [cell.acceptButton setTitle:ss forState:UIControlStateNormal];
            [cell.acceptButton addTarget:self action:@selector(tapAcceptButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.rejectButton addTarget:self action:@selector(tapRejectButton:) forControlEvents:UIControlEventTouchUpInside];

            [cell.meetTitleLabel setText:[NSString stringWithFormat:@"礼物：%@", meetObj.title]];
            [cell.meetAddressLabel setText:[NSString stringWithFormat:@"地点：%@", meetObj.place]];
            [cell.meetTimeLabel setText:[NSString stringWithFormat:@"结束时间：%@", meetObj.date_time]];
            
            [cell.meetCreateTimeLabel setText:@""];

            if (meetObj.pwd && ![meetObj.pwd isKindOfClass:[NSNull class]]) {
                [cell.passwordLabel setText:[NSString stringWithFormat:@"%@", meetObj.pwd]];
            }else{
                [cell.passwordLabel setBackgroundColor:[UIColor lightGrayColor]];
            }
            
            [cell.yuewoButton setTitle:meetObj.type forState:UIControlStateNormal];
            
            NSDictionary *user = meetObj.user;
            [cell.nameLabel setText:[user objectForKey:@"nickname"]];
            
            [cell.headButton setBackgroundImageWithURL:GetDownloadPicURL([user objectForKey:@"headimg"]) defaultImagePath:DefaultImagePath];
            
            
            [cell setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
            
            return cell;

        }
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row>0 && self.isMyPublicMeeting) {
        
        NSDictionary *dic = [self.myCreateMeetArray objectAtIndex:indexPath.row-1];
        LCLCreateMeetObject *meetObj = [LCLCreateMeetObject allocModelWithDictionary:dic];
        
        LCLMyMeetDetailsViewController *meet = [[LCLMyMeetDetailsViewController alloc] initWithNibName:@"LCLMyMeetDetailsViewController" bundle:nil];
        [meet setMeetDetailsObj:meetObj];
        [meet setTitle:@"我的发布"];
        [self.navigationController pushViewController:meet animated:YES];
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
    
    @weakify(self);
    
    [self_weak_.tableView hideEmptyDataTips];
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", MyCreateMeetURL(userObj.ukey)];
        if (!self.isMyPublicMeeting) {
            listURL = [NSString stringWithFormat:@"%@", MyPrivateMeetURL(userObj.ukey)];
        }
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            NSArray *array = [dataSourceDic objectForKey:@"list"];
            if (dataSourceDic) {
                if (self.isMyPublicMeeting) {
                    self_weak_.myCreateMeetArray = [[NSMutableArray alloc] initWithArray:array];
                }else{
                    self_weak_.myPrivateMeetArray = [[NSMutableArray alloc] initWithArray:array];
                }
            }
            
            if (array.count>0) {
                [self_weak_.tableView hideEmptyDataTips];
            }else{
                [self_weak_.tableView showEmptyDataTips:DefaultEmptyDataText tipsFrame:  CGRectMake(0, 178, kDeviceWidth, 50)];
            }
            
            [self_weak_.tableView reloadData];

            [self_weak_.tableView headerEndRefreshing];
            
            [LCLWaitView showIndicatorView:NO];

        }];
        [downloader startToDownloadWithIntelligence:NO];
    }else{
        
        [self_weak_.tableView hideEmptyDataTips];
        [self_weak_.view showUnloginInfoView:YES];
        
        LCLMainQueue(^{
            [self_weak_.tableView headerEndRefreshing];
        });
        
        [LCLWaitView showIndicatorView:NO];
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

                self.meetInfoDic = [dataSourceDic objectForKey:@"info"];
                
                [self_weak_.tableView reloadData];
            }
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
}

- (void)answerMeetWithType:(NSString *)type meetID:(NSString *)meetID uid:(NSString *)uid{
//ondate  1:接受，2：拒绝
    
    @weakify(self);
    
    [LCLWaitView showIndicatorView:YES];
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", AnswerMeetURL(userObj.ukey, meetID, uid, type)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:[type integerValue]==1 ? @"接受成功"  : @"拒绝成功" error:@""];
            if (dataSourceDic) {
                
                [self_weak_ loadServerData];
                
            }else{
            
                [LCLWaitView showIndicatorView:NO];
            }
        }];
        [downloader startToDownloadWithIntelligence:NO];
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














