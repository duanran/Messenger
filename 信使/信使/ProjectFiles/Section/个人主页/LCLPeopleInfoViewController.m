//
//  LCLPeopleInfoViewController.m
//  信使
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLPeopleInfoViewController.h"

#import "LCLPeopleHeaderView.h"

#import "LCLPeopleInfoMeetTableViewCell.h"
#import "LCLPeopleInfoPicTableViewCell.h"

#import "LCLCreateMeetingViewController.h"
#import "MJPhotoBrowser.h"
#import "LCLVideoViewController.h"
#import "GiveCoinRequest.h"

#import "SelectedMapViewController.h"

@interface LCLPeopleInfoViewController ()<LCLPeopleInfoPicTableViewCellDelegate,MJPhotoBrowserDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *communicationButton;
@property (weak, nonatomic) IBOutlet UIButton *InviteMeetButton;
@property (weak,nonatomic) IBOutlet UIButton *presentBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) LCLPeopleHeaderView *header;

@property (nonatomic, strong) NSMutableArray *myPicArray;
@property (nonatomic, strong) NSMutableArray *myMeetArray;

@property (nonatomic) BOOL isMeeting;

@end

@implementation LCLPeopleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGFloat width = kDeviceWidth/3.0;
    CGRect frame = self.photoButton.frame;
    frame.origin.x = 0;
    frame.size.width = width;
    [self.photoButton setFrame:frame];
    frame.origin.x = width;
    [self.presentBtn setFrame:frame];
    frame.origin.x = width*2;
    [self.InviteMeetButton setFrame:frame];
//    frame.origin.x = width*3;
//    [self.InviteMeetButton setFrame:frame];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, frame.origin.y, 1, frame.size.height)];
    [oneLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.bottomView addSubview:oneLabel];
    
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*width, frame.origin.y, 1, frame.size.height)];
    [twoLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.bottomView addSubview:twoLabel];
    UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*width, frame.origin.y, 1, frame.size.height)];
    [threeLabel setBackgroundColor:[UIColor lightGrayColor]];

    [self.bottomView addSubview:threeLabel];

    
    self.isMeeting = NO;
    
    self.header = (LCLPeopleHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"LCLPeopleHeaderView" owner:self options:nil] lastObject];
    [self.header.segmentControl addTarget:self action:@selector(tabSegmentControl:) forControlEvents:UIControlEventValueChanged];
    [self.header.headButton addTarget:self action:@selector(tapHeadButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView setTableHeaderView:self.header];

    if (self.isFromMe) {
        [self.bottomView setHidden:YES];
    }else{
        CGRect frame = self.tableView.frame;
        frame.size.height = frame.size.height-40;
        [self.tableView setFrame:frame];
    }
    
    if (self.userInfo && !self.isFromMe && !self.refresh) {
        
        [self setPeopleInfoWithDic:self.userInfo];
        
    }else{
    
        [self loadMyInfo];
    }
    
    @weakify(self);
    
    [self_weak_.tableView addHeaderWithCallback:^{
        
        [self_weak_ loadMeetingData];
        
        [self_weak_ loadServerData];
    }];
    
    [self_weak_.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapFocusButton:(id)sender{

    [self focusAction:YES];
}

- (IBAction)tapUnFocusButton:(id)sender{
    
    [self focusAction:NO];
}

- (void)focusAction:(BOOL)isFocus{

    @weakify(self);
    
    [LCLWaitView showIndicatorView:YES];
    
    NSDictionary *userDic = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userDic) {
        
        LCLUserInfoObject *myObj = [LCLUserInfoObject allocModelWithDictionary:userDic];
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:self.userInfo];

        NSString *listURL = [NSString stringWithFormat:@"%@", FocusPeopleURL(myObj.ukey, userObj.uid)];
        if (!isFocus) {
            listURL = [NSString stringWithFormat:@"%@", UNFocusPeopleURL(myObj.ukey, userObj.uid)];
        }
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            [LCLWaitView showIndicatorView:NO];
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                if (!isFocus) {
                    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"+关注" style:UIBarButtonItemStyleBordered target:self action:@selector(tapFocusButton:)];
                    item.tintColor = [UIColor whiteColor];
                    self_weak_.navigationItem.rightBarButtonItem = item;
                }else{
                    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消关注" style:UIBarButtonItemStyleBordered target:self action:@selector(tapUnFocusButton:)];
                    item.tintColor = [UIColor whiteColor];
                    self_weak_.navigationItem.rightBarButtonItem = item;
                }
                
            }
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
}


