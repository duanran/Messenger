//
//  RechargeRecordViewController.m
//  Messenger
//
//  Created by duanran on 15/12/4.
//  Copyright © 2015年 李程龙. All rights reserved.
//

#import "RechargeRecordViewController.h"
#import "RechargeRequest.h"
#import "RechargeRecordTableViewCell.h"

#define  DefaultPage 1

@interface RechargeRecordViewController ()
@property(nonatomic,strong)NSMutableArray *itemArr;
@property(nonatomic,strong)NSString *selectTime;
@end

@implementation RechargeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *nowTime=[self getNowDate];
    
    NSArray *timeArr=[nowTime componentsSeparatedByString:@"-"];
    
    NSString *year=[timeArr objectAtIndex:0];
    NSString *month=[timeArr objectAtIndex:1];
    
    self.timeLabel.text=[NSString stringWithFormat:@"%@年%@月份",year,month];
    self.timeLabel.textColor=[UIColor whiteColor];
    
    self.creditBeansLabel.layer.borderWidth=1.0;
    self.creditBeansLabel.layer.borderColor=[[UIColor grayColor]CGColor];
    self.moneyLabel.layer.borderColor=[[UIColor grayColor]CGColor];
    self.moneyLabel.layer.borderWidth=1.0;
    
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
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
    RechargeRequest *request=[[RechargeRequest alloc]init];
    request.ukey=userObj.ukey;
    request.page=[NSString stringWithFormat:@"%d",DefaultPage];
    
    
    request.time=inqueryTime;
    
    [request GETRequest:^(id reponseObject) {
        NSArray *listArr=[reponseObject objectForKey:@"list"];
        self.itemArr=[NSMutableArray arrayWithArray:listArr];
        if (listArr>0) {
            [self.tableView reloadData];
        }
    } failureCallback:^(NSString *errorMessage) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
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
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RechargeRecordTableViewCell *cell=[[RechargeRecordTableViewCell alloc]init];
    static NSString *identifier=@"RechargeRecordTableViewCell";
    cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    NSArray *cellArr=[[NSBundle mainBundle]loadNibNamed:@"RechargeRecordTableViewCell" owner:self options:nil];
    if (cell==nil) {
        cell=[cellArr objectAtIndex:0];
    }
    
    NSDictionary *itemDic=[self.itemArr objectAtIndex:indexPath.row];
    
    cell.titleLabel.text=[itemDic objectForKey:@"coin"];
    cell.timeLabel.text=[itemDic objectForKey:@"create_time"];
    cell.moneyLabel.text=[itemDic objectForKey:@"money"];
    return cell;
    
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
