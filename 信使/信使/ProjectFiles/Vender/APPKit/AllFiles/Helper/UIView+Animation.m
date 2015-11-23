//
//  UIView+Animation.m
//  碧桂园售楼
//
//  Created by 李程龙 on 14-8-19.
//  Copyright (c) 2014年 李程龙. All rights reserved.
//

#import "UIView+Animation.h"
#import <objc/runtime.h>
#import "LCLAppKit.h"

const char explodeCompletionHandlerKey;

@interface LPParticleLayer : CALayer

@property (nonatomic, assign) UIBezierPath *particlePath;

@end

@implementation LPParticleLayer

@end

@implementation UIView (Animation)

//随机浮点数
float randomFloat(){
    
    return (float)rand()/(float)RAND_MAX;
}


#pragma - 抖动动画
-(void)shakeView{
    
    CGFloat t =2.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    __weak typeof(self) weakself = self;
    
    weakself.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        weakself.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                weakself.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

#pragma - 设置圆角图片
- (void)setRoundedRadius:(CGFloat)radius{

    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

#pragma - 设置阴影
- (void)setShadowLayer:(BOOL)flag{

    if (flag) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(-1.0, 1.0);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 2.0;
    }else{
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0;
        self.layer.shadowRadius = 0;
    }
}

#pragma - 设置阴影
- (void)setShadowLayerWithSize:(CGSize)size radius:(CGFloat)radius alpha:(CGFloat)alpha color:(UIColor *)color{
    
    if (!color) {
        color = [UIColor darkGrayColor];
    }
    
    [[self layer] setShadowOffset:size];
    [[self layer] setShadowRadius:radius];
    [[self layer] setShadowOpacity:alpha];
    [[self layer] setShadowColor:color.CGColor];
}


#pragma mark - 设置边框
- (void)setBorderWithBorderColor:(UIColor *)color borderWidth:(float)borderWidth{

    [self setBackgroundColor:[UIColor whiteColor]];
    [self.layer setBorderWidth:borderWidth];
	[self.layer setBorderColor:color.CGColor];
}


#pragma - 旋转
- (void)rotateRound:(BOOL)flag{
    
    if (flag) {
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 0.5;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = MAXFLOAT;
        
        [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }else{
    
        [self.layer removeAnimationForKey:@"rotationAnimation"];
    }
}
- (void)rotateAnimationWithDuration:(float)duration piFloat:(float)piFloat{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * piFloat ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


#pragma - 碎片
- (void)explodeWithCompletionHandler:(void (^)())completionHandler{

    if(completionHandler != nil){
        objc_setAssociatedObject(self, &explodeCompletionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
    }

    float size = self.frame.size.width/5;
    CGSize imageSize = CGSizeMake(size, size);
    
    CGFloat cols = self.frame.size.width / imageSize.width ;
    CGFloat rows = self.frame.size.height /imageSize.height;
    
    int fullColumns = floorf(cols);
    int fullRows = floorf(rows);
    
    CGFloat remainderWidth = self.frame.size.width  -
    (fullColumns * imageSize.width);
    CGFloat remainderHeight = self.frame.size.height -
    (fullRows * imageSize.height );
    
    if (cols > fullColumns) fullColumns++;
    if (rows > fullRows) fullRows++;
    
    CGRect originalFrame = self.layer.frame;
    CGRect originalBounds = self.layer.bounds;
    
    CGImageRef fullImage = [self imageFromLayer:self.layer].CGImage;
    
    //if its an image, set it to nil
    if ([self isKindOfClass:[UIImageView class]]){
        
        [(UIImageView*)self setImage:nil];
    }
    
    [[self.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (int y = 0; y < fullRows; ++y){
        
        for (int x = 0; x < fullColumns; ++x){
            
            CGSize tileSize = imageSize;
            
            if (x + 1 == fullColumns && remainderWidth > 0){
                // Last column
                tileSize.width = remainderWidth;
            }
            
            if (y + 1 == fullRows && remainderHeight > 0){
                // Last row
                tileSize.height = remainderHeight;
            }
            
            CGRect layerRect = (CGRect){{x*imageSize.width, y*imageSize.height},
                tileSize};
            
            CGImageRef tileImage = CGImageCreateWithImageInRect(fullImage,layerRect);
            
            LPParticleLayer *layer = [LPParticleLayer layer];
            layer.frame = layerRect;
            layer.contents = (__bridge id)(tileImage);
            layer.borderWidth = 0.0f;
            layer.borderColor = [UIColor blackColor].CGColor;
            layer.particlePath = [self pathForLayer:layer parentRect:originalFrame];
            [self.layer addSublayer:layer];
            
            CGImageRelease(tileImage);
        }
    }
    
    [self.layer setFrame:originalFrame];
    [self.layer setBounds:originalBounds];
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    [[self.layer sublayers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        LPParticleLayer *layer = (LPParticleLayer *)obj;
        
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = layer.particlePath.CGPath;
        moveAnim.removedOnCompletion = YES;
        moveAnim.fillMode=kCAFillModeForwards;
        NSArray *timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],nil];
        [moveAnim setTimingFunctions:timingFunctions];
        
        float r = randomFloat();
        
        NSTimeInterval speed = 2.35*r;
        
        CAKeyframeAnimation *transformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        
        CATransform3D startingScale = layer.transform;
        CATransform3D endingScale = CATransform3DConcat(CATransform3DMakeScale(randomFloat(), randomFloat(), randomFloat()), CATransform3DMakeRotation(M_PI*(1+randomFloat()), randomFloat(), randomFloat(), randomFloat()));
        
        NSArray *boundsValues = [NSArray arrayWithObjects:
                                 [NSValue valueWithCATransform3D:startingScale],
                                 
                                 [NSValue valueWithCATransform3D:endingScale], nil];
        [transformAnim setValues:boundsValues];
        
        NSArray *times = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:speed*.25], nil];
        [transformAnim setKeyTimes:times];
        
        timingFunctions = [NSArray arrayWithObjects:
                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                           nil];
        [transformAnim setTimingFunctions:timingFunctions];
        transformAnim.fillMode = kCAFillModeForwards;
        transformAnim.removedOnCompletion = NO;
        
        //alpha
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0f];
        opacityAnim.toValue = [NSNumber numberWithFloat:0.f];
        opacityAnim.removedOnCompletion = NO;
        opacityAnim.fillMode =kCAFillModeForwards;
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim,transformAnim,opacityAnim, nil];
        animGroup.duration = speed;
        animGroup.fillMode =kCAFillModeForwards;
        animGroup.delegate = self;
        [animGroup setValue:layer forKey:@"animationLayer"];
        [layer addAnimation:animGroup forKey:nil];
        
        //take it off screen
        [layer setPosition:CGPointMake(0, -600)];
        
    }];
}