- (void)setPeopleInfoWithDic:(NSDictionary *)userDic{

    self.userInfo = userDic;
    
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userDic];
    [self.header.idLabel setText:[NSString stringWithFormat:@"ID:%@",userObj.uid]];
    if (self.isFromMe) {
        [self.header setPeopleNameWithName:[NSString stringWithFormat:@"%@", userObj.cityname]];
    }else{
        if (self.refresh) {
            [self.header setPeopleNameWithName:[NSString stringWithFormat:@"%@", userObj.cityname]];
        }else{
            [self.header setPeopleNameWithName:[NSString stringWithFormat:@"%@", userObj.place]];
        }
    }
    
    if (!self.isFromMe) {
        if ([userObj.is_follow integerValue]==0) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"+关注" style:UIBarButtonItemStyleBordered target:self action:@selector(tapFocusButton:)];
            item.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem = item;
        }else{
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消关注" style:UIBarButtonItemStyleBordered target:self action:@selector(tapUnFocusButton:)];
            item.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem = item;
        }
    }
    
    [self.navigationItem setTitle:userObj.nickname];
    
//    NSDictionary *vipInfo = userObj.vipinfo;
//    if (vipInfo) {
//        [self.header.levelImageView setImageWithURL:[vipInfo objectForKey:@"pic"] defaultImagePath:DefaultImagePath];
//    }else{
//        [self.header.levelImageView setHidden:YES];
//    }
//    if ([userObj.video integerValue]==1) {
//        [self.header.movieImageView setHidden:NO];
//    }else{
//        [self.header.movieImageView setHidden:YES];
//    }
    [self.header.levelImageView setHidden:YES];
    [self.header.movieImageView setHidden:YES];

    NSString *peopleURL = GetDownloadPicURL(userObj.headimg);
    if (self.isFromMe || self.refresh) {
        peopleURL = userObj.headimg;
    }
    [self.header.headButton setImageWithURL:peopleURL defaultImagePath:DefaultImagePath];
    
    [self.header.infoLabel setText:[NSString stringWithFormat:@"%@岁  %@cm  %@kg", userObj.age, userObj.height, userObj.weight]];
    [self.header.addressLabel setTitle:[NSString stringWithFormat:@"%@|%@", userObj.len, userObj.times] forState:UIControlStateNormal];
    if (self.isFromMe) {
        [self.header.addressLabel setTitle:[NSString stringWithFormat:@"%@|%@", userObj.cityname, userObj.last_login_time] forState:UIControlStateNormal];
    }
}

- (IBAction)communicationButton:(id)sender{

    [LCLTipsView showTips:@"正在开发中" location:LCLTipsLocationMiddle];
}

