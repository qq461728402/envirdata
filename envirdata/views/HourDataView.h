//
//  HourDataView.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/15.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourDataView : UIView
@property (nonatomic,strong)UILabel *namelb;
@property (nonatomic,strong)UILabel *valuelb;
-(id)initWithFrame:(CGRect)frame name:(NSString *)name value:(NSString*)value;
@end
