//
//  LCLMeViewController.m
//  信使
//
//  Created by 李程龙 on 15/5/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMeViewController.h"

#import "LCLMeTableViewCell.h"
#import "LCLMeHeaderView.h"
#import "LCLMeFooterView.h"

#import "LCLChangePasswordView.h"
#import "LCLARCPicManager.h"
#import "LCLEditMyInfoViewController.h"
#import "LCLMyPictureInfoViewController.h"
#import "LCLMyFocusViewController.h"
#import "LCLMyMovieViewController.h"
#import "LCLPayListAndMoneyListViewController.h"
#import "LCLPeopleInfoViewController.h"


#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKAddressBook.h>

@interface LCLMeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) LCLMeHeaderView *header;
@property (strong, nonatomic) LCLMeFooterView *footer;

@property (strong, nonatomic) NSDictionary *myInfo;
@property  (strong,nonatomic)NSString *shopOff;

@end

@implementation LCLMeViewController

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *dic = [[LCLCacheDefaults standardCacheDefaults] objectForCacheKey:UserInfoKey];
    NSString *shop_onoff=[NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_onoff"]];
    self.shopOff=shop_onoff;
    [self.navigationItem setTitle:@"个人"];
    
    [self.view addSubview:self.tableView];
    
    self.header = (LCLMeHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"LCLMeHeaderView" owner:self options:nil] lastObject];
    [self.header.headButton addTarget:self action:@selector(tapHeadButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.header.editPasswordButton addTarget:self action:@selector(tapEditPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.header.editNameButton addTarget:self action:@selector(tapEditNickNameButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView setTableHeaderView:self.header];
    
    self.footer = (LCLMeFooterView *)[[[NSBundle mainBundle] loadNibNamed:@"LCLMeFooterView" owner:self options:nil] lastObject];
    [self.footer.logoutButton addTarget:self action:@selector(tapLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView setTableFooterView:self.footer];
    [self.footer.infoLabel setText:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveEditUserInfoNotify:) name:@"DidEditUserInfo" object:nil];
    
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

- (void)didReceiveEditUserInfoNotify:(NSNotification *)notify{

    [self loadServerData];
}

- (IBAction)tapHeadButton:(id)sender{
    
    @weakify(self);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"照片", nil];
    [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
        
        int tag = [index intValue];
        if (tag==0) {
            
            [LCLARCPicManager showLCLPhotoControllerOnViewController:self_weak_ lclPhototype:LCLPhotoTypeSystemCamera finishBlock:^(UIImage *image, NSData *imageData) {
                
                [self_weak_.header.headButton setBackgroundImage:image forState:UIControlStateNormal];
                
                [self_weak_ uploadHeadImage:imageData];
                
            } cancleBlock:^{
                
            } beginBlock:^{
                
            } movieFinish:^(id object) {
                
            }];
            
        }else if (tag==1){
            
            [LCLARCPicManager showLCLPhotoControllerOnViewController:self_weak_ lclPhototype:LCLPhotoTypeSystemLibrary finishBlock:^(UIImage *image, NSData *imageData) {
                
                [self_weak_.header.headButton setBackgroundImage:image forState:UIControlStateNormal];
                
                [self_weak_ uploadHeadImage:imageData];
                
            } cancleBlock:^{
                
            } beginBlock:^{
                
            } movieFinish:^(id object) {
                
                
                
            }];
        }
    }];
    [actionSheet showInView:self.view];
}

- (IBAction)tapLogoutButton:(id)sender{

    [self.footer.logoutButton setHidden:YES];
    
    [LCLAppLoader logoutAction];
}

- (IBAction)tapEditNickNameButton:(id)sender{

//    LCLEditMyInfoViewController *editMyInfo = [[LCLEditMyInfoViewController alloc] initWithNibName:@"LCLEditMyInfoViewController" bundle:nil];
//    [editMyInfo setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:editMyInfo animated:YES];
    
    [LCLAlertController setHideStatusBar:NO];
    
    LCLChangePasswordView *pass = [LCLChangePasswordView loadXibView];
    [pass setIsEditNickName:YES];
    CGRect frame = pass.frame;
    frame.origin.x = (kDeviceWidth-frame.size.width)/2.0;
    frame.origin.y = 100;
    [pass setFrame:frame];
    [LCLAlertController alertFromWindowWithView:pass alertStyle:LCLAlertStyleCustom tag:ChangePasswordViewTag];
}

- (IBAction)tapEditPasswordButton:(id)sender{
    
    [LCLAlertController setHideStatusBar:NO];

    LCLChangePasswordView *pass = [LCLChangePasswordView loadXibView];
    CGRect frame = pass.frame;
    frame.origin.x = (kDeviceWidth-frame.size.width)/2.0;
    frame.origin.y = 100;
    [pass setFrame:frame];
    [LCLAlertController alertFromWindowWithView:pass alertStyle:LCLAlertStyleCustom tag:ChangePasswordViewTag];
}

- (IBAction)tapSwithbutton:(UISwitch *)switchButton{

    if ([self.shopOff integerValue]==1) {
        if (switchButton.tag==1) {
            //通讯录隐身
            if (switchButton.isOn) {
                //取消隐身
                
                [self editPhoneOnline:YES];
                
            }else{
                //隐身
                
                [self editPhoneOnline:NO];
                
            }
        }
        else if (switchButton.tag==2){
            //付费看手机
            if (switchButton.isOn) {
                //付费
                
                [self editPhoneOut:YES];
            }else{
                //免费
                
                [self editPhoneOut:NO];
            }
        }
    }
    else
    {
        if (switchButton.tag==0) {
            //通讯录隐身
            if (switchButton.isOn) {
                //取消隐身
                
                [self editPhoneOnline:YES];
                
            }else{
                //隐身
                
                [self editPhoneOnline:NO];
                
            }
        }
        else if (switchButton.tag==1){
            //付费看手机
            if (switchButton.isOn) {
                //付费
                
                [self editPhoneOut:YES];
            }else{
                //免费
                
                [self editPhoneOut:NO];
            }
        }
    }
    
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 2;
    }else if (section==1){
        if ([self.shopOff integerValue]==1) {
            return 7;
        }
        else
        {
            return 5;
        }
        
    }
    
    if ([self.shopOff integerValue]==1) {
        return 6;
    }
    else
    {
        return 2;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    LCLMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = (LCLMeTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"LCLMeTableViewCell_2" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:self.myInfo];
    
    
    [cell.switchButton addTarget:self action:@selector(tapSwithbutton:) forControlEvents:UIControlEventValueChanged];
    [cell.switchButton setTag:indexPath.row];
    
    if (indexPath.section==0) {
        
        [cell.switchButton setHidden:YES];
        if (indexPath.row==0) {
            [cell.nameLabel setText:[NSString stringWithFormat:@"信用豆：%@", userObj.coin]];
            [cell.actionButton setTitle:@"马上充值" forState:UIControlStateNormal];
            // app review begin
            if ([self.shopOff integerValue]==1) {
                [cell.actionButton setEnabled:NO];
            }
            else
            {
                cell.actionButton.hidden=YES;

            }
            //end
        }else{
            [cell.nameLabel setText:[NSString stringWithFormat:@"等级：%@", userObj.vip]];
            [cell.actionButton setTitle:@"账号升级" forState:UIControlStateNormal];
            // app review begin
            if ([self.shopOff integerValue]==1) {
                [cell.actionButton setEnabled:NO];

            }
            else
            {
                cell.actionButton.hidden=YES;
            }
            //end

        }
    }else if (indexPath.section==1){
        [cell.actionButton setHidden:YES];
        [cell.switchButton setHidden:YES];
        if (indexPath.row==0) {
            [cell.nameLabel setText:@"相册"];
        }else if(indexPath.row==1){
            [cell.nameLabel setText:@"我的资料"];
        }else if(indexPath.row==2){
            [cell.nameLabel setText:@"我的主页"];
        }else if(indexPath.row==3){
            [cell.nameLabel setText:@"我的关注"];
        }else if(indexPath.row==4){
            [cell.nameLabel setText:@"视频认证"];
            
            [cell.actionButton setHidden:NO];
            [cell.actionButton setEnabled:NO];
            [cell.actionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            if ([userObj.video integerValue]==1) {
                [cell.actionButton setTitle:@"已认证" forState:UIControlStateNormal];
            }else{
                [cell.actionButton setTitle:@"没认证" forState:UIControlStateNormal];
            }
            
        }else if(indexPath.row==5){
            [cell.nameLabel setText:@"充值记录"];
        }else if(indexPath.row==6){
            [cell.nameLabel setText:@"消费记录"];
        }
    }else if (indexPath.section==2){
        [cell.switchButton setHidden:YES];
        [cell.arrowImageView setHidden:YES];
        // app review begin
        if ([self.shopOff integerValue]==1) {
            if (indexPath.row==0) {
                [cell.arrowImageView setHidden:NO];
                [cell.nameLabel setText:@"设置开启密码"];
                
                [cell.actionButton setTitle:@"建设中" forState:UIControlStateNormal];
                // app review begin
                cell.actionButton.hidden=YES;
                //end
            }
            if(indexPath.row==1){
                [cell.switchButton setHidden:NO];
                [cell.actionButton setHidden:YES];
                [cell.nameLabel setText:@"是否隐身(针对通讯录)"];
                
                if ([userObj.online integerValue]==1) {
                    [cell.switchButton setOn:NO animated:YES];
                }else{
                    [cell.switchButton setOn:YES animated:YES];
                }
            }else if(indexPath.row==2){
                [cell.switchButton setHidden:NO];
                [cell.actionButton setHidden:YES];
                [cell.nameLabel setText:@"是否允许付信用豆看手机"];
                
                if ([userObj.phoneout integerValue]==1) {
                    [cell.switchButton setOn:NO animated:YES];
                }else{
                    [cell.switchButton setOn:YES animated:YES];
                }
            }else if(indexPath.row==3){
                [cell.switchButton setHidden:NO];
                [cell.actionButton setHidden:YES];
                [cell.nameLabel setText:@"提示音开关"];
            }else if(indexPath.row==4){
                [cell.switchButton setHidden:NO];
                [cell.actionButton setHidden:YES];
                [cell.nameLabel setText:@"振动开关"];
            }else if(indexPath.row==5){
                [cell.arrowImageView setHidden:NO];
                [cell.actionButton setHidden:YES];
                [cell.nameLabel setText:@"VIP通道（建设中）"];
            }
        }
        else
        {
            if(indexPath.row==0){
                [cell.switchButton setHidden:NO];
                [cell.actionButton setHidden:YES];
                [cell.nameLabel setText:@"是否隐身(针对通讯录)"];
                
                if ([userObj.online integerValue]==1) {
                    [cell.switchButton setOn:NO animated:YES];
                }else{
                    [cell.switchButton setOn:YES animated:YES];
                }
            }else if(indexPath.row==1){
                [cell.switchButton setHidden:NO];
                [cell.actionButton setHidden:YES];
                [cell.nameLabel setText:@"是否允许信用豆查看手机"];
                
                if ([userObj.phoneout integerValue]==1) {
                    [cell.switchButton setOn:NO animated:YES];
                }else{
                    [cell.switchButton setOn:YES animated:YES];
                }
            }
        }
        //end
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    


    
    
    if (indexPath.section==0) {
        // app review begin
        if ([self.shopOff integerValue]==1) {
            [self.tabBarController setSelectedIndex:3];
        }
        //end
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
            
            LCLMyPictureInfoViewController *myPicInfo = [[LCLMyPictureInfoViewController alloc] initWithNibName:@"LCLMyPictureInfoViewController" bundle:nil];
            [myPicInfo setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myPicInfo animated:YES];
            
        }
        else if (indexPath.row==1){
        
            LCLEditMyInfoViewController *editMyInfo = [[LCLEditMyInfoViewController alloc] initWithNibName:@"LCLEditMyInfoViewController" bundle:nil];
            [editMyInfo setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:editMyInfo animated:YES];
        }
        else if (indexPath.row==2){
        
            LCLPeopleInfoViewController *people = [[LCLPeopleInfoViewController alloc] initWithNibName:@"LCLPeopleInfoViewController" bundle:nil];
            if (self.myInfo) {
                [people setUserInfo:self.myInfo];
            }
            [people setTitle:@"我的个人主页"];
            [people setIsFromMe:YES];
            [people setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:people animated:YES];
            
        }
        else if (indexPath.row==3){
        
            LCLMyFocusViewController *myFocus = [[LCLMyFocusViewController alloc] initWithNibName:@"LCLMyFocusViewController" bundle:nil];
            [myFocus setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myFocus animated:YES];
        }
        else if (indexPath.row==4){
            
            LCLMyMovieViewController *myFocus = [[LCLMyMovieViewController alloc] initWithNibName:@"LCLMyMovieViewController" bundle:nil];
            [myFocus setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myFocus animated:YES];
        }
        else if(indexPath.row==5){
            
            LCLPayListAndMoneyListViewController *myFocus = [[LCLPayListAndMoneyListViewController alloc] initWithNibName:@"LCLPayListAndMoneyListViewController" bundle:nil];
            [myFocus setTitle:@"充值记录"];
            [myFocus setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myFocus animated:YES];
        }
        else if(indexPath.row==6){

            LCLPayListAndMoneyListViewController *myFocus = [[LCLPayListAndMoneyListViewController alloc] initWithNibName:@"LCLPayListAndMoneyListViewController" bundle:nil];
            [myFocus setTitle:@"消费记录"];
            [myFocus setIsPayList:YES];
            [myFocus setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myFocus animated:YES];
        }
    }
    
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
        
        NSString *listURL = [NSString stringWithFormat:@"%@", GetMyInfoURL(userObj.ukey)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                self_weak_.myInfo = [dataSourceDic objectForKey:@"info"];
                
                LCLUserInfoObject *uObj = [LCLUserInfoObject allocModelWithDictionary:self_weak_.myInfo];
                [self_weak_.header.idLabel setText:[NSString stringWithFormat:@"ID:%@", userObj.uid]];
                [self_weak_.header.nameLabel setText:userObj.nickname];
                
                [self_weak_.header.headButton setBackgroundImageWithURL:[self_weak_.myInfo objectForKey:@"headimg"] defaultImagePath:DefaultImagePath];
                
                userObj.cityname = uObj.cityname;
                [[LCLCacheDefaults standardCacheDefaults] setCacheObject:[userObj getAllPropertyAndValue] forKey:UserInfoKey];
                
                [self_weak_.tableView reloadData];
            }
            
            [self_weak_.tableView headerEndRefreshing];
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
}


- (void)uploadHeadImage:(NSData *)data{
    
    [LCLWaitView showIndicatorView:YES];
    
    NSString *fileName = [[LCLTimeHelper getCurrentTimeString] stringByAppendingString:@".jpg"];
    NSString *filePath = [[LCLFilePathHelper getLCLCacheFolderPath] stringByAppendingString:fileName];
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
    
    if ([data writeToFile:filePath atomically:YES]) {
        
        LCLUploader *uploader = [[LCLUploader alloc] initWithURLString:ModifyHeadImageURL(userObj.ukey) fileName:fileName filePath:filePath];
        [uploader setFormName:@"image"];
        [uploader setCompleteBlock:^(NSString *errorString, NSMutableData *responseData, NSString *urlString) {
            
            NSDictionary *imageDic = [self.view getResponseDataDictFromResponseData:responseData withSuccessString:nil error:@""];
            
//            NSString *message=[imageDic objectForKey:@"message"];
//            
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
            if (imageDic) {
                
                NSString *url = [imageDic objectForKey:@"path"];
                if (url) {
                    url = [XSURL stringByAppendingString:url];
                }
                [[LCLCacheDefaults standardCacheDefaults] setCacheFileWithData:data forKey:url];
            }
            [LCLWaitView showIndicatorView:NO];
        }];
        [uploader startToUpload];
        
    }
    
}

- (void)uploadContact{

    NSMutableArray *array = [[NSMutableArray alloc] init];
    
//    NSArray *contactArray = [SMS_SDK addressBook];
    //add by duanran begin
    NSArray *contactArray = [SMSSDK addressBook];
    //end
    
    for (int i=0; i<contactArray.count; i++) {
        
//      SMS_AddressBook *addressBook = [contactArray objectAtIndex:i];
        
        SMSSDKAddressBook *addressBook = [contactArray objectAtIndex:i];
        
        NSString *name = addressBook.name;
        NSString *phoneNum = addressBook.phones;

        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", name], @"name", [NSString stringWithFormat:@"%@", phoneNum], @"phone", nil];
        
        if (TestContact) {
            if (array.count==0) {
                [array addObject:dic];
            }
        }else{
            [array addObject:dic];
        }
    }
    
    if (array.count>0) {
        
        NSData *jsonData = [NSObject jsonDataWithObj:array];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [NSString stringWithFormat:@"str=%@", jsonString];
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        [self uploadContactJsonData:jsonData];
        
    }else{
        [LCLTipsView showTips:@"通讯录数据为空" location:LCLTipsLocationMiddle];
    }

}

#pragma mark - 上传通讯录
- (void)uploadContactJsonData:(NSData *)contactData{
    
    @weakify(self);
    
     NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LCLGetToken checkHaveLoginWithShowLoginView:NO]];
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:dic];

    LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:UploadContactsURL(userObj.ukey)];
    [login setHttpMehtod:LCLHttpMethodPost];
    [login setHttpBodyData:contactData];
    [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
        
        NSDictionary *dataDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
        if (dataDic) {
            
            
        }
        
    }];
    [login startToDownloadWithIntelligence:NO];
    
}

