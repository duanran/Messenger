//
//  LCLVerifyCodeLabel.m
//  外卖宝
//
//  Created by lichenglong on 15/3/30.
//  Copyright (c) 2015年 lichenglong. All rights reserved.
//

#import "LCLVerifyCodeLabel.h"

@implementation LCLVerifyCodeLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (self.text && ![self.text isEqualToString:@""]) {
        
        float red = arc4random() % 100 / 100.0;
        float green = arc4random() % 100 / 100.0;
        float blue = arc4random() % 100 / 100.0;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        NSString *text = [NSString stringWithFormat:@"%@",self.text];
        CGSize cSize = [@"S" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
        int width = rect.size.width / text.length - cSize.width;
        int height = rect.size.height - cSize.height;
        CGPoint point;
        
        float pX, pY;
        for (int i = 0; i < text.length; i++){
            
            pX = arc4random() % width + rect.size.width / text.length * i;
            pY = arc4random() % height;
            point = CGPointMake(pX, pY);
            unichar c = [text characterAtIndex:i];
            NSString *textC = [NSString stringWithFormat:@"%C", c];
            [textC drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
        }
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0);
        for(int cout = 0; cout < 10; cout++){
            
            red = arc4random() % 100 / 100.0;
            green = arc4random() % 100 / 100.0;
            blue = arc4random() % 100 / 100.0;
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
            CGContextSetStrokeColorWithColor(context, [color CGColor]);
            pX = arc4random() % (int)rect.size.width;
            pY = arc4random() % (int)rect.size.height;
            CGContextMoveToPoint(context, pX, pY);
            pX = arc4random() % (int)rect.size.width;
            pY = arc4random() % (int)rect.size.height;
            CGContextAddLineToPoint(context, pX, pY);
            CGContextStrokePath(context);
        }
    }
}


@end









