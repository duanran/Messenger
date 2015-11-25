//
//  LCLLoginViewController.m
//  信使
//
//  Created by 李程龙 on 15/5/26.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLLoginViewController.h"

#import "LCLRegistPhoneViewController.h"
#import "LCLForgetPassowrdViewController.h"
#import "BaiduPushBindRequest.h"

@interface LCLLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *fogetPasswordButton;

@end

@implementation LCLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"登录"];
    
    [self.lclBackgroundImageView setImage:[UIImage imageNamed:@"login_bg.jpg"]];
    
    [self.registButton setRoundedRadius:4.0];
    [self.registButton setTitleColor:APPPurpleColor forState:UIControlStateNormal];
    [self.fogetPasswordButton setTitleColor:APPPurpleColor forState:UIControlStateNormal];

    [self.loginButton setRoundedRadius:4.0];
    [self.loginButton setBackgroundColor:APPPurpleColor];
    
    [self.nameTextField setPlaceholder:NSLocalizedString(@"请输入用户名", nil)];
    [self.passwordTextField setPlaceholder:NSLocalizedString(@"请输入密码", nil)];
    [self.nameTextField setTintColor:APPPurpleColor];
    [self.passwordTextField setTintColor:APPPurpleColor];
    [self.nameTextField setTextColor:APPPurpleColor];
    [self.passwordTextField setTextColor:APPPurpleColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)tapForgetPasswordAction:(id)sender{

    LCLForgetPassowrdViewController *forgetPassword = [[LCLForgetPassowrdViewController alloc] initWithNibName:@"LCLForgetPassowrdViewController" bundle:nil];
    [self.navigationController pushViewController:forgetPassword animated:YES];
    
}

- (IBAction)tapLoginButton:(id)sender{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    NSString *name = self.nameTextField.text;
    NSString *password = self.passwordTextField.text;
    if (!name || [name isEqualToString:@""] || !password || [password isEqualToString:@""]) {
        return;
    }
    
    NSString *loginString = [[NSString alloc] initWithFormat:@"username=%@&password=%@", name, password];
    NSString *token = [[LCLCacheDefaults standardCacheDefaults] objectForCacheKey:DeviceTokenKey];
    if (token) {
        if (token.length>0) {
          
            token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
            token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
            token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            loginString = [[NSString alloc] initWithFormat:@"%@&token=%@&channel_id=%@&type=%@", loginString, token, name, @"2"];
        }
    }

    @weakify(self);
    
    [LCLWaitView showIndicatorView:YES];
    
    
    NSString *channel_id=GetPushChanel_id();
    NSString *body=[NSString stringWithFormat:@"%@&token=%@&type=2",loginString,channel_id];
    
    
    LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:LoginURL];
    [login setHttpMehtod:LCLHttpMethodPost];
    [login setHttpBodyData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    
        [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
        
        NSDictionary *dataDic = [self.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            
        if (dataDic) {
            
            NSString *ukey = [dataDic objectForKey:@"ukey"];
            if (ukey) {
                
                if (channel_id) {
                    BaiduPushBindRequest *request=[[BaiduPushBindRequest alloc]init];
                    request.uKey=ukey;
                    request.token=channel_id;

                    [request GETRequest:^(id reponseObject) {
                        NSLog(@"reponseObject=%@",reponseObject);

                    } failureCallback:^(NSString *errorMessage) {
                        NSLog(@"error=%@",errorMessage);

                    }];
                }
                
                
                
                
                LCLUserInfoObject *userObj = [LCLUserInfoObject allocModel];
                userObj.ukey = ukey;
                userObj.password = password;
                userObj.pwd = password;
                userObj.nickname = name;
                userObj.email = @"";
                userObj.headimg = @"";
                userObj.mobile = name;
                userObj.sex = @"1";
                userObj.qq = @"";
                userObj.province_name = @"";
                userObj.city_name = @"";
                userObj.area_name = @"";
                userObj.uid = @"";
                userObj.ID = @"";
                userObj.last_login = @"";
                userObj.freezing_coin = [dataDic objectForKey:@"freezing_coin"];
                userObj.sxf = [dataDic objectForKey:@"sxf"];
                userObj.shop_onoff=[dataDic objectForKey:@"shop_onoff"];
                
                
                NSDictionary *dic = [userObj getAllPropertyAndValue];
                [[LCLCacheDefaults standardCacheDefaults] setCacheObject:dic forKey:UserInfoKey];
                
                [LCLAppLoader loginAction];
                
                [self_weak_ dismissViewControllerAnimated:YES completion:nil];
                

                
            }
        }
        
        [LCLWaitView showIndicatorView:NO];
    }];
    [login startToDownloadWithIntelligence:NO];
}

- (IBAction)tapRegistButton:(id)sender{

    LCLRegistPhoneViewController *getPhone = [[LCLRegistPhoneViewController alloc] initWithNibName:@"LCLRegistPhoneViewController" bundle:nil];
    [self.navigationController pushViewController:getPhone animated:YES];

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




















