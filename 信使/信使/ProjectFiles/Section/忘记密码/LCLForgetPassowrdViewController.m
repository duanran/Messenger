//
//  LCLForgetPassowrdViewController.m
//  Fruit
//
//  Created by lichenglong on 15/7/24.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLForgetPassowrdViewController.h"

@interface LCLForgetPassowrdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end

@implementation LCLForgetPassowrdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"找回密码"];
    
    [self.resetButton setRoundedRadius:4.0];
    [self.resetButton setBackgroundColor:APPPurpleColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapSaveButton:(id)sender{
    
    if (!self.nameTextField.text || self.nameTextField.text.length==0) {
        
        [LCLTipsView showTips:@"用户名不能为空" location:LCLTipsLocationMiddle];
        
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];

//    @weakify(self);
//
//    [LCLWaitView showIndicatorView:YES];
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:self.passwordsTextField.text forKey:@"password"];
//    
//    NSString *registString = [[NSString alloc] initWithFormat:@"password=%@", self.passwordTextField.text];
//    
//    LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:EditPasswordURL(self.userObj.ukey)];
//    [login setHttpMehtod:LCLHttpMethodPost];
//    [login setHttpBodyData:[registString dataUsingEncoding:NSUTF8StringEncoding]];
//    [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
//        
//        NSDictionary *dataDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:@"修改成功" error:@""];
//        if (dataDic) {
//            
//            NSDictionary *dic = self_weak_.userObj.getAllPropertyAndValue;
//            if (dic.count>0) {
//                self_weak_.userObj.password = self_weak_.passwordsTextField.text;
//                self_weak_.userObj.pwd = self_weak_.passwordsTextField.text;
//                
//                [[LCLCacheDefaults standardCacheDefaults] setCacheObject:self_weak_.userObj.getAllPropertyAndValue forKey:UserInfoKey];
//                
//                [self_weak_.navigationController popViewControllerAnimated:YES];
//            }
//        }
//        
//        [LCLWaitView showIndicatorView:NO];
//        
//    }];
//    [login startToDownloadWithIntelligence:NO];
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
