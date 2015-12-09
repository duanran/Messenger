//
//  ConsumeViewController.m
//  Messenger
//
//  Created by duanran on 15/12/7.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "ConsumeViewController.h"
#import "ConsumeRequest.h"
#import "ConsumeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
//#import "MJRefresh.h"

#import "LCLRefresh.h"
#define  DefaultPage 1


#define DefaultPageCount 10

@interface ConsumeViewController ()
{
    NSInteger currentPage;
}
@property(nonatomic,strong)NSString *selectTime;
@property(nonatomic,strong)NSMutableArray *itemArr;
@property(nonatomic,strong)NSString *selectInquiryTime;

@end

@implementation ConsumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage=DefaultPage;
    self.itemArr=[[NSMutableArray alloc]init];
    NSString *nowTime=[self getNowDate];
    
    NSArray *timeArr=[nowTime componentsSeparatedByString:@"-"];
    
    NSString *year=[timeArr objectAtIndex:0];
    NSString *month=[timeArr objectAtIndex:1];
//    [self loadData:nil];
    
    self.timeLabel.text=[NSString stringWithFormat:@"%@年%@月份",year,month];
    self.timeLabel.textColor=[UIColor whiteColor];
    
    self.incomeLabel.layer.borderWidth=1.0;
    self.incomeLabel.layer.borderColor=[[UIColor grayColor]CGColor];
    self.expendLabel.layer.borderColor=[[UIColor grayColor]CGColor];
    self.expendLabel.layer.borderWidth=1.0;
    
    self.DateField.backgroundColor=[UIColor clearColor];
    self.DateField.inputView=self.datePicker;
    self.DateField.inputAccessoryView = self.accessoryView;
    self.DateField.borderStyle=UITextBorderStyleNone;
    self.datePicker.datePickerMode=UIDatePickerModeDate;
    NSString *nowtimeStr = [self getNowDate];
    
    [self loadData:nowtimeStr];
    
    
   
   
}

