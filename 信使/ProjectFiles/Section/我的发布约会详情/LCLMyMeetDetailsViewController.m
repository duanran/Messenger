//
//  LCLMyMeetDetailsViewController.m
//  信使
//
//  Created by apple on 15/10/22.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMyMeetDetailsViewController.h"

#import "LCLMyMeetDetailsTableViewCell.h"
#import "LCLMeetingDetailTableViewCell.h"

@interface LCLMyMeetDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation LCLMyMeetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupHeader];
    
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

- (void)setupHeader{

    LCLMeetingDetailTableViewCell *header = [LCLMeetingDetailTableViewCell loadXibView];
    [header setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    self.tableView.tableHeaderView = header;
    
    LCLCreateMeetObject *meetObj = self.meetDetailsObj;
    int status = [meetObj.status intValue];
    NSString *ss = @"已过期";
    if (status==3) {
        ss = @"完成";
        [header.meetNumberBGLabel setBackgroundColor:[UIColor lightGrayColor]];
        [header.meetStatusLabel setBackgroundColor:[UIColor lightGrayColor]];
    }
    else if (status==1){
        ss = @"正常";
    }
    else if (status==2){
        ss = @"进行中";
    }else{
        [header.meetNumberBGLabel setBackgroundColor:[UIColor lightGrayColor]];
        [header.meetStatusLabel setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    [header.meetAcceptNOLabel setText:[NSString stringWithFormat:@"已接受了%@人报名", meetObj.onDateCount]];
    [header.meetAddressLabel setText:[NSString stringWithFormat:@"地点：%@", meetObj.place]];
    [header.meetCreateTimeLabel setText:[NSString stringWithFormat:@"%@", meetObj.create_time]];
    [header.meetNumberLabel setText:[NSString stringWithFormat:@"%@", meetObj.signCount]];
    [header.meetStatusLabel setText:[NSString stringWithFormat:@"%@", ss]];
    [header.meetTimeLabel setText:[NSString stringWithFormat:@"结束时间：%@", meetObj.date_time]];
    [header.meetTitleLabel setText:[NSString stringWithFormat:@"礼物：%@", meetObj.title]];
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

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 162;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"homecell";
    
    LCLMyMeetDetailsTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [LCLMyMeetDetailsTableViewCell loadXibView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    LCLMeetBaomingObject *meetObj = [LCLMeetBaomingObject allocModelWithDictionary:dic];

    
    [cell.rejectButton setTag:[self.meetDetailsObj.iD integerValue]];
    [cell.acceptButton setTag:[self.meetDetailsObj.iD integerValue]];
    [cell.rejectButton setRestorationIdentifier:meetObj.uid];
    [cell.acceptButton setRestorationIdentifier:meetObj.uid];
    
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
    }
    [cell.acceptButton setTitle:ss forState:UIControlStateNormal];
    [cell.acceptButton addTarget:self action:@selector(tapAcceptButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rejectButton addTarget:self action:@selector(tapRejectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *user = meetObj.signUser;

    [cell.idLabel setText:[NSString stringWithFormat:@"ID：%@", [user objectForKey:@"uid"]]];
    [cell.meetCreateTimeLabel setText:[user objectForKey:@"phone"]];
    
    if (meetObj.pwd && ![meetObj.pwd isKindOfClass:[NSNull class]]) {
        [cell.passwordLabel setText:[NSString stringWithFormat:@"%@", meetObj.pwd]];
    }else{
        [cell.passwordLabel setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    [cell.nameLabel setText:[user objectForKey:@"nickname"]];
    
    [cell.headButton setBackgroundImageWithURL:GetDownloadPicURL([user objectForKey:@"headimg"]) defaultImagePath:DefaultImagePath];

    [cell setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (void)loadServerData{
    
    @weakify(self);
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", MeetDetailsURL(userObj.ukey, self.meetDetailsObj.iD)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                NSDictionary *info = [dataSourceDic objectForKey:@"info"];
                self_weak_.dataArray = [info objectForKey:@"signList"];
            }
            
            [self_weak_.tableView reloadData];
            
            [self_weak_.tableView headerEndRefreshing];
            
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
            
            [LCLWaitView showIndicatorView:NO];

            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:[type integerValue]==1 ? @"接受成功"  : @"拒绝成功" error:@""];
            if (dataSourceDic) {
                
                [self_weak_ loadServerData];
                
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











