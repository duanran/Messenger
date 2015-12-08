//
//  CreditExtractionViewController.m
//  Messenger
//
//  Created by duanran on 15/12/7.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "CreditExtractionViewController.h"
#import "CreditExtractionTableViewCell.h"
#import "MBProgressHUD.h"
#import "WithdrawCash.h"
#import "CreditApplication.h"
#import "RequestURL.h"

@interface CreditExtractionViewController ()<UIAlertViewDelegate,NSURLConnectionDelegate>
{
    NSMutableData *    receivedData ;

}
@property(nonatomic,strong)NSMutableArray *itemArr;
@end

@implementation CreditExtractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)loadData
{
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WithdrawCash *cash=[[WithdrawCash alloc]init];
    cash.ukey=userObj.ukey;
    [cash GETRequest:^(id reponseObject) {
      
        NSArray *listArr=[reponseObject objectForKey:@"list"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.itemArr=[NSMutableArray arrayWithArray:listArr];
        [self.tableView reloadData];
    } failureCallback:^(NSString *errorMessage) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"CreditExtractionTableViewCell";
    CreditExtractionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
     NSArray *cellArr=[[NSBundle mainBundle]loadNibNamed:@"CreditExtractionTableViewCell" owner:self options:nil];
    if (cell==nil) {
        cell=[cellArr objectAtIndex:0];
    }
    
    NSDictionary *itemDic=[self.itemArr objectAtIndex:indexPath.row];
    cell.titleLabel.text=[itemDic objectForKey:@"money"];
    cell.createTimeLabel.text=[itemDic objectForKey:@"create_time"];
    cell.aliPayAnccount.text=[itemDic objectForKey:@"account"];
    
    NSString *status=[itemDic objectForKey:@"status"];
    
    if ([status isEqualToString:@"1"]) {
        cell.statusLabel.text=@"申请中";
    }
    else if([status isEqualToString:@"2"])
    {
        cell.statusLabel.text=@"已转账";
    }
    
    return cell;
}

-(IBAction)submit:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"信用提取申请" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    UITextField *moneyField = [alert textFieldAtIndex:0];
    moneyField.placeholder = @"请输入提取金额";
    moneyField.keyboardType=UIKeyboardTypeNumberPad;
    
    
    UITextField *payAnccountField = [alert textFieldAtIndex:1];
    [payAnccountField setSecureTextEntry:NO];
    payAnccountField.placeholder = @"请输入支付宝账号";

    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        UITextField *moneyField = [alertView textFieldAtIndex:0];
        UITextField *payAnccountField = [alertView textFieldAtIndex:1];
        
//        int money=[moneyField.text intValue];
        
        if ([payAnccountField.text length]==0||[moneyField.text length]==0) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"提取金额或支付宝账号不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else
        {
//            CreditApplication *request=[[CreditApplication alloc]init];
            


            
            
            
            
            NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
            LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
            
            
            NSString *url=[NSString stringWithFormat:@"%@/ukey/%@",[RequestURL urlWithTpye:URLTypeCreditApplication],userObj.ukey];
               url= [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
                 request.timeoutInterval=10.0;//设置请求超时为10秒
                 request.HTTPMethod=@"POST";//设置请求方法
            

            NSString *body=[NSString stringWithFormat:@"coin=%@&account=%@",moneyField.text,payAnccountField.text];
            receivedData = [[NSMutableData alloc]init];

                 //把拼接后的字符串转换为data，设置请求体
                 request.HTTPBody=[body dataUsingEncoding:NSUTF8StringEncoding];
            
             NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request     delegate:self];
            
            [connection start];
//            [request POSTRequest:^(id reponseObject) {
//                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//                [self.view addSubview:hud];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"提交成功";
//                [hud showAnimated:YES whileExecutingBlock:^{
//                    sleep(2);
//                } completionBlock:^{
//                    [hud removeFromSuperview];
//                    [self.navigationController popViewControllerAnimated:YES];
//                    
//                }];
//
//            } failureCallback:^(NSString *errorMessage) {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }];
//
        }
        

    }
}
// 接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"get some data");
    [receivedData appendData:data];
}

// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   
    id json = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil];


    if ([[json objectForKey:@"success"] boolValue]==true) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"提交成功";
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [hud removeFromSuperview];
            [self loadData];
        }];
    }
    else
    {
        NSString *errorMessage=[json objectForKey:@"message"];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }

}

// 返回错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];

    NSLog(@"Connection failed: %@", error);
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
