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
// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).// 真实模式,
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.// 测试(网络)
// - For testing, use PayPalEnvironmentNoNetwork.// 本地测试模式
#define kPayPalEnvironment PayPalEnvironmentSandbox // 需要更改的地方 PayPalEnvironmentProduction

@interface LCLShopViewController () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *coinArray;
@property (nonatomic, strong) NSMutableArray *vipArray;

@property (strong, nonatomic) NSString *gonggao;
@property(nonatomic,strong)NSString *payUrl;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;//配置贝宝账号信息,如邮箱,电话等
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
    [self configPayPal];

    @weakify(self);
    
    [self_weak_.tableView addHeaderWithCallback:^{
        
        [self_weak_ loadServerData];
    }];
    
    [self_weak_.tableView headerBeginRefreshing];

}
#pragma 设置paypal支付
- (BOOL)acceptCreditCards {
    return self.payPalConfig.acceptCreditCards; //信用卡支付只适用于单一支付,未来支付功能不支持,默认支持
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setPayPalEnvironment:self.environment];

}
- (void)setPayPalEnvironment:(NSString *)environment {
    
    self.environment = environment;
    // 预处理贝宝
    [PayPalMobile preconnectWithEnvironment:environment];
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}
- (void)configPayPal{
    _payPalConfig = [[PayPalConfiguration alloc] init];
    // 判断有没有信用卡
#if HAS_CARDIO
    _payPalConfig.acceptCreditCards = YES;
#else
    _payPalConfig.acceptCreditCards = NO;
#endif
    
    _payPalConfig.merchantName = @"公司名称";// 显示给用户的公司名称
    // 隐私政策的url,未来付款和分享用
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    // 公司的协议的url,未来付款和分享用
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // 设置语言 默认本地
    //_payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    //选择送货地址。
    //- PayPalShippingAddressOptionNone:没有送货地址适用。
    // - PayPalShippingAddressOptionProvided:送货地址将由你的应用的shippingAddress文件的PayPalPayment属性提供。
    // - PayPalShippingAddressOptionPayPal:PayPal账户里的航运地址。
    //- PayPalShippingAddressOptionBoth:用户会选择从你的应用程序提供的送货地址,PayPalPayment shippingAddress属性,加上PayPal账户里的航运地址。
    //默认为PayPalShippingAddressOptionNone。
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
    
#pragma  // 设置环境,真实环境用 PayPalEnvironmentProduction
    self.environment = kPayPalEnvironment;
    
    
    
}

#pragma mark - Receive Single Payment
/**
 
 简单类型的支付
 点击支付按钮
 
 */
