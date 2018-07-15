//
//  HourDataView.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/15.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "HourDataView.h"

@implementation HourDataView
-(id)initWithFrame:(CGRect)frame name:(NSString *)name value:(NSString*)value{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.namelb =[[UILabel alloc]initWithFrame:CGRectMake(SCALE(10), 0, self.width/2, self.height)];
        self.namelb.font=Font(14);
        self.namelb.text=name;
        self.namelb.textColor=[UIColor colorWithRGB:0x2e4057];
        [self addSubview:self.namelb];
        self.valuelb =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width/2, self.height)];
        self.valuelb.font=Font(14);
        self.valuelb.right=self.width-SCALE(10);
        self.valuelb.text=value;
        if ([name isEqualToString:@"异常"]) {
            self.valuelb.textColor=[UIColor redColor];
        }else{
            self.valuelb.textColor=COLOR_TOP;
        }
        self.valuelb.textAlignment=NSTextAlignmentRight;
        self.valuelb.adjustsFontSizeToFitWidth=YES;
        [self addSubview:self.valuelb];
        
        UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, self.namelb.bottom-0.5, self.width, 0.5)];
        [onelb setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
        [self addSubview:onelb];
    }
    return  self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
