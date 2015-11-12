//
//  LCLAvatarBrowser.h
//
//
//  Created by 李程龙 QQ：244272324 on 13-11-1.
//  Copyright (c) 2013年 bgy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLAvatarBrowser : NSObject<UIScrollViewDelegate,UIActionSheetDelegate>

+ (id)shareLCLImageController; //初始化lclimagecontroller

/**
 *	@brief	浏览头像
 *
 *	@param 	oldImageView 	头像所在的imageView
 */
-(void)showImage:(UIImageView*)avatarImageView;

@end
