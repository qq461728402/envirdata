//
//  AddImageCell.m
//  SZMobileSchool
//
//  Created by 熊佳佳 on 16/9/13.
//  Copyright © 2016年 dctrain. All rights reserved.
//

#import "AddImageCell.h"

@implementation AddImageCell
@synthesize addImageView;
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        addImageView = [[UIImageView alloc] init];
        [addImageView setImage:[UIImage imageNamed:@"addImage"]];
        addImageView.clipsToBounds=YES;
        addImageView.contentMode=UIViewContentModeScaleAspectFit;
        addImageView.frame=CGRectMake(0, 0, 50, 50);
        [self.contentView addSubview:addImageView];
    }
    return self;
}
@end
