//
//  BaseViewController.m
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/4/16.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "BaseViewController.h"

#import "LCLNotifyCenterViewController.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "LCLVideoViewController.h"
@interface BaseViewController ()<MJPhotoBrowserDelegate>

@property (strong, nonatomic) UIButton *messageBtn;

@end

@implementation BaseViewController

- (id)init{

    self = [super init];
    if (self) {
        self.canShowNavBar = YES;
        self.canShowNavBackItem = YES;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.canShowNavBar = YES;
        self.canShowNavBackItem = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0], NSForegroundColorAttributeName, [UIFont systemFontOfSize:17], NSFontAttributeName,nil]];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavBarBackgroundImage];
    
    if (self.canShowNavBackItem) {
        [self setNavBackButtonItem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:!self.canShowNavBar];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return NO;
}

- (BOOL)shouldAutorotate{
    
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleDefault;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    return  UIStatusBarStyleLightContent;
    //= 1 白色文字，深色背景时使用
}

#pragma mark - Actions
//设置navBar背景图片
- (void)setNavBarBackgroundImage{
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    
    UIImage *image = [LCLImageHelper getImageWithColor:APPPurpleColor imageSize:CGSizeMake(kDeviceWidth, 64)];
    
#define kSCNavBarImageTag 10
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }else{
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavBarImageTag];
        if (imageView == nil){
            imageView = [[UIImageView alloc] initWithImage:image];
            [imageView setTag:kSCNavBarImageTag];
            [navBar insertSubview:imageView atIndex:0];
        }
    }
}

//重写返回按钮
- (void)setNavBackButtonItem{
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 10, 19);
    [backBtn setImage:[UIImage imageNamed:@"b_sanjiao"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backItem;
}

- (IBAction)navBackBtnClick:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//设置左消息item
- (void)setNotifyMessageNavigationItem{
    
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.messageBtn.frame = CGRectMake(0, 0, 25, 25);
    [self.messageBtn setImage:[UIImage imageNamed:@"title_message_a"] forState:UIControlStateNormal];
    [self.messageBtn setShouldAllowMaxNumber:YES];
    NSString *num = [[LCLCacheDefaults standardCacheDefaults] objectForCacheKey:ReceiveNotificationKey];
    if ([num intValue]==1) {
        [self.messageBtn setBadgeValue:@"100"];
    }
    [self.messageBtn addTarget:self action:@selector(tapNoitfyMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *messageItme = [[UIBarButtonItem alloc]initWithCustomView:self.messageBtn] ;
    self.navigationItem.leftBarButtonItem = messageItme;
}

- (IBAction)tapNoitfyMessageAction:(id)sender{
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:YES];
    if (userInfo) {
        LCLNotifyCenterViewController *notify = [[LCLNotifyCenterViewController alloc] initWithNibName:@"LCLNotifyCenterViewController" bundle:nil];
        [notify setHidesBottomBarWhenPushed:YES];
        [notify setUserInfo:userInfo];
        [self.navigationController pushViewController:notify animated:YES];
    }
    
    [[LCLCacheDefaults standardCacheDefaults] removeCacheObjectForKey:@"ReceiveNotificationKey"];
    [self.messageBtn setBadgeValue:@"0"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ClearNotificationKey object:nil];
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
                
                
            }
        }];
        [downloader startToDownloadWithIntelligence:NO];
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
//            browser.delegate=self;
            [browser show];
            
        }
    }];
    [downloader startToDownloadWithIntelligence:NO];
}


#pragma mark -Gettter
/**
 *  统一设置背景图片
 *
 *  @param backgroundImage 目标背景图片
 */
- (UIImageView *)lclBackgroundImageView{
    
    if (!_lclBackgroundImageView) {
        
        _lclBackgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [_lclBackgroundImageView setTag:123456789];
        [_lclBackgroundImageView setRestorationIdentifier:@"123456789"];
        [_lclBackgroundImageView setAutoresizesSubviews:YES];
        [_lclBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin];
        [self.view insertSubview:_lclBackgroundImageView atIndex:0];
    }
    
    return _lclBackgroundImageView;
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










