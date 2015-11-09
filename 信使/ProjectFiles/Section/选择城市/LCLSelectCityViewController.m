//
//  LCLSelectCityViewController.m
//  信使
//
//  Created by 李程龙 on 15/5/27.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLSelectCityViewController.h"

@interface LCLSelectCityViewController ()

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (strong, nonatomic) NSMutableArray *lclDetailsArray;

@property (nonatomic) NSInteger selectIndex;

@end

@implementation LCLSelectCityViewController

- (void)dealloc{

    self.selectCityDelegate = nil;
    self.lclMenuDataSourceArray = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.selectIndex = 0;
    [self.navigationItem setTitle:@"选择城市"];
    
    [self.menuTableView setBorderWithBorderColor:[UIColor lightGrayColor] borderWidth:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag==100) {
        
        return [self.lclMenuDataSourceArray count];
    }else{
        
        if (self.lclDetailsArray) {
            return self.lclDetailsArray.count;
        }
        
        if (self.lclMenuDataSourceArray && self.lclMenuDataSourceArray.count>0) {
            NSDictionary *dic = [self.lclMenuDataSourceArray objectAtIndex:self.selectIndex];
            NSArray *array = [dic objectForKey:@"list"];
            if (array) {
                return [array count];
            }
        }
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    if (tableView.tag==200) {
        //city
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *cityDic = [self.lclMenuDataSourceArray objectAtIndex:self.selectIndex];
        NSArray *array = [cityDic objectForKey:@"list"];
        cityDic = [array objectAtIndex:indexPath.row];
        
        if (self.lclDetailsArray) {
            cityDic = [self.lclDetailsArray objectAtIndex:indexPath.row];
        }
        
        [cell.textLabel setText:[cityDic objectForKey:@"areaname"]];
        
        return cell;
        
    }else {
        //province
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *provinceDic = [self.lclMenuDataSourceArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:[provinceDic objectForKey:@"areaname"]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag==100) {
       
        self.selectIndex = indexPath.row;
        
        [self.detailTableView reloadData];
        
//        NSDictionary *cityDic = [self.lclMenuDataSourceArray objectAtIndex:self.selectIndex];
//
//        [self loadCityDataWithCode:[cityDic objectForKey:@"no"]];
        
    }else{
    
        NSDictionary *cityDic = [self.lclMenuDataSourceArray objectAtIndex:self.selectIndex];
        NSArray *array = [cityDic objectForKey:@"list"];
        cityDic = [array objectAtIndex:indexPath.row];
        
        if (self.selectCityDelegate && [self.selectCityDelegate respondsToSelector:@selector(didSelectCity:)]) {
            [self.selectCityDelegate didSelectCity:cityDic];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)loadCityDataWithCode:(NSString *)code{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:code forKey:@"no"];
    
    LCLDownloader *download = [[LCLDownloader alloc] initWithURLString:[NSString stringWithFormat:@"%@no=%@", GetCityURL, code]];
    [download setEncryptType:LCLEncryptTypeNone];
    [download setPostObjDic:dic];
    [download setHttpMehtod:LCLHttpMethodGet];
    [download setDownloadCompleteBlock:^(NSString *errorString, NSMutableData *fileData, NSString *urlString) {
        
        NSDictionary *dataDic = [self.view getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
        if (dataDic) {
            self.lclDetailsArray = [dataDic objectForKey:@"list"];
            
        }
        
        [self.detailTableView reloadData];
    }];
    [download startToDownloadWithIntelligence:NO];
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











