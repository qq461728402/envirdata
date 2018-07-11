//
//  UIButton+Bootstrap.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/11.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "UIButton+Bootstrap.h"

@implementation UIButton (Bootstrap)
-(void)bootstrapStyle{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    //点击背景颜色
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:self.frame.size] forState:UIControlStateHighlighted];
}
-(void)defaultStyle{
    [self bootstrapStyle];
    //设置字体颜色
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor whiteColor];
    //边框颜色
    self.layer.borderColor = [[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1] CGColor];
    //点击背景颜色
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xf5f5f5] size:self.frame.size] forState:UIControlStateSelected];
}

-(void)bootstrapNoborderStyle:(UIColor*)NomColor titleColor:(UIColor*)color andbtnFont:(UIFont*)font
{
    [self bootstrapStyle];
    //设置字体颜色
    self.titleLabel.font=font;
    self.layer.borderWidth = 0;
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:NomColor size:self.frame.size] forState:UIControlStateNormal];
}
@end
