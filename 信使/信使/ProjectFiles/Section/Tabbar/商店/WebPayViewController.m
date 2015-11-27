//
//  WebPayViewController.m
//  Messenger
//
//  Created by duanran on 15/11/27.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "WebPayViewController.h"
#import "MBProgressHUD.h"
@interface WebPayViewController ()
{
    UIWebView *payWebView;
}
@end

@implementation WebPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"支付";
    
    payWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.payUrl]];
    
    [MBProgressHUD showHUDAddedTo:payWebView animated:YES];
    [payWebView loadRequest:request];
    payWebView.delegate=self;
    
    [self.view addSubview:payWebView];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:payWebView animated:YES];

}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:payWebView animated:YES];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"支付失败" message:error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
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
