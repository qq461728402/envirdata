//
//  EnvAnalysisReportVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/11.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvAnalysisReportToVC.h"
#import "SliderSwitchView.h"
#import "StatisticsVC.h"
#import "ReportVC.h"
@interface EnvAnalysisReportToVC ()<SUNSlideSwitchViewDelegate>
{
    SliderSwitchView *slideSwitchView12;
    NSMutableArray *tableList_arr;
    NSMutableArray *typeList;
    NSDictionary *typedic;
    int curntnum;
    BOOL isupdata;
}
@end
@implementation EnvAnalysisReportToVC
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    curntnum=0;
    tableList_arr=[[NSMutableArray alloc]init];
    typeList =[[NSMutableArray alloc]init];
    
    StatisticsVC *statistics =[[StatisticsVC alloc]init];
    statistics.title=@"昨日统计";
    [tableList_arr addObject:statistics];
    
    ReportVC *reportVc=[[ReportVC alloc]init];
    reportVc.typeId=@"12";
    reportVc.title=@"污染源监控";
    [tableList_arr addObject:reportVc];
    
    
    ReportVC *reportVc1=[[ReportVC alloc]init];
    reportVc1.typeId=@"11";
    reportVc1.title=@"空气质量研制";
    [tableList_arr addObject:reportVc1];
    
    [self initsunslideview];
    // Do any additional setup after loading the view.
}
-(void)initsunslideview
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [view setBackgroundColor:COLOR_TOP];
    [self.view addSubview:view];
    slideSwitchView12=[[SliderSwitchView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-20-49)];
    slideSwitchView12.viewArray=tableList_arr;
    slideSwitchView12.slideSwitchViewDelegate=self;
    [self.view addSubview:slideSwitchView12];
    slideSwitchView12.tabItemNormalColor = UIColorFromRGB(0x868686);
    slideSwitchView12.tabItemSelectedColor = COLOR_TOP;
    slideSwitchView12.hdColor=COLOR_TOP;
    [slideSwitchView12 buildUI];//创建srcolltop按钮
    //默认加载第一个列表
    if([[tableList_arr objectAtIndex:curntnum] isKindOfClass:[StatisticsVC class]]){//表示昨日统计
        StatisticsVC *onlineList =   [tableList_arr objectAtIndex:curntnum];
        [onlineList getYesterDay];
    }else{
        ReportVC *onlinemap =  [tableList_arr objectAtIndex:curntnum];
        [onlinemap getReportList:NO];
    }
}

- (void)slideSwitchView:(SliderSwitchView *)view didselectTab:(NSUInteger)number
{
    if([[tableList_arr objectAtIndex:number] isKindOfClass:[StatisticsVC class]]){//表示
        StatisticsVC *onlineList =   [tableList_arr objectAtIndex:number];
        [onlineList getYesterDay];
    }else{
        ReportVC *onlinemap =   [tableList_arr objectAtIndex:number];
        [onlinemap getReportList:NO];
    }
    curntnum=(int)number;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
