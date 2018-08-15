//
//  ReportVC.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/19.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMJDropdownMenu.h"
#import "QRadioButton.h"
@interface ReportVC : UIViewController
@property (nonatomic,strong)NSString *typeId;//分析报告类型 12污染源报告 11空气质量报告 13 网格监管
@property (nonatomic,strong)NSString *roleid;//角色ID
@property (nonatomic,strong)NSString *sonTypeId;//污染源类型
@property (nonatomic,strong)NSString *timeType;//日报 周报 月报
@property (nonatomic,strong)LMJDropdownMenu *dropdownMenu;
@property (nonatomic,strong) QRadioButton *weekQ;
-(void)getReportList:(BOOL)isrefrsh;
@end