- (void)editPhoneOut:(BOOL)phone{

    [LCLWaitView showIndicatorView:YES];
    
    @weakify(self);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LCLGetToken checkHaveLoginWithShowLoginView:NO]];
    if (dic) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:dic];
        
        NSString *registString = [NSString stringWithFormat:@"phoneout=1&phone=1"];
        if (phone) {
            registString = [NSString stringWithFormat:@"phoneout=0&phone=0"];
        }
        
        NSString *editURL = [NSString stringWithFormat:@"%@?%@", EditMyInfoURL(userObj.ukey), registString];
        LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:editURL];
        [login setHttpMehtod:LCLHttpMethodPost];
        [login setEncryptType:LCLEncryptTypeNone];
        [login setHttpBodyData:[registString dataUsingEncoding:NSUTF8StringEncoding]];
        [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
            
            [LCLWaitView showIndicatorView:NO];

            NSDictionary *dataDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:@"修改成功" error:@""];
            if (dataDic) {
                
                [self_weak_ postNotificationWithName:@"DidEditUserInfo" object:nil];
            }
        }];
        [login startToDownloadWithIntelligence:NO];
        
    }else{
        
    }

}

- (void)editPhoneOnline:(BOOL)phoneOnline{
    
    [LCLWaitView showIndicatorView:YES];
    
    @weakify(self);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LCLGetToken checkHaveLoginWithShowLoginView:NO]];
    if (dic) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:dic];
        
        NSString *registString = [NSString stringWithFormat:@"online=1"];
        if (phoneOnline) {
            registString = [NSString stringWithFormat:@"online=0"];
        }
        
        NSString *editURL = [NSString stringWithFormat:@"%@?%@", EditMyInfoURL(userObj.ukey), registString];
        LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:editURL];
        [login setHttpMehtod:LCLHttpMethodPost];
        [login setEncryptType:LCLEncryptTypeNone];
        [login setHttpBodyData:[registString dataUsingEncoding:NSUTF8StringEncoding]];
        [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
            
            [LCLWaitView showIndicatorView:NO];
            
            NSDictionary *dataDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:@"修改成功" error:@""];
            if (dataDic) {
                
                [self_weak_ uploadContact];
                
                [self_weak_ postNotificationWithName:@"DidEditUserInfo" object:nil];
            }
        }];
        [login startToDownloadWithIntelligence:NO];
        
    }else{
        
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












