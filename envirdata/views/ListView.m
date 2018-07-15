//
//  ListView.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/15.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "ListView.h"

@implementation ListView
-(id)initWithFrame:(CGRect)frame name:(NSString*)name value:(NSString*)value{
    self=[super initWithFrame:frame];
    if (self) {
        self.namelb =[[UILabel alloc]initWithFrame:CGRectMake(SCALE(10), 0, 80, self.height)];
        self.namelb.font=Font(14);
        self.namelb.text=name;
        self.namelb.textColor=[UIColor colorWithRGB:0x2e4057];
        [self addSubview:self.namelb];
        self.valuelb =[[UILabel alloc]initWithFrame:CGRectMake(self.namelb.right, self.namelb.top, self.width-self.namelb.right-SCALE(10), self.height)];
        self.valuelb.font=Font(14);
        self.valuelb.textColor=COLOR_TOP;
        self.valuelb.adjustsFontSizeToFitWidth=YES;
        [self addSubview:self.valuelb];
        UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, self.namelb.bottom-0.5, self.width, 0.5)];
        [onelb setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
        [self addSubview:onelb];
    }
    return self;
}
-(void)setIslink:(BOOL)islink{
    _islink=islink;
    if (islink==YES) {
        if ([self.valuelb.text isNotBlank]) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.valuelb.text];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self addSubview:callWebview];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
