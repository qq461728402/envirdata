//
//  UIButton+Bootstrap.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/11.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Bootstrap)
-(void)defaultStyle;
/**
 *  按钮颜色无边框
 *
 */
-(void)bootstrapNoborderStyle:(UIColor*)NomColor titleColor:(UIColor*)color andbtnFont:(UIFont*)font;
@end
