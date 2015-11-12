//
//  LCLSelectPicView.h
//  信使
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCLSelectPicViewDelegate <NSObject>

- (void)didTapMoviePath:(NSString *)path;

@end

@interface LCLSelectPicView : UIScrollView

- (void)setupWithImageArray:(NSArray *)array;

- (void)setupWithMovieArray:(NSArray *)array;

@property (weak, nonatomic) id<LCLSelectPicViewDelegate> movieDelegate;

@end


