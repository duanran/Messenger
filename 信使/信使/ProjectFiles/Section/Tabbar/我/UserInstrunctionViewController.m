//
//  UserInstrunctionViewController.m
//  Messenger
//
//  Created by duanran on 15/12/2.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "UserInstrunctionViewController.h"
#import "MBProgressHUD.h"
@interface UserInstrunctionViewController ()
{
    UIWebView *userWebView;

}
@end

@implementation UserInstrunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"用户须知";
    userWebView=[[UIWebView alloc]initWithFrame:self.view.frame];
    
    NSURL *url=[NSURL URLWithString:self.urlStr];
    
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    
//    [MBProgressHUD showHUDAddedTo:userWebView animated:YES];
    [userWebView loadRequest:request];
    [self.view addSubview:userWebView];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [MBProgressHUD hideHUDForView:userWebView animated:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [MBProgressHUD hideHUDForView:userWebView animated:YES];
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

@end
