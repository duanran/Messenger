//
//  LCLMeetTypeView.m
//  信使
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLMeetTypeView.h"

@interface LCLMeetTypeView ()

@end

@implementation LCLMeetTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc{

    self.selectBlock = nil;
}

- (void)awakeFromNib{


}

- (void)setImageViewFrameWithImageView:(UIButton *)imageView x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width{

    CGRect frame = CGRectMake(x, y, width, width);
    [imageView setFrame:frame];
}

- (void)setLabelFrameWithLabel:(UILabel *)label x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width{
    
    CGRect frame = CGRectMake(x, y, width, 20);
    [label setFrame:frame];
}


- (IBAction)tapCloseButton:(id)sender{

    [LCLAlertController dismissAlertView:self];
    
}

- (void)getMeetType{

    @weakify(self);
    
    NSDictionary *userInfo = [LCLGetToken checkHaveLoginWithShowLoginView:NO];
    if (userInfo) {
        
        LCLUserInfoObject *userObj = [LCLUserInfoObject allocModelWithDictionary:userInfo];
        
        NSString *listURL = [NSString stringWithFormat:@"%@", GetCreateMeetTypeURL(userObj.ukey)];
        
        LCLDownloader *downloader = [[LCLDownloader alloc] initWithURLString:listURL];
        [downloader setHttpMehtod:LCLHttpMethodGet];
        [downloader setDownloadCompleteBlock:^(NSString *err, NSMutableData *fileData, NSString *url){
            
            NSDictionary *dataSourceDic = [self_weak_ getResponseDataDictFromResponseData:fileData withSuccessString:nil error:@""];
            NSArray *array = [dataSourceDic objectForKey:@"list"];
        
            [self_weak_ createTypeButtonWithArray:array];
            
        }];
        [downloader startToDownloadWithIntelligence:NO];
    }
}

- (void)createTypeButtonWithArray:(NSArray *)array{

    NSInteger r = array.count/4;
    CGFloat width = kDeviceWidth/4.0;
    CGFloat y = (kDeviceHeight-(width+20+30)*r)/2.0;
    
    for (int i=0; i<array.count; i++) {
        
        int row = i/4;
        int column = i%4;
        
        NSDictionary *dic = [array objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setRestorationIdentifier:[dic objectForKey:@"title"]];
        [button setTag:[[dic objectForKey:@"id"] integerValue]];
        [button setImageWithURL:[dic objectForKey:@"pic"] defaultImagePath:DefaultImagePath];
        [button setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        [button addTarget:self action:@selector(tapSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [self setImageViewFrameWithImageView:button x:width*column y:y+(width+20+30)*row width:width];
        
        UILabel *label = [[UILabel alloc] init];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:[dic objectForKey:@"title"]];
        [self addSubview:label];
        
        [self setLabelFrameWithLabel:label x:width*column y:button.frame.size.height+button.frame.origin.y width:width];
    }
}

- (IBAction)tapSelectButton:(UIButton *)sender{

    if (self.selectBlock) {
        self.selectBlock(sender);
    }
}

@end