//获取layer渲染的图片
- (UIImage *)imageFromLayer:(CALayer *)layer{
    
    UIGraphicsBeginImageContext([layer frame].size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    
    LPParticleLayer *layer = [theAnimation valueForKey:@"animationLayer"];
    if (layer) {
        [layer removeFromSuperlayer];
        layer = nil;
    }
    
    for (UIView __weak *view in [self subviews]) {
        
        for (UIView __weak *views in [view subviews]) {
            
            [views removeFromSuperview];
            views = nil;
        }

        [view removeFromSuperview];
        view = nil;
    }
    
    void (^theCompletionHandler)() = objc_getAssociatedObject(self, &explodeCompletionHandlerKey);
    
    if(theCompletionHandler == nil)
        return;
    
    theCompletionHandler();
}

-(UIBezierPath *)pathForLayer:(CALayer *)layer parentRect:(CGRect)rect{
    
    UIBezierPath *particlePath = [UIBezierPath bezierPath];
    [particlePath moveToPoint:layer.position];
    
    float r = ((float)rand()/(float)RAND_MAX) + 0.3f;
    float r2 = ((float)rand()/(float)RAND_MAX)+ 0.4f;
    float r3 = r*r2;
    
    int upOrDown = (r <= 0.5) ? 1 : -1;
    
    CGPoint curvePoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    float maxLeftRightShift = 1.f * randomFloat();
    
    CGFloat layerYPosAndHeight = (self.superview.frame.size.height-((layer.position.y+layer.frame.size.height)))*randomFloat();
    CGFloat layerXPosAndHeight = (self.superview.frame.size.width-((layer.position.x+layer.frame.size.width)))*r3;
    
    float endY = self.superview.frame.size.height-self.frame.origin.y;
    
    if (layer.position.x <= rect.size.width*0.5){
        
        endPoint = CGPointMake(-layerXPosAndHeight, endY);
        curvePoint= CGPointMake((((layer.position.x*0.5)*r3)*upOrDown)*maxLeftRightShift,-layerYPosAndHeight);
    }else{
        
        endPoint = CGPointMake(layerXPosAndHeight, endY);
        curvePoint= CGPointMake((((layer.position.x*0.5)*r3)*upOrDown+rect.size.width)*maxLeftRightShift, -layerYPosAndHeight);
    }
    
    [particlePath addQuadCurveToPoint:endPoint
                         controlPoint:curvePoint];
    
    return particlePath;
    
}

#pragma mark- 放大缩小动画
- (void)scaleAnimattionWithDuration:(float)duration from:(float)from to:(float)to{

    __weak typeof(self) weakself = self;

    weakself.transform = CGAffineTransformMakeScale(from, from);
    
    [UIView animateWithDuration:duration animations:^{
        
        weakself.transform = CGAffineTransformMakeScale(to, to);
    
    }completion:^(BOOL finished){
        
    }];
}

#pragma mark- 透明-不透明
- (void)alphaAnimattionWithDuration:(float)duration fromAlpha:(float)fromAlpha toAlpha:(float)toAlpha{

    __weak typeof(self) weakself = self;

    weakself.layer.opacity = fromAlpha;
    
    [UIView animateWithDuration:duration animations:^{
        
        weakself.layer.opacity = toAlpha;
        
    }completion:^(BOOL finished){
        
    }];
}

#pragma mark - morph
- (void)morphAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    
    __weak typeof(self) weakself = self;

    // Start
    weakself.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateKeyframesWithDuration:duration/4 delay:delay options:0 animations:^{
        // End
        weakself.transform = CGAffineTransformMakeScale(1, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
            // End
            weakself.transform = CGAffineTransformMakeScale(1.2, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                // End
                weakself.transform = CGAffineTransformMakeScale(0.9, 0.9);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                    // End
                    weakself.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}

#pragma mark - bounce
- (void)bounceAninationWithDuration:(NSTimeInterval)duration{

    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation setFromValue:[NSNumber numberWithFloat:1.5]];
    [animation setToValue:[NSNumber numberWithFloat:1]];
    [animation setDuration:duration];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
    [self.layer addAnimation:animation forKey:@"bounceAnimation"];
}

#pragma mark - bounceLeft
- (void)bounceLeftAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    
    __weak typeof(self) weakself = self;

    // Start
    weakself.transform = CGAffineTransformMakeTranslation(300, 0);
    [UIView animateKeyframesWithDuration:duration/4 delay:delay options:0 animations:^{
        // End
        weakself.transform = CGAffineTransformMakeTranslation(-10, 0);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
            // End
            weakself.transform = CGAffineTransformMakeTranslation(5, 0);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                // End
                weakself.transform = CGAffineTransformMakeTranslation(-2, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                    // End
                    weakself.transform = CGAffineTransformMakeTranslation(0, 0);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}


#pragma mark - bounceRight
- (void)bounceRightAnimationWithDduration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    
    __weak typeof(self) weakself = self;

    // Start
    weakself.transform = CGAffineTransformMakeTranslation(-300, 0);
    [UIView animateKeyframesWithDuration:duration/4 delay:delay options:0 animations:^{
        // End
        weakself.transform = CGAffineTransformMakeTranslation(10, 0);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
            // End
            weakself.transform = CGAffineTransformMakeTranslation(-5, 0);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                // End
                weakself.transform = CGAffineTransformMakeTranslation(2, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                    // End
                    weakself.transform = CGAffineTransformMakeTranslation(0, 0);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}


#pragma mark - bounceDown
- (void)bounceDownAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    
    __weak typeof(self) weakself = self;

    // Start
    weakself.transform = CGAffineTransformMakeTranslation(0, -300);
    [UIView animateKeyframesWithDuration:duration/4 delay:delay options:0 animations:^{
        // End
        weakself.transform = CGAffineTransformMakeTranslation(0, -10);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
            // End
            weakself.transform = CGAffineTransformMakeTranslation(0, 5);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                // End
                weakself.transform = CGAffineTransformMakeTranslation(0, -2);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                    // End
                    weakself.transform = CGAffineTransformMakeTranslation(0, 0);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}


#pragma mark - bounceUp
- (void)bounceUpAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
   
    __weak typeof(self) weakself = self;

    // Start
    weakself.transform = CGAffineTransformMakeTranslation(0, 300);
    [UIView animateKeyframesWithDuration:duration/4 delay:delay options:0 animations:^{
        // End
        weakself.transform = CGAffineTransformMakeTranslation(0, 10);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
            // End
            weakself.transform = CGAffineTransformMakeTranslation(0, -5);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                // End
                weakself.transform = CGAffineTransformMakeTranslation(0, 2);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:duration/4 delay:0 options:0 animations:^{
                    // End
                    weakself.transform = CGAffineTransformMakeTranslation(0, 0);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}

#pragma mark - fadeInLeft
- (void)fadeInLeftAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    
    __weak typeof(self) weakself = self;

    // Start
    weakself.alpha = 0;
    weakself.transform = CGAffineTransformMakeTranslation(300, 0);
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        // End
        weakself.alpha = 1;
        weakself.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) { }];
}


#pragma mark - fadeInRight
- (void)fadeInRightAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    
    __weak typeof(self) weakself = self;

    // Start
    weakself.alpha = 0;
    weakself.transform = CGAffineTransformMakeTranslation(-300, 0);
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        // End
        weakself.alpha = 1;
        weakself.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) { }];
}


#pragma mark - fadeInDown
- (void)fadeInDownAnimationWithDduration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
   
    __weak typeof(self) weakself = self;

    // Start
    weakself.alpha = 0;
    weakself.transform = CGAffineTransformMakeTranslation(0, -300);
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        // End
        weakself.alpha = 1;
        weakself.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) { }];
}

#pragma mark - fadeInUp
- (void)fadeInUpAnimationWithDduration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
   
    __weak typeof(self) weakself = self;

    // Start
    weakself.alpha = 0;
    weakself.transform = CGAffineTransformMakeTranslation(0, 300);
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        // End
        weakself.alpha = 1;
        weakself.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) { }];
}

#pragma mark - zoomOut
- (void)zoomOutAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    
    __weak typeof(self) weakself = self;

    // Start
    weakself.transform = CGAffineTransformMakeScale(1.5, 1.5);
    weakself.alpha = 0;
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        // End
        weakself.transform = CGAffineTransformMakeScale(1, 1);
        weakself.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

@end








