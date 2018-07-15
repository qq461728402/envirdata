//
//  ListView.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/15.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListView : UIView
@property (nonatomic,strong)UILabel *namelb;//名称
@property (nonatomic,strong)UILabel *valuelb;//值
@property (nonatomic,assign)BOOL islink;
-(id)initWithFrame:(CGRect)frame name:(NSString*)name value:(NSString*)value;
@end
