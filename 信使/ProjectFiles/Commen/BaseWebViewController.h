//
//  LCLBaseWebViewController.h
//  测试ARC
//
//  Created by 李程龙 on 14-12-12.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseWebViewController : BaseViewController

/**
 * 网页显示空件.
 */
@property (nonatomic, strong) UIWebView *webView;


/**
 * 加载网址.
 */
-(void)loadWebSiteWithURLString:(NSString*)link;

/**
 * 加载本地地址.
 */
-(void)loadLocalFileWithFilePath:(NSString*)filePath;

@end















