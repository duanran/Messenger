//
//  LCLBaseWebViewController.m
//  测试ARC
//
//  Created by 李程龙 on 14-12-12.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()<UIWebViewDelegate>

@property (nonatomic) BOOL isLocalFile;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation BaseWebViewController

- (void)dealloc{
    
    [_indicatorView stopAnimating];
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    
    _webView.delegate = nil;
    [_webView stopLoading];
    [_webView removeFromSuperview];
    _webView = nil;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.indicatorView];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self.webView setFrame:self.view.bounds];
    [self.indicatorView setCenter:self.webView.center];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Actions

/**
 * 加载网址.
 */
-(void)loadWebSiteWithURLString:(NSString*)link{
    
    self.isLocalFile = NO;
    
    NSURL * url = [NSURL URLWithString:link];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

/**
 * 加载本地地址.
 */
-(void)loadLocalFileWithFilePath:(NSString*)filePath{

    self.isLocalFile = YES;

    NSURL * url = [NSURL fileURLWithPath:filePath];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

/**
 * 显示等待控件.
 */
- (void)showIndicatorView:(BOOL)show{
    
    if (show) {
        [self.indicatorView startAnimating];
        [self.indicatorView setHidden:NO];

        if (!self.isLocalFile) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
        
    }else{
        
        [self.indicatorView stopAnimating];
        [self.indicatorView setHidden:YES];

        if (!self.isLocalFile) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
}



#pragma mark - Configuration

/**
 * 网页显示空件.
 */
- (UIWebView *)webView{
    
    if (!_webView) {
        
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [_webView setBackgroundColor:[UIColor whiteColor]];//设置北京为白色
        _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
        _webView.delegate = self;
        [_webView setAutoresizesSubviews:YES];
        [_webView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin];
        
        [self.view addSubview:_webView];
    }
    
    return _webView;
}

/**
 * 等待控件.
 */
- (UIActivityIndicatorView *)indicatorView{
    
    if (!_indicatorView) {
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_indicatorView setCenter:self.webView.center];
        [_indicatorView stopAnimating];
        [_indicatorView setHidden:YES];
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicatorView setTintColor:[UIColor whiteColor]];
        [_indicatorView setColor:[UIColor whiteColor]];
        [_indicatorView setRoundedRadius:5.0];
        [_indicatorView setBackgroundColor:[UIColor colorWithRed:30/255.0
                                                           green:30/255.0
                                                            blue:30/255.0
                                                           alpha:0.95]];
    }
    
    return _indicatorView;
}



#pragma mark --
#pragma mark UIWebViewDelegate
//加载前
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self showIndicatorView:YES];
}

//加载完毕
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self showIndicatorView:NO];
}

//加载失败的回调
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self showIndicatorView:NO];
}

@end
















