//
//  LCLVerifyMeetingPasswordView.m
//  信使
//
//  Created by lichenglong on 15/6/1.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLVerifyMeetingPasswordView.h"

@interface LCLVerifyMeetingPasswordView () <UITextFieldDelegate>

@end


@implementation LCLVerifyMeetingPasswordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{

    [self.textField becomeFirstResponder];
    [self.indicator setHidesWhenStopped:YES];
    
    [self setBackgroundColor:[[UIColor blackColor]  colorWithAlphaComponent:0.5]];
    
    [self.cancleButton setRoundedRadius:4.0];
    [self.sureButton setRoundedRadius:4.0];
    
    [self.loadLabel setHidden:YES];
    [self.statusImageView setHidden:YES];
    [self.statusLabel setHidden:YES];
    [self.indicator stopAnimating];
}

- (IBAction)tapCancleButton:(id)sender{

    [self endKeyboardEditting];
    
    [LCLAlertController dismissAlertView:self];

}

- (IBAction)tapSureButton:(id)sender{

    if (self.oneLabel.text.length>0 && self.twoLabel.text.length>0 && self.threeLabel.text.length>0 && self.fourLabel.text.length>0 && self.fiveLabel.text.length>0 && self.sixLabel.text.length>0) {
        
        @weakify(self);
        
        [self.loadLabel setHidden:NO];
        [self.indicator startAnimating];
        [self.textField setHidden:YES];
        [self_weak_ endKeyboardEditting];
        [self showInutView:NO];
        
        NSDictionary *dic = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:dic];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", UncoldMeetingURL(userObj.ukey)];
        
        NSString *loginString = [[NSString alloc] initWithFormat:@"pwd=%@%@%@%@%@%@", self.oneLabel.text, self.twoLabel.text, self.threeLabel.text, self.fourLabel.text, self.fiveLabel.text, self.sixLabel.text];
        
        LCLDownloader *login = [[LCLDownloader alloc] initWithURLString:listURL];
        [login setHttpMehtod:LCLHttpMethodPost];
        [login setHttpBodyData:[loginString dataUsingEncoding:NSUTF8StringEncoding]];
        [login setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
            
            NSDictionary *dataDic = [self_weak_ getResponseDataDictFromResponseData:fileData withSuccessString:nil error:nil];
            if (dataDic) {
                [self_weak_ showStatus:YES];
            }else{
                [self_weak_ showStatus:NO];
                [self_weak_ performSelector:@selector(beginEdit) withObject:nil afterDelay:1.0];
            }
        }];
        [login startToDownloadWithIntelligence:NO];
    }
}

- (void)beginEdit{

    [self.loadLabel setHidden:YES];
    [self.statusImageView setHidden:YES];
    [self.statusLabel setHidden:YES];
    [self.indicator stopAnimating];

    [self showInutView:YES];
    
    [self.textField becomeFirstResponder];
}

- (void)showStatus:(BOOL)success{

    [self.loadLabel setHidden:YES];
    [self.indicator stopAnimating];
    
    [self.statusLabel setHidden:NO];
    [self.statusImageView setHidden:NO];
    if (success) {
        [self.statusLabel setText:@"解冻成功"];
        [self.statusImageView setImage:[UIImage imageNamed:@"checkBox_Select"]];
        [self hideAction];
    }else{
        [self.statusLabel setText:@"解冻失败"];
        [self.statusImageView setImage:[UIImage imageNamed:@"error"]];
    }
}

- (void)showInutView:(BOOL)show{
    [self.infoLabel setHidden:!show];
    [self.cancleButton setHidden:!show];
    [self.sureButton setHidden:!show];
    [self.textField setHidden:!show];
    [self.infoLabel setHidden:!show];

    [self.oneLabel setHidden:!show];
    [self.twoLabel setHidden:!show];
    [self.threeLabel setHidden:!show];
    [self.fourLabel setHidden:!show];
    [self.sixLabel setHidden:!show];
    [self.fiveLabel setHidden:!show];
}

- (void)hideVerifyView{
    [LCLAlertController dismissAlertView:self];
}

- (void)hideAction{
    [self performSelector:@selector(hideVerifyView) withObject:nil afterDelay:1.0];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSLog(@"len:%li  loca:%li", range.length, range.location);
    NSLog(@"%@", string);
    
    if (range.location>5) {
        return NO;
    }
    
    if (range.location==5) {
        [self.sixLabel setText:string];
    }else if (range.location==4){
        [self.sixLabel setText:@""];
        [self.fiveLabel setText:string];
    }else if (range.location==3){
        [self.sixLabel setText:@""];
        [self.fiveLabel setText:@""];
        [self.fourLabel setText:string];
    }else if (range.location==2){
        [self.sixLabel setText:@""];
        [self.fiveLabel setText:@""];
        [self.fourLabel setText:@""];
        [self.threeLabel setText:string];
    }else if (range.location==1){
        [self.sixLabel setText:@""];
        [self.fiveLabel setText:@""];
        [self.fourLabel setText:@""];
        [self.threeLabel setText:@""];
        [self.twoLabel setText:string];
    }else if (range.location==0){
        [self.sixLabel setText:@""];
        [self.fiveLabel setText:@""];
        [self.fourLabel setText:@""];
        [self.threeLabel setText:@""];
        [self.twoLabel setText:@""];
        [self.oneLabel setText:string];
    }else{
        [self.sixLabel setText:@""];
        [self.fiveLabel setText:@""];
        [self.fourLabel setText:@""];
        [self.threeLabel setText:@""];
        [self.twoLabel setText:@""];
        [self.oneLabel setText:@""];
    }
    
    return YES;
}


@end






