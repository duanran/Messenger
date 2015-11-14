//
//  LCLShopViewController.m
//  信使
//
//  Created by 李程龙 on 15/5/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLShopViewController.h"

#import "LCLShopTableViewCell.h"
#import "LCLShopSectionHeaderView.h"
#import "LCLShopHeader.h"

@interface LCLShopViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *coinArray;
@property (nonatomic, strong) NSMutableArray *vipArray;

@property (strong, nonatomic) NSString *gonggao;

@property (strong, nonatomic) LCLShopHeader *header;

@end

@implementation LCLShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"商店"];
    
    [self.view addSubview:self.tableView];
    
    self.header = (LCLShopHeader *)[[[NSBundle mainBundle] loadNibNamed:@"LCLShopHeader" owner:self options:nil] lastObject];
    [self.tableView setTableHeaderView:self.header];
    
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

- (IBAction)tapBuyButton:(UIButton *)sender{

    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
    
    NSString *type = sender.restorationIdentifier;
    NSString *tag = [NSString stringWithFormat:@"%li", sender.tag];
    //type: 1：充值，2：购买vip
    NSString *orderString = PayURL(userObj.ukey, tag, type);
    
    @weakify(self);
    
    [LCLWaitView showIndicatorView:YES];
    
    LCLDownloader *payOrder = [[LCLDownloader alloc] initWithURLString:orderString];
    [payOrder setHttpMehtod:LCLHttpMethodPost];
    [payOrder setHttpBodyData:[orderString dataUsingEncoding:NSUTF8StringEncoding]];
    [payOrder setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
        
        NSDictionary *dataDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:[type integerValue]==1 ? nil : @"" error:@""];
        if (dataDic) {
            
            if ([type integerValue]==1) {
                
                NSDictionary *info = [dataDic objectForKey:@"info"];
                
                NSString *orderNo = [info objectForKey:@"order_no"];
                NSString *alipayPrice = [info objectForKey:@"money"];
                NSString *wechatPayPrice = [NSString stringWithFormat:@"%i", [alipayPrice intValue]*100];
                NSString *coin = [info objectForKey:@"coin"];
                NSString *subject = [NSString stringWithFormat:@"充值信用豆%@", coin];
                if ([type integerValue]==2) {
                    subject = @"购买VIP";
                }
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", @"微信支付", nil];
                [actionSheet showFromTabBar:self.tabBarController.tabBar];
                [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *indexButton) {
                    NSInteger tag = [indexButton integerValue];
                    if (tag==0) {
                        //支付宝
                        Product *product = [Alipay getProduceWithTradeNo:orderNo price:alipayPrice subject:subject body:subject invokeIP:AliPayInvokeIP notifyURL:AliPayNotifyURL sellerID:AliPaySellerID parnerID:AliPayParnerId];
                        [Alipay payWithProductDic:product];
                        
                    }else if (tag==1){
                        //微信支付
                        WeChatProduct *product = [WechatPay getProduceWithTradeNo:orderNo price:wechatPayPrice orderName:subject pay_id:WXPayID pay_secret:WXPaySecret mch_id:WXMCH_ID parnerID:WXParnerID sp_url:WXSP_URL notifyURL:WXNotifyURL];
                        [WechatPay payWithProductDic:product];
                    }
                }];
            }
        }
        
        [LCLWaitView showIndicatorView:NO];
    }];
    [payOrder startToDownloadWithIntelligence:NO];
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return @"信用豆充值";
    }else{
        return @"账户升级";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    LCLShopSectionHeaderView *header = (LCLShopSectionHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"LCLShopSectionHeaderView" owner:self options:nil] lastObject];
    if (section==0) {
        [header.titleLabel setText:@"信用豆充值"];
    }else{
        [header.titleLabel setText:@"账户升级"];
    }
    
    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return self.coinArray.count;
    }
    return self.vipArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    LCLShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = (LCLShopTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"LCLShopTableViewCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSDictionary *dic = nil;
    if (indexPath.section==0) {
        dic = [self.coinArray objectAtIndex:indexPath.row];
    }else{
        dic = [self.vipArray objectAtIndex:indexPath.row];
    }
    
    
    LCLShopInfoObject *shopObj = [LCLShopInfoObject allocModelWithDictionary:dic];
    
    [cell.coinImageView setImageWithURL:GetDownloadPicURL(shopObj.pic) defaultImagePath:DefaultImagePath];
    [cell.buyButton setTag:[shopObj.iD integerValue]];
    [cell.buyButton addTarget:self action:@selector(tapBuyButton:) forControlEvents:UIControlEventTouchUpInside];

    
    if (indexPath.section==0) {
        [cell.desLabel setText:shopObj.des];
        [cell.nameLabel setText:shopObj.coin];
        [cell.buyButton setTitle:[NSString stringWithFormat:@"%@元", shopObj.money] forState:UIControlStateNormal];
        [cell.buyButton setBackgroundColor:APPGreenColor];
        [cell.buyButton setRestorationIdentifier:@"1"];
    }else{
        [cell.desLabel setText:shopObj.coin];
        [cell.nameLabel setText:shopObj.title];
        [cell.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [cell.buyButton setBackgroundColor:[UIColor orangeColor]];
        [cell.buyButton setRestorationIdentifier:@"2"];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

#pragma mark GETTER
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

#pragma mark -下载数据
- (void)loadServerData{
    
    @weakify(self);
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", ShopInfoURL(userObj.ukey)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                self_weak_.coinArray = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"coin"]];
                self_weak_.vipArray = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"vip"]];
                
                self_weak_.gonggao = [dataSourceDic objectForKey:@"buyabout"];
                
                [self_weak_.header.gonggaoLabel setText:self_weak_.gonggao];
                
                [self_weak_.tableView reloadData];
            }
            
            [self_weak_.tableView headerEndRefreshing];
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }else{
                
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










