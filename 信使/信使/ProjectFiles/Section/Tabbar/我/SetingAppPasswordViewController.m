//
//  SetingAppPasswordViewController.m
//  Messenger
//
//  Created by duanran on 15/12/3.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "SetingAppPasswordViewController.h"

typedef enum
{
    openType        =   0,
    colseType       =   1
    
}SaveType;


@interface SetingAppPasswordViewController ()<UITextFieldDelegate>
{
    SaveType saveType;
}
@end

@implementation SetingAppPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"开启密码";
    self.okBtn.backgroundColor=APPPurpleColor;
    self.okBtn.titleLabel.textColor=[UIColor whiteColor];
    self.cancelBtn.backgroundColor=[UIColor grayColor];
    self.cancelBtn.titleLabel.textColor=[UIColor whiteColor];
    self.okBtn.layer.cornerRadius=4;
    self.cancelBtn.layer.cornerRadius=4;
    self.passWordTextField.delegate=self;
    self.passWordTextField.secureTextEntry=YES;
    self.passWordTextField.keyboardType=UIKeyboardTypeNumberPad;
}


-(IBAction)coloseTextField:(id)sender
{
    UIView *tapView=(UIView *)sender;
    for (id subview in [tapView subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            [self.passWordTextField resignFirstResponder];
            break;
        }
        for (id passwordView in [subview subviews]) {
            if ([passwordView isKindOfClass:[UITextField class]]) {
                [self.passWordTextField resignFirstResponder];
                break;
            }
        }
        
    }
}

-(IBAction)select:(id)sender
{
    UISegmentedControl *seg=(UISegmentedControl *)sender;
    NSInteger index = seg.selectedSegmentIndex;

    if (index==0) {
        self.passwordView.hidden=NO;
        self.okBtnToTopConstrant.constant=110;
    }
    else
    {
        self.okBtnToTopConstrant.constant=30;
        self.passwordView.hidden=YES;
    }
}
-(IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)save:(id)sender
{
    NSDictionary *dic = [[LCLCacheDefaults standardCacheDefaults] objectForCacheKey:UserInfoKey];
    NSString *mobile = [dic objectForKey:@"mobile"];
    if (saveType==openType) {
        
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        
        NSArray *safePasswordArr=[userDefault objectForKey:@"safePassword"];
        NSMutableArray *arr=[NSMutableArray arrayWithArray:safePasswordArr];
        
        for (int i=0; i<safePasswordArr.count; i++) {
            NSMutableDictionary *storeUserDic=(NSMutableDictionary *)[safePasswordArr objectAtIndex:i];
            NSString *userName=[storeUserDic objectForKey:@"userName"];
            if ([userName isEqualToString:mobile]) {
                [storeUserDic setValue:self.passWordTextField.text forKey:@"password"];
                break;
            }
            else
            {
                NSMutableDictionary *userDic=[[NSMutableDictionary alloc]init];
                
                [userDic setValue:mobile forKey:@"userName"];
                [userDic setValue:self.passWordTextField.text forKey:@"password"];
                [arr addObject:userDic];

            }
            
        }
        [userDefault setValue:arr forKey:@"safePassword"];
        
        
    }
    else
    {
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];

        NSString *mobile = [dic objectForKey:@"mobile"];
         NSArray *safePasswordArr=[userDefault objectForKey:@"safePassword"];
        
        NSMutableArray *arr=[NSMutableArray arrayWithArray:safePasswordArr];
        
        for (int i=0; i<safePasswordArr.count; i++) {
            NSMutableDictionary *storeUserDic=(NSMutableDictionary *)[safePasswordArr objectAtIndex:i];
            NSString *userName=[storeUserDic objectForKey:@"userName"];
            if ([userName isEqualToString:mobile]) {
                [arr removeObject:storeUserDic];
                break;
            }
            
        }
        [userDefault setValue:arr forKey:@"safePassword"];

    }
    
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
