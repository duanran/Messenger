//
//  LCLPayListAndMoneyListViewController.m
//  信使
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLPayListAndMoneyListViewController.h"

#import "LCLPayListTableViewCell.h"

@interface LCLPayListAndMoneyListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation LCLPayListAndMoneyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
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
    
    LCLPayListTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [LCLPayListTableViewCell loadXibView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    LCLPayListObject *payObj = [LCLPayListObject allocModelWithDictionary:dic];
    
    [cell.nameLabel setText:payObj.typeName];
    [cell.desLabel setText:[LCLTimeHelper getDateTimeStringFromTime:[payObj.create_time longLongValue]]];
    
    if (self.isPayList) {
        [cell.coinLabel setText:[NSString stringWithFormat:@"+%@金币", payObj.coin]];
        if ([payObj.type integerValue]==2) {
            [cell.coinLabel setText:[NSString stringWithFormat:@"-%@金币", payObj.coin]];
        }
    }else{
        [cell.coinLabel setText:[NSString stringWithFormat:@"%@", payObj.coin]];
    }
    
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
        
        NSString *listURL = [NSString stringWithFormat:@"%@", MyMoneyListURL(userObj.ukey)];
        if (self_weak_.isPayList) {
            listURL = [NSString stringWithFormat:@"%@", MyPayLisyURL(userObj.ukey)];
        }
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                self_weak_.dataArray = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"list"]];
            }
            
            [self_weak_.tableView headerEndRefreshing];
            
            [self_weak_.tableView reloadData];
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
