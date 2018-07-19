//
//  ImgCell.m
//  SZMobileSchool
//
//  Created by 熊佳佳 on 16/9/13.
//  Copyright © 2016年 dctrain. All rights reserved.
//

#import "ImgCell.h"

@implementation ImgCell
@synthesize imageView,cancelBtn;
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setImage:PNGIMAGE(@"删除图标") forState:UIControlStateNormal];
        cancelBtn.frame=CGRectMake(0, 0, 15, 15);
        cancelBtn.centerX=imageView.right-5;
        cancelBtn.centerY=imageView.top+10;
        [self.contentView addSubview:imageView];
        [self addSubview:cancelBtn];
    }
    return self;
}
@end
