//
//  LCLMeetTypeView.h
//  信使
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCLMeetTypeViewDelegate <NSObject>

-(void)goBackView;

@end


@interface LCLMeetTypeView : UIView

@property(copy, nonatomic) LCLSelectBolck selectBlock;
@property(nonatomic,weak)id<LCLMeetTypeViewDelegate>delegate;

- (void)getMeetType;

@end











