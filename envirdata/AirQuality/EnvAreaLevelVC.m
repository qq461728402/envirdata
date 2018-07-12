//
//  EnvAreaLevelVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/12.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvAreaLevelVC.h"
#import "SliderSwitchView.h"
#import "EnvAreaLevelListVC.h"
@interface EnvAreaLevelVC ()<SUNSlideSwitchViewDelegate>
{
    SliderSwitchView *slideSwitchView;
    NSMutableArray *tableList_arr;
    NSMutableArray *typeList;
    NSDictionary *typedic;
    int curntnum;
    BOOL isupdata;
}
@end

@implementation EnvAreaLevelVC
@synthesize areaid;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableList_arr=[[NSMutableArray alloc]init];
    typeList =[[NSMutableArray alloc]init];
    
    EnvAreaLevelListVC *envArealevel=[[EnvAreaLevelListVC alloc]init];
    envArealevel.areaid=areaid;
    envArealevel.title=@"区域实时监控";
    envArealevel.api=API_GETAREALEVELAIRQUALITY;
    envArealevel.callback=^(UIViewController *pushview)
    {
        [self.navigationController pushViewController:pushview animated:YES];
    };
    [tableList_arr addObject:envArealevel];
    EnvAreaLevelListVC *envArealevel1=[[EnvAreaLevelListVC alloc]init];
    envArealevel1.areaid=areaid;
    envArealevel1.title=@"站点实时监控";
    envArealevel1.api=API_GETAREALEVELAIRQUALITY;
    envArealevel1.callback=^(UIViewController *pushview)
    {
       [self.navigationController pushViewController:pushview animated:YES];
    };
    [tableList_arr addObject:envArealevel1];
    [self initsunslideview];
    // Do any additional setup after loading the view.
}
#pragma mark----------------------------启动滑竿----------------------
-(void)initsunslideview
{
    slideSwitchView=[[SliderSwitchView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    slideSwitchView.isScroll=YES;
    slideSwitchView.viewArray=tableList_arr;
    slideSwitchView.slideSwitchViewDelegate=self;
    [self.view addSubview:slideSwitchView];
    slideSwitchView.tabItemNormalColor = UIColorFromRGB(0x868686);
    slideSwitchView.tabItemSelectedColor = COLOR_TOP;
    slideSwitchView.hdColor=COLOR_TOP;
    [slideSwitchView buildUI];//创建srcolltop按钮
}
- (void)slideSwitchView:(SliderSwitchView *)view didselectTab:(NSUInteger)number
{
    EnvAreaLevelListVC *vc = [tableList_arr objectAtIndex:number];
    [vc getdataInfo];
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
