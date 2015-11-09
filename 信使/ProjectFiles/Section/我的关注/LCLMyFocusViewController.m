//
//  LCLMyFocusViewController.m
//  信使
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMyFocusViewController.h"

#import "LCLMyFocusTableViewCell.h"
#import "LCLPeopleInfoViewController.h"

@interface LCLMyFocusViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation LCLMyFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.\
    
    [self.navigationItem setTitle:@"我的关注"];
    
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

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"homecell";
    
    LCLMyFocusTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [LCLMyFocusTableViewCell loadXibView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    LCLFocusPeopleObject *focusObj = [LCLFocusPeopleObject allocModelWithDictionary:dic];
    NSDictionary *userDic = focusObj.user;
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userDic];
    
    [cell setPeopleNameWithName:userObj.nickname];
    [cell.peopleInfoLabel setText:[NSString stringWithFormat:@"%@岁  %@cm  %@kg", userObj.age, userObj.height, userObj.weight]];
    
    NSDictionary *vipInfo = focusObj.vipInfo;
    if (vipInfo) {
        [cell.levelImageView setImageWithURL:[vipInfo objectForKey:@"pic"] defaultImagePath:DefaultImagePath];
    }else{
        [cell.levelImageView setHidden:YES];
    }
    if ([userObj.video integerValue]==1) {
        [cell.movieImageView setHidden:NO];
    }else{
        [cell.movieImageView setHidden:YES];
    }

    [cell.addressLabel setText:[NSString stringWithFormat:@"%@", userObj.last_login_time]];
    [cell.timeLabel setTitle:[NSString stringWithFormat:@"%@", userObj.cityname] forState:UIControlStateNormal];

    NSString *peopleURL = userObj.headimg;
    [cell.peopleHeadButton setBackgroundImageWithURL:peopleURL
                                    defaultImagePath:DefaultImagePath];
    [cell.peopleHeadButton setTag:indexPath.row];
    [cell.peopleHeadButton addTarget:self action:@selector(tapPeopleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.focusButton setTag:indexPath.row];
    [cell.focusButton addTarget:self action:@selector(tapFocusButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [cell.focusButton setTitle:@"取消关注" forState:UIControlStateNormal];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)tapPeopleButton:(UIButton *)sender{

    NSDictionary *dic = [self.dataArray objectAtIndex:sender.tag];
    LCLFocusPeopleObject *focusObj = [LCLFocusPeopleObject allocModelWithDictionary:dic];
    NSDictionary *userDic = focusObj.user;
    
    LCLPeopleInfoViewController *people = [[LCLPeopleInfoViewController alloc] initWithNibName:@"LCLPeopleInfoViewController" bundle:nil];
    [people setUserInfo:userDic];
    [people setTitle:@"个人主页"];
    [people setHidesBottomBarWhenPushed:YES];
    [people setIsFromMe:NO];
    [people setRefresh:YES];
    [self.navigationController pushViewController:people animated:YES];
}

- (void)loadServerData{
    
    @weakify(self);
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", MyFocusURL(userObj.ukey)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            [LCLWaitView showIndicatorView:NO];

            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                self_weak_.dataArray = [dataSourceDic objectForKey:@"list"];
            }
            
            [self_weak_.tableView reloadData];

            [self_weak_.tableView headerEndRefreshing];
            
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
}

- (IBAction)tapFocusButton:(UIButton *)sender{

    NSDictionary *dic = [self.dataArray objectAtIndex:sender.tag];
    LCLFocusPeopleObject *focusObj = [LCLFocusPeopleObject allocModelWithDictionary:dic];
    NSDictionary *userDic = focusObj.user;
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userDic];

    if ([userObj.is_follow integerValue]==0) {
        [self focusAction:NO uid:userObj.uid];
    }else{
        [self focusAction:NO uid:userObj.uid];
    }
}

- (void)focusAction:(BOOL)isFocus uid:(NSString *)uid{
    
    @weakify(self);
    
    [LCLWaitView showIndicatorView:YES];
    
    NSDictionary *userDic = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userDic) {
        
        LCLUserInfoObject *myObj = [LCLUserInfoObject allocModelWithDictionary:userDic];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", FocusPeopleURL(myObj.ukey, uid)];
        if (!isFocus) {
            listURL = [NSString stringWithFormat:@"%@", UNFocusPeopleURL(myObj.ukey, uid)];
        }
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            [LCLWaitView showIndicatorView:NO];
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                [LCLWaitView showIndicatorView:YES];

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
