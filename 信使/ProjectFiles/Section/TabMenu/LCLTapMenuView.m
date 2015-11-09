//
//  LCLTapMenuView.m
//  JoeRhymeLive
//
//  Created by 李程龙 on 15/4/20.
//  Copyright (c) 2015年 李程龙. All rights reserved.
//

#import "LCLTapMenuView.h"

#define MinButtonWidth 80

@interface LCLTapMenuView ()

@property (strong, nonatomic) UIImageView *menuImageView;
@property (strong, nonatomic) UIButton *selectButton;

@end

@implementation LCLTapMenuView

- (void)dealloc{

    self.menuViewDelegate = nil;
    self.menuArray = nil;
}

- (id)init{

    self = [super init];
    if (self) {
       
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    
    return self;
}

- (void)setup{

    [self setScrollsToTop:NO];
    [self setBackgroundColor:[UIColor colorWithWhite:0.98 alpha:0.9]];
    [self setUserInteractionEnabled:YES];
    [self setScrollEnabled:YES];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
}

- (void)setMenuArray:(NSMutableArray *)menuArray{

    _menuArray = menuArray;
    
    [self addMenuViews];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}


- (void)addMenuViews{
    
    NSInteger count = _menuArray.count;
    
    //添加Menu
    float menuWidth = [UIScreen mainScreen].bounds.size.width/count;
    if (menuWidth<MinButtonWidth) {
        menuWidth = MinButtonWidth;
    }
    
    for (int i=0; i<count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:i];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
        [button setTitle:[_menuArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(menuWidth*i, 0, menuWidth, self.frame.size.height-2)];
        [button addTarget:self action:@selector(tapMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        //中间横线
//        if (i!=count-1) {
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(menuWidth*(i+1), 3, 0.5, button.frame.size.height-5)];
//            [imageView setBackgroundColor:[UIColor lightGrayColor]];
//            [self addSubview:imageView];
//        }
        
        if (i==0) {
            self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.selectButton setTag:i];
            [self.selectButton setTitleColor:[UIColor colorWithRed:240./255.0 green:35./255.0 blue:135./255.0 alpha:1.0] forState:UIControlStateNormal];
            [[self.selectButton titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
            [self.selectButton setTitle:[_menuArray objectAtIndex:i] forState:UIControlStateNormal];
            [self.selectButton setFrame:CGRectMake(menuWidth*i, 0, menuWidth, self.frame.size.height-2)];
            [self addSubview:self.selectButton];
        }
    }
    
    if (count>0) {
    
        self.menuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, menuWidth, 2)];
        [self.menuImageView setBackgroundColor:[UIColor colorWithRed:240./255.0 green:35./255.0 blue:135./255.0 alpha:1.0]];
        [self addSubview:self.menuImageView];
    }
    
    [self setContentSize:CGSizeMake(count*menuWidth, 0)];
}

- (IBAction)tapMenuAction:(id)sender{

    UIButton *button = (UIButton *)sender;
    [self setSelectIndex:button.tag];
    
    if (self.menuViewDelegate && [self.menuViewDelegate respondsToSelector:@selector(didTapMenuViewDelegateWithMenuTag:)]) {
        [self.menuViewDelegate didTapMenuViewDelegateWithMenuTag:button.tag];
    }
}

//设置选中的tab
- (void)setSelectIndex:(NSInteger)index{

    NSInteger count = _menuArray.count;
    NSInteger tag = index;

    if (tag<0 || tag>=count) {
        return;
    }
    
    BOOL flag = false;
    float menuWidth = [UIScreen mainScreen].bounds.size.width/count;
    if (menuWidth<=MinButtonWidth) {
        menuWidth = MinButtonWidth;
        flag = true;
    }
    
    [UIView animateWithDuration:0.3 animations:^(){
        [self.menuImageView setFrame:CGRectMake(menuWidth*tag, self.frame.size.height-2, menuWidth, 2)];
    }];
    
    CGRect viewframe = [self convertRect:self.selectButton.frame toView:[[UIApplication sharedApplication] keyWindow]];
    
    [self.selectButton setTitle:[_menuArray objectAtIndex:tag] forState:UIControlStateNormal];
    [self.selectButton setFrame:CGRectMake(menuWidth*tag, 0, menuWidth, self.frame.size.height-2)];
    [self bringSubviewToFront:self.selectButton];
    
    if (flag) {
        if (tag==0) {
            [self setContentOffset:CGPointMake(menuWidth*tag, 0) animated:YES];
        }else{
            
            if(viewframe.origin.x<=0){
                [self setContentOffset:CGPointMake(menuWidth*(tag-1), 0) animated:YES];
            }else if ((self.contentSize.width-menuWidth*tag)>kDeviceWidth) {
                [self setContentOffset:CGPointMake(menuWidth*(tag-1), 0) animated:YES];
            }else{
                [self setContentOffset:CGPointMake(self.contentSize.width-self.frame.size.width, 0) animated:YES];
            }
        }
    }
}

@end