- (IBAction)tapBaomingAction:(UIButton *)sender{

    [self baomingWithID:[NSString stringWithFormat:@"%li", sender.tag]];
}
//报名约会
- (void)baomingWithID:(NSString *)meetID{
    
    @weakify(self);
    
    [LCLWaitView showIndicatorView:YES];
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", BaomingMeetURL(userObj.ukey, meetID)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            [LCLWaitView showIndicatorView:NO];
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                [self_weak_ loadMeetingData];
                
            }
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
}
- (IBAction)meetButton:(id)sender{
    
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:self.userInfo];

    LCLCreateMeetingViewController *createMeet = [[LCLCreateMeetingViewController alloc] initWithNibName:@"LCLCreateMeetingViewController" bundle:nil];
    [createMeet setInviteuid:userObj.uid];
    [createMeet setIsInviteMeet:YES];
    [createMeet setCanShowNavBackItem:YES];
    [createMeet setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:createMeet animated:YES];
}
-(IBAction)tapPresentBtn:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"向他赠送多少信用豆" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        UITextField *TextField=[alertView textFieldAtIndex:0];

        if ([TextField.text integerValue]<=0||TextField.text==NULL||[TextField.text isEqualToString:@"(null)"]||TextField.text==nil||[TextField.text isEqualToString:@""]) {
            return;
        }
        
        GiveCoinRequest *request=[[GiveCoinRequest alloc]init];
        
        NSDictionary *userInfo=[[LCLCacheDefaults standardCacheDefaults]objectForCacheKey:UserInfoKey];
        
        NSString *uKey=[userInfo objectForKey:@"ukey"];
        request.uKey=uKey;
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:self.userInfo];
        
        request.uid=userObj.uid;
        request.coin=TextField.text;
        
        
        [request GETRequest:^(id reponseObject) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"赠送成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];

        } failureCallback:^(NSString *errorMessage) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];

        }];
        
        
        
        
    }
}
- (IBAction)tapPhoneButton:(id)sender{

    if (self.userInfo) {
        
        @weakify(self);
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:self.userInfo];

        if ([userObj.phone integerValue]==0) {
            
            [LCLWaitView showIndicatorView:YES];
            
            NSDictionary *myInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
            LCLUserInfoObject *myObj = [LCLUserInfoObject allocModelWithDictionary:myInfo];
            
            NSString *listURL = [NSString stringWithFormat:@"%@", LookPhoneMoneyURL(myObj.ukey)];
            
            LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
            [downloader setHttpMehtod:LCLHttpMethodGet];
            [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
                
                [LCLWaitView showIndicatorView:NO];
                
                NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
                if (dataSourceDic) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"查看手机需要%@信用豆，确定查看？", [dataSourceDic objectForKey:@"coin"]] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
                        if ([index integerValue]==1) {
                            [self_weak_ lookPhoneWithUID:userObj.uid phone:userObj.mobile];
                        }
                    }];
                    [alertView show];
                    
                    
                }
            }];
            [downloader startToDownloadWithIntelligence:NO];

        }else{
            
            [self lookPhoneWithUID:userObj.uid phone:userObj.mobile];
        }
    }
}

- (IBAction)tabSegmentControl:(UISegmentedControl *)segment{
    
    if (segment.selectedSegmentIndex==1) {
        self.isMeeting = YES;
        
        if (self.myMeetArray.count>0) {
            [self.tableView reloadData];
        }else{
            
            [LCLWaitView showIndicatorView:YES];
            
            [self loadMeetingData];
        }
    }else{
        self.isMeeting = NO;
        
        if (self.myPicArray.count>0) {
            [self.tableView reloadData];
        }else{
            
            [LCLWaitView showIndicatorView:YES];
            
            [self loadServerData];
        }
    }
}