- (IBAction)paySample {
    
    //注意:为了说明,这个例子显示了一个包含付款细节(小计、航运、税)和多个项目。
    //你可以把payment.items和payment.paymentDetails设成nil,简单地设置付款总额payment.amount。
    // Optional: include multiple items
    
    PayPalItem *item1 = [PayPalItem itemWithName:@"Old jeans with holes"
                                    withQuantity:2
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"2.1"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00066"];
    PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00291"];
    NSArray *items = @[item1, item2, item3];
    //所有项目的总额
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    // 航运
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
    // 税务
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
    //支付明细
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    // 支付总额
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    // 支付总额
    payment.amount = total;
    // 标准货币类型代码
    payment.currencyCode = @"USD";
    // 给用户看的描叙 ,限制在20个字符内
    payment.shortDescription = @"肾";
    // 支付的各种项目 ,可选
    payment.items = items;
    // 包括税收和运费的明细,可选,可为nil
    payment.paymentDetails = paymentDetails;
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    // 跳转到支付界面
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

-(void)PayPalPay:(NSString *)price DescribeTion:(NSString *)describe OrderId:(NSString *)orderId
{

    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    NSDecimalNumber *totalPrice = [[NSDecimalNumber alloc] initWithString:price];
    // 支付总额
    payment.amount = totalPrice;
    // 标准货币类型代码
    payment.currencyCode = @"USD";
    // 给用户看的描叙 ,限制在20个字符内
    payment.shortDescription = describe;
    
    payment.items = nil;
    payment.paymentDetails = nil;
    payment.custom=orderId;

    
    
    
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    // 跳转到支付界面
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

/**************** 单笔付款 **************************************/
#pragma mark PayPalPaymentDelegate methods

// 成功付款后调用
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    //付款成功处理,发送到服务器进行验证和实现
    [self sendCompletedPaymentToServer:completedPayment];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 用户取消付款,移除视图
- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation
// 把付款凭证发给自己的服务器
- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // 把completedPayment.confirmation发给服务器,确认付款
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapBuyButton:(UIButton *)sender{

    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = EIGetViewBySubView(button, [UITableViewCell class]);
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dic = nil;
    if (indexPath.section==0) {
        dic = [self.coinArray objectAtIndex:indexPath.row];
    }else{
        dic = [self.vipArray objectAtIndex:indexPath.row];
    }
    
    LCLShopInfoObject *shopObj = [LCLShopInfoObject allocModelWithDictionary:dic];
    
    
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
    
    NSString *type = sender.restorationIdentifier;
    NSString *tag = [NSString stringWithFormat:@"%li", sender.tag];

    
    //type: 1：充值，2：购买vip
    NSString *orderString = PayURL(userObj.ukey, tag, type);
    
    
    NSString *messeage=[NSString stringWithFormat:@"需要收取%@信用豆",shopObj.coin];

    
    if ([type integerValue]==2) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"账户升级" message:messeage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        self.payUrl=orderString;
        return;
    }
    
    
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
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", @"PayPal支付", nil];
                [actionSheet showFromTabBar:self.tabBarController.tabBar];
                [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *indexButton) {
                    NSInteger tag = [indexButton integerValue];
                    if (tag==0) {
                        //支付宝
                        Product *product = [Alipay getProduceWithTradeNo:orderNo price:alipayPrice subject:subject body:subject invokeIP:AliPayInvokeIP notifyURL:AliPayNotifyURL sellerID:AliPaySellerID parnerID:AliPayParnerId];
                        [Alipay payWithProductDic:product];
                        
                    }else if (tag==1){
                        //paypal
                        
                        [self PayPalPay:alipayPrice DescribeTion:subject OrderId:orderNo];
                        
                        
//                        WeChatProduct *product = [WechatPay getProduceWithTradeNo:orderNo price:wechatPayPrice orderName:subject pay_id:WXPayID pay_secret:WXPaySecret mch_id:WXMCH_ID parnerID:WXParnerID sp_url:WXSP_URL notifyURL:WXNotifyURL];
//                        [WechatPay payWithProductDic:product];
                    }
                }];
            }
        }
        
        [LCLWaitView showIndicatorView:NO];
    }];
    [payOrder startToDownloadWithIntelligence:NO];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (self.payUrl) {
            [LCLWaitView showIndicatorView:YES];
            
            LCLDownloader *payOrder = [[LCLDownloader alloc] initWithURLString:self.payUrl];
            [payOrder setHttpMehtod:LCLHttpMethodPost];
            [payOrder setHttpBodyData:[self.payUrl dataUsingEncoding:NSUTF8StringEncoding]];
            [payOrder setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
                
                [self loadServerData];
                [LCLWaitView showIndicatorView:NO];
            }];
            [payOrder startToDownloadWithIntelligence:NO];
        }

    }
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
        cell = (LCLShopTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"LCLShopTableViewCell_2" owner:self options:nil] lastObject];
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
        [cell.desLabel setText:[NSString stringWithFormat:@"%@信用豆",shopObj.coin]];
        [cell.nameLabel setText:shopObj.title];
        
       
        [cell.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        
        if ([shopObj.is_click integerValue]==0) {
            [cell.buyButton setBackgroundColor:[UIColor grayColor]];
            [cell.buyButton setEnabled:NO];
        }
        else
        {
            [cell.buyButton setBackgroundColor:[UIColor orangeColor]];

        }
        
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










