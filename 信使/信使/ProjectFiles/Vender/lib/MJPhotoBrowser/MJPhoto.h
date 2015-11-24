//
//  MJPhoto.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <Foundation/Foundation.h>

@interface MJPhoto : NSObject
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image; // 完整的图片

@property (nonatomic, strong) UIImageView *srcImageView; // 来源view
@property (nonatomic, strong, readonly) UIImage *placeholder;
@property (nonatomic, strong, readonly) UIImage *capture;

@property (nonatomic, assign) BOOL firstShow;

// 是否已经保存到相册
@property (nonatomic, assign) BOOL save;
@property (nonatomic, assign) int index; // 索引




@property(nonatomic,strong)NSString *photoStyle;
@property(nonatomic,strong)NSString *videoUrl;
@property(nonatomic,strong)NSString *IsSee;
@property(nonatomic,strong)NSString *videoCoin;
@property(nonatomic,strong)NSString *videoId;
@property(nonatomic,strong)NSString *picId;
@property(nonatomic,strong)NSString *uKey;
@end