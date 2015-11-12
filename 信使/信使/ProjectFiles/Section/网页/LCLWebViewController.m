//
//  LCLWebViewController.m
//  Fruit
//
//  Created by lichenglong on 15/6/7.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLWebViewController.h"

@interface LCLWebViewController ()

@end

@implementation LCLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.itemName) {
        [self.navigationItem setTitle:self.itemName];
    }else{
        [self.navigationItem setTitle:@"网页"];
    }
    
    if (self.url) {
        [self loadWebSiteWithURLString:self.url];
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
