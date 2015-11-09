//
//  LCLTapMenuView.h
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/4/20.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCLTapMenuViewDelegate <NSObject>

- (void)didTapMenuViewDelegateWithMenuTag:(NSInteger)index;

@end

@interface LCLTapMenuView : UIScrollView

@property (strong, nonatomic) NSMutableArray *menuArray;

@property (assign, nonatomic) id<LCLTapMenuViewDelegate> menuViewDelegate;

//设置选中的tab
- (void)setSelectIndex:(NSInteger)index;

@end




