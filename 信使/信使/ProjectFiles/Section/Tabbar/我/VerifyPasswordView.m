//
//  VerifyPasswordView.m
//  Messenger
//
//  Created by duanran on 15/12/4.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "VerifyPasswordView.h"
#import "MBProgressHUD.h"

@implementation VerifyPasswordView
- (void)awakeFromNib{
    
    [self.textField becomeFirstResponder];
    
    [self setBackgroundColor:[[UIColor blackColor]  colorWithAlphaComponent:0.5]];
    
    [self.sureButton setRoundedRadius:4.0];
    self.textField.delegate=self;
    
    
    self.textField.keyboardType=UIKeyboardTypeNumberPad;
    
    
    
    
}




- (IBAction)tapSureButton:(id)sender{
    
    if (self.oneLabel.text.length>0 && self.twoLabel.text.length>0 && self.threeLabel.text.length>0 && self.fourLabel.text.length>0 && self.fiveLabel.text.length>0 && self.sixLabel.text.length>0&&self.sevenLabel.text.length>0) {
        
        @weakify(self);
        
        [self.textField setHidden:YES];
        [self_weak_ endKeyboardEditting];
      
        NSString *loginString = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@", self.oneLabel.text, self.twoLabel.text, self.threeLabel.text, self.fourLabel.text, self.fiveLabel.text, self.sixLabel.text,self.sevenLabel.text];
        
        
        NSDictionary *dic = [[LCLCacheDefaults standardCacheDefaults] objectForCacheKey:UserInfoKey];
        NSString *mobile = [dic objectForKey:@"mobile"];
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        
        NSArray *safePasswordArr=[userDefault objectForKey:@"safePassword"];
        
        for (int i=0; i<safePasswordArr.count; i++) {
            NSMutableDictionary *storeUserDic=(NSMutableDictionary *)[safePasswordArr objectAtIndex:i];
            NSString *userName=[storeUserDic objectForKey:@"userName"];
            if ([userName isEqualToString:mobile]) {
                NSString *password=[NSString stringWithFormat:@"%@",[storeUserDic objectForKey:@"password"]];

                if ([password isEqualToString:loginString]) {
                    [LCLAlertController dismissAlertView:self];
                }
                else
                {
                    
                    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
                    
                    [self addSubview:hud];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"密码输入错误";
                    [hud showAnimated:YES whileExecutingBlock:^{
                        sleep(2);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                        
                    }];

                }
                
                
            }
        }

        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"len:%li  loca:%li", range.length, range.location);
    NSLog(@"%@", string);
    
    if (range.location>6) {
        return NO;
    }
    
    if (range.location==6) {
        [self.sevenLabel setText:string];
    }else if (range.location==5){
        [self.sevenLabel setText:@""];
        [self.sixLabel setText:string];
    }else if (range.location==4){
        [self.sevenLabel setText:@""];
        [self.sixLabel setText:@""];
        [self.fiveLabel setText:string];
    }else if (range.location==3){
        [self.sevenLabel setText:@""];
        [self.sixLabel setText:@""];
        [self.fiveLabel setText:@""];
        [self.fourLabel setText:string];
    }else if (range.location==2){
        [self.sevenLabel setText:@""];
        [self.sixLabel setText:@""];
        [self.fiveLabel setText:@""];
        [self.fourLabel setText:@""];
        [self.threeLabel setText:string];
    }else if (range.location==1){
        [self.sevenLabel setText:@""];
        [self.sixLabel setText:@""];
        [self.fiveLabel setText:@""];
        [self.fourLabel setText:@""];
        [self.threeLabel setText:@""];
        [self.twoLabel setText:string];
    }
    else if(range.location==0)
    {
        [self.sevenLabel setText:@""];
        [self.sixLabel setText:@""];
        [self.fiveLabel setText:@""];
        [self.fourLabel setText:@""];
        [self.threeLabel setText:@""];
        [self.twoLabel setText:@""];
        [self.oneLabel setText:string];
    }
    else{
        [self.sevenLabel setText:@""];
        [self.sixLabel setText:@""];
        [self.fiveLabel setText:@""];
        [self.fourLabel setText:@""];
        [self.threeLabel setText:@""];
        [self.twoLabel setText:@""];
        [self.oneLabel setText:@""];
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
