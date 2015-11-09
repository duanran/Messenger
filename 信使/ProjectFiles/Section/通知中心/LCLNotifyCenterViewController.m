//
//  LCLNotifyCenterViewController.m
//  Fruit
//
//  Created by lichenglong on 15/6/25.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLNotifyCenterViewController.h"

#import "LCLCommentTableViewCell.h"

@interface LCLNotifyCenterViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LCLNotifyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"全部动态"];
    
    [self.view addSubview:self.tableView];
    
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

#pragma mark - Propertys
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setAutoresizesSubviews:YES];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

#pragma -
#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    
    LCLCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LCLCommentTableViewCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    LCLNotifyModel *message = [LCLNotifyModel allocModelWithDictionary:dic];
    
    [cell.nameLabel setText:@"信使管家"];
    [cell.timeLabel setText:message.create_time];
    [cell.desLabel setText:message.msg];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark -下载数据
- (void)loadServerData{
    
    @weakify(self);
    
    [self_weak_.tableView hideEmptyDataTips];

    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:YES];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:NotifyListURL(userObj.ukey)];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                self_weak_.dataArray = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"list"]];
                [self_weak_.tableView reloadData];
            }
            
            if (self_weak_.dataArray.count>0) {
                [self_weak_.tableView hideEmptyDataTips];
            }else{
                [self_weak_.tableView showEmptyDataTips:DefaultEmptyDataText tipsFrame:DefaultEmptyDataFrame];
            }
            
            [self_weak_.tableView headerEndRefreshing];
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }else{
        
        [self_weak_.tableView headerEndRefreshing];
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