- (IBAction)tapHeadButton:(UIButton *)sender{
    
    [[LCLAvatarBrowser shareLCLImageController] showImage:sender.imageView];
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isMeeting) {
        return 88;
    }
    
    if (self.myPicArray.count>0) {
        NSInteger row = self.myPicArray.count/3;
        NSInteger column = self.myPicArray.count%3;
        
        CGFloat orgX = 10;
        CGFloat orgY = 10;
        CGFloat width = (kDeviceWidth-4*orgX)/3.0;
        CGFloat height = width*3/4.0;

        if (column==0) {
            return row*height+(row+1)*orgY;
        }else{
            return (row+1)*height+(row+2)*orgY;
        }
    }
    
    return kDeviceHeight/2.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isMeeting) {
        return self.myMeetArray.count;
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    if (self.isMeeting) {
        
        LCLPeopleInfoMeetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LCLPeopleInfoMeetTableViewCell_2" owner:self options:nil]lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        
        
        [cell.locationBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        NSDictionary *dic = [self.myMeetArray objectAtIndex:indexPath.row];
        LCLCreateMeetObject *meetObj = [LCLCreateMeetObject allocModelWithDictionary:dic];
        
        [cell.meetTitleLabel setText:meetObj.title];
        [cell.meetAddressLabel setText:[NSString stringWithFormat:@"地点：%@", meetObj.place]];
        [cell.meetTimeLabel setText:[NSString stringWithFormat:@"时间：%@", meetObj.date_time]];
        
        NSString *sign=[dic objectForKey:@"is_sign"];

        
        if ([meetObj.style integerValue]==1) {
            if ([sign integerValue]==1) {
                [cell.meeButton setTitle:@"已报名" forState:UIControlStateNormal];

            }
            else
            {
                [cell.meeButton setTitle:@"报名约会" forState:UIControlStateNormal];

            }
            
        }
        
        [cell.meeButton setTag:[meetObj.iD integerValue]];
        [cell.meeButton addTarget:self action:@selector(tapBaomingAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.isFromMe) {
            [cell.meeButton setHidden:YES];
        }

        return cell;
        
    }else{
        
        LCLPeopleInfoPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell = [LCLPeopleInfoPicTableViewCell loadXibView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        cell.picCellDelegate = self;
        
        [cell setIsFromMe:self.isFromMe];
        [cell setPicArray:self.myPicArray];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (void)buttonAction:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = EIGetViewBySubView(button, [UITableViewCell class]);
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
 
    SelectedMapViewController *mapView=[[SelectedMapViewController alloc]init];
    NSDictionary *dic = [self.myMeetArray objectAtIndex:indexPath.row];
    LCLCreateMeetObject *meetObj = [LCLCreateMeetObject allocModelWithDictionary:dic];
    CLLocationCoordinate2D coordinate;
    coordinate.longitude=[meetObj.lng doubleValue];
    coordinate.latitude=[meetObj.lat doubleValue];
    
    mapView.dateCoordinate=coordinate;
    mapView.address=meetObj.place;
    [self.navigationController pushViewController:mapView animated:YES];
    
}
- (void)didTapPicWithButton:(LCLPhotoButton *)button{

    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:self.userInfo];

    [self lookPicWithUID:userObj.uid fromImageView:button.blurImageView index:button.tag];
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
-(void)playVideo:(NSString *)videoPath
{
    LCLVideoViewController *videoController=[[LCLVideoViewController alloc]init];
    videoController.videoUrl=videoPath;
    [self.navigationController pushViewController:videoController animated:YES];
}

#pragma mark -下载数据
- (void)loadServerData{
    
    @weakify(self);
    
    NSDictionary *myInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (myInfo && self.userInfo) {
        
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:self.userInfo];

        LCLUserInfoObject *myObj = [LCLUserInfoObject allocModelWithDictionary:myInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", LookUserPhotosURL(myObj.ukey, userObj.uid)];
        if (self_weak_.isFromMe) {
            listURL = [NSString stringWithFormat:@"%@", MyPhotosURL(myObj.ukey)];
        }
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            [LCLWaitView showIndicatorView:NO];

            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {

                self_weak_.myPicArray = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"list"]];
            }
            
            [self_weak_.tableView reloadData];

            [self_weak_.tableView headerEndRefreshing];
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }else{
        
        LCLMainQueue(^{
            [self_weak_.tableView headerEndRefreshing];
        });
    }
}

- (void)loadPeopleInfo{

    @weakify(self);
    
    NSDictionary *myInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (myInfo && self.userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:self.userInfo];
        
        LCLUserInfoObject *myObj = [LCLUserInfoObject allocModelWithDictionary:myInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", LookPeopleInfoURL(myObj.ukey, userObj.uid)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                NSDictionary *dic = [dataSourceDic objectForKey:@"info"];
                [[LCLCacheDefaults standardCacheDefaults] setCacheObject:dic forKey:UserInfoKey];
                
                [self_weak_ setPeopleInfoWithDic:dic];
            }
            
            [self_weak_.tableView reloadData];
            
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }

}

- (void)loadMyInfo{
    
    @weakify(self);
    
    NSDictionary *myInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (myInfo && self.userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:self.userInfo];
        
        LCLUserInfoObject *myObj = [LCLUserInfoObject allocModelWithDictionary:myInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", LookPeopleInfoURL(myObj.ukey, userObj.uid)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                NSDictionary *dic = [dataSourceDic objectForKey:@"info"];
                [[LCLCacheDefaults standardCacheDefaults] setCacheObject:dic forKey:UserInfoKey];
                
                [self_weak_ setPeopleInfoWithDic:dic];
            }
            
            [self_weak_.tableView reloadData];
            
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
}


- (void)loadMeetingData{
    
    @weakify(self);
    
    NSDictionary *myInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (myInfo && self.userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:self.userInfo];
        
        LCLUserInfoObject *myObj = [LCLUserInfoObject allocModelWithDictionary:myInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", LookUserMeetingURL(myObj.ukey, userObj.uid)];
       
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            if (dataSourceDic) {
                
                self_weak_.myMeetArray = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"list"]];
            }
            
            [self_weak_.tableView reloadData];

            [LCLWaitView showIndicatorView:NO];
            
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
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
                
                if (self.UpDatedelegate && [self.UpDatedelegate respondsToSelector:@selector(upDateLookPhoneData)]) {
                    [self.UpDatedelegate upDateLookPhoneData];
                }
                
                
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
