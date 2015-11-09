//
//  LCLChangePasswordView.m
//  信使
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLChangePasswordView.h"

@implementation LCLChangePasswordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{

    [self.passwordsTextField becomeFirstResponder];
}

- (void)setIsEditNickName:(BOOL)isEditNickName{
    _isEditNickName = isEditNickName;
    if (_isEditNickName) {
        [self.passwordTextField setHidden:YES];
        [self.passwordLabel setHidden:YES];
        [self.passwordsLabel setText:@"昵称："];
        [self.titleLabel setText:@"修改昵称"];
    }
}

- (IBAction)tapCancleButton:(id)sender{

    [LCLAlertController dismissAlertView:self];
}

- (IBAction)tapSureButton:(id)sender{
   
    if (self.passwordsTextField.text.length>0) {
        if (self.isEditNickName) {
            
            [self editNickName];
            
        }else{
            [self editPassword];
        }
    }
}

- (void)editNickName{

    @weakify(self);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LCLGetToken checkHaveLoginWithShowLoginView:NO]];
    if (dic) {

        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:dic];
        userObj.nickname = self_weak_.passwordsTextField.text;
        
        NSString *registString = [NSString stringWithFormat:@"nickname=%@", [self_weak_.passwordsTextField.text encodeWithUTF8]];
        
        NSString *editURL = [NSString stringWithFormat:@"%@?%@", EditMyInfoURL(userObj.ukey), registString];
        LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:editURL];
        [login setHttpMehtod:LCLHttpMethodPost];
        [login setEncryptType:LCLEncryptTypeNone];
        [login setHttpBodyData:[registString dataUsingEncoding:NSUTF8StringEncoding]];
        [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
            
            NSDictionary *dataDic = [self_weak_ getResponseDataDictFromResponseData:fileData withSuccessString:@"修改成功" error:@""];
            if (dataDic) {
                
                [[LCLCacheDefaults standardCacheDefaults] setCacheObject:[userObj getAllPropertyAndValue] forKey:UserInfoKey];
                
                [self_weak_ postNotificationWithName:@"DidEditUserInfo" object:nil];
            }
            
        }];
        [login startToDownloadWithIntelligence:NO];
        
        [LCLAlertController dismissAlertView:self];
    }else{
    
    }
}

- (void)editPassword{

    if (self.passwordsTextField.text.length==0 || self.passwordTextField.text.length==0) {
        return;
    }
    
    if (![self.passwordsTextField.text isEqualToString:self.passwordTextField.text]) {
        
        [LCLTipsView showTips:@"密码不一致" location:LCLTipsLocationMiddle];
        
        return;
    }
    
    @weakify(self);
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", ChangePasswordURL(userObj.ukey)];
        
        NSString *loginString = [[NSString alloc] initWithFormat:@"oldpwd=%@&password=%@", userObj.password, self_weak_.passwordTextField.text];
        
        LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:listURL];
        [login setHttpMehtod:LCLHttpMethodPost];
        [login setHttpBodyData:[loginString dataUsingEncoding:NSUTF8StringEncoding]];
        [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
            
            NSDictionary *dataDic = [self_weak_ getResponseDataDictFromResponseData:fileData withSuccessString:@"修改成功" error:@""];
            if (dataDic) {
                
            }
        }];
        [login startToDownloadWithIntelligence:NO];
        
        [LCLAlertController dismissAlertView:self];
        
    }else{
        
    }
}


@end










