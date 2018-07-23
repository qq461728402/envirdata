//
//  MangerMentToVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/23.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "MangerMentToVC.h"
#import "SliderSwitchView.h"
#import "GetTasksVC.h"
@interface MangerMentToVC ()<SUNSlideSwitchViewDelegate>
{
    SliderSwitchView *slideSwitchView12;
    NSMutableArray *tableList_arr;
    NSMutableArray *typeList;
    NSDictionary *typedic;
    int curntnum;
}
@end

@implementation MangerMentToVC
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    curntnum=0;
    tableList_arr=[[NSMutableArray alloc]init];
    typeList =[[NSMutableArray alloc]init];
    
    GetTasksVC *statistics =[[GetTasksVC alloc]init];
    statistics.title=@"现场巡查";
    statistics.type=@"1";
    [tableList_arr addObject:statistics];
    GetTasksVC *reportVc=[[GetTasksVC alloc]init];
    reportVc.title=@"监察任务";
    reportVc.type=@"2";
    [tableList_arr addObject:reportVc];
    [self initsunslideview];
    // Do any additional setup after loading the view.
}
-(void)initsunslideview
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [view setBackgroundColor:COLOR_TOP];
    [self.view addSubview:view];
    slideSwitchView12=[[SliderSwitchView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-20-49)];
    slideSwitchView12.isScroll=YES;
    slideSwitchView12.viewArray=tableList_arr;
    slideSwitchView12.slideSwitchViewDelegate=self;
    [self.view addSubview:slideSwitchView12];
    slideSwitchView12.tabItemNormalColor = UIColorFromRGB(0x868686);
    slideSwitchView12.tabItemSelectedColor = COLOR_TOP;
    slideSwitchView12.hdColor=COLOR_TOP;
    [slideSwitchView12 buildUI];//创建srcolltop按钮
    //默认加载第一个列表
    GetTasksVC * getTaskVc = [tableList_arr objectAtIndex:curntnum];
    [getTaskVc gettasks:NO];
}
- (void)slideSwitchView:(SliderSwitchView *)view didselectTab:(NSUInteger)number
{
    GetTasksVC * getTaskVc = [tableList_arr objectAtIndex:number];
    [getTaskVc gettasks:NO];
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