#pragma mark-关闭日期
- (IBAction)doneEditing:(id)sender {
    
    [self.DateField resignFirstResponder];
    currentPage=DefaultPage;
    if (self.selectTime) {
        
        [self loadData:self.selectTime];
    }
    
    
}
- (IBAction)dateChanged:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateFormat:@"YYYY-MM"];
    
    NSString * locationString=[formatter stringFromDate:picker.date];
    
    
    NSArray *timeArr=[locationString componentsSeparatedByString:@"-"];
    
    if (timeArr.count>0) {
        NSString *year=[timeArr objectAtIndex:0];
        NSString *month=[timeArr objectAtIndex:1];
        self.timeLabel.text=[NSString stringWithFormat:@"%@年%@月份",year,month];
        self.selectTime=locationString;
    }
    
}
-(void)loadData:(NSString *)inqueryTime
{
    
    
    if (inqueryTime) {
        NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        ConsumeRequest *request=[[ConsumeRequest alloc]init];
        request.ukey=userObj.ukey;
        request.page=[NSString stringWithFormat:@"%d",DefaultPage];
        
        
        request.time=inqueryTime;
        
        self.selectInquiryTime=inqueryTime;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [request GETRequest:^(id reponseObject) {
            NSArray *listArr=[reponseObject objectForKey:@"list"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.tableView footerEndRefreshing];
            if (listArr.count>=DefaultPageCount) {
                @weakify(self);
                
                [self_weak_.tableView addFooterWithCallback:^{
                    [self_weak_ loadNextPageData];

                }];

            }
            else
            {
                [self.tableView removeFooters];
            }
            if (listArr!=nil) {
                self.itemArr=[NSMutableArray arrayWithArray:listArr];
            }
            
            [self.tableView reloadData];
            
            
            
            self.totalMoney.text=[NSString stringWithFormat:@"金额:%@信用豆",[reponseObject objectForKey:@"coin"]];
            self.expendLabel.text=[NSString stringWithFormat:@"支出:%@",[reponseObject objectForKey:@"out"]];
            self.incomeLabel.text=[NSString stringWithFormat:@"收入:%@",[reponseObject objectForKey:@"in"]];
            
        } failureCallback:^(NSString *errorMessage) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [self.tableView footerEndRefreshing];

            if ([errorMessage isEqualToString:@"未查找到数据"]) {
                [self.itemArr removeAllObjects];
                [self.tableView removeFooters];
                [self.tableView reloadData];
            }
            
        }];

    }
    else
    {
        @weakify(self);
        
        NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
        if (userInfo) {
            
            LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
            
            NSString *listURL = [NSString stringWithFormat:@"%@", MyMoneyListURL(userObj.ukey)];
                listURL = [NSString stringWithFormat:@"%@", MyPayLisyURL(userObj.ukey)];
            
            LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
            [downloader setHttpMehtod:LCLHttpMethodGet];
            [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
                
                NSDictionary *dataSourceDic = [self_weak_.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
                if (dataSourceDic) {
                    
                    self_weak_.itemArr = [[NSMutableArray alloc] initWithArray:[dataSourceDic objectForKey:@"list"]];
                    self.totalMoney.text=[NSString stringWithFormat:@"金额:%@信用豆",[dataSourceDic objectForKey:@"coin"]];
                    self.expendLabel.text=[NSString stringWithFormat:@"支出:%@",[dataSourceDic objectForKey:@"out"]];
                    self.incomeLabel.text=[NSString stringWithFormat:@"收入:%@",[dataSourceDic objectForKey:@"in"]];
                }
                
//                [self_weak_.tableView headerEndRefreshing];
                [self.tableView footerEndRefreshing];

                [self_weak_.tableView reloadData];
            }];
            [downloader startToDownloadWithIntelligence:NO];
        }

    }
}
-(void)loadNextPageData
{
    
        currentPage++;
        NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        ConsumeRequest *request=[[ConsumeRequest alloc]init];
        request.ukey=userObj.ukey;
        request.page=[NSString stringWithFormat:@"%ld",(long)currentPage];
    
        
        request.time=self.selectInquiryTime;
    
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
        [request GETRequest:^(id reponseObject) {
            NSArray *listArr=[reponseObject objectForKey:@"list"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView footerEndRefreshing];

            if (listArr.count>=DefaultPageCount) {
                @weakify(self);
                
                [self_weak_.tableView addFooterWithCallback:^{
                    [self_weak_ loadNextPageData];
                }];
            }
            else
            {
                [self.tableView removeFooters];
            }
            if (listArr!=nil) {
                [self.itemArr addObjectsFromArray:listArr];
            }
            
            [self.tableView reloadData];
            
            self.totalMoney.text=[NSString stringWithFormat:@"金额:%@信用豆",[reponseObject objectForKey:@"coin"]];
            self.expendLabel.text=[NSString stringWithFormat:@"支出:%@",[reponseObject objectForKey:@"out"]];
            self.incomeLabel.text=[NSString stringWithFormat:@"收入:%@",[reponseObject objectForKey:@"in"]];
            
        } failureCallback:^(NSString *errorMessage) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            if ([errorMessage isEqualToString:@"未查找到数据"]) {
                [self.tableView removeFooters];
            }
            [self.tableView footerEndRefreshing];

        }];
    
}
-(NSString *)getNowDate
{
    NSDate *date=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM"];
    NSString *nowtimeStr = [formatter stringFromDate:date];
    return nowtimeStr;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsumeTableViewCell *cell=[[ConsumeTableViewCell alloc]init];
    static NSString *identifier=@"ConsumeTableViewCell";
    cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    NSArray *cellArr=[[NSBundle mainBundle]loadNibNamed:@"ConsumeTableViewCell" owner:self options:nil];
    if (cell==nil) {
        cell=[cellArr objectAtIndex:0];
    }
    

    NSDictionary *dic = [self.itemArr objectAtIndex:indexPath.row];
   
    LCLPayListObject *payObj = [LCLPayListObject allocModelWithDictionary:dic];
    
    [cell.titleLabel setText:payObj.typeName];
    [cell.timeLabel setText:payObj.create_time];
    
    [cell.reasonLabel setText:[NSString stringWithFormat:@"%@信用豆", payObj.coin]];
    
    NSDictionary *forUerDic=[dic objectForKey:@"foruser"];
    
    
    NSString *forUserName=[NSString stringWithFormat:@"%@",[forUerDic objectForKey:@"nickname"]];
    cell.nameLabel.text=forUserName;
    NSString *imageViewUrl=[forUerDic objectForKey:@"headimg"];
    [cell.headImageView setImageWithURL:[NSURL URLWithString:imageViewUrl] placeholderImage:[UIImage imageNamed:@"pic_bg.png"] completed:nil];
    
    
    
//        if ([payObj.type integerValue]==2) {
//            [cell.reasonLabel setText:[NSString stringWithFormat:@"%@信用豆", payObj.coin]];
//        }
//        else
//        {
//             [cell.reasonLabel setText:[NSString stringWithFormat:@"+%@信用豆", payObj.coin]];
//        }
    
 
    
    return cell;
    
}

- (NSString *)getDateTimeStringFromTime:(long long)time{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
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
