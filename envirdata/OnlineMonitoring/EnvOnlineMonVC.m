//
//  EnvOnlineMonVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/11.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvOnlineMonVC.h"
#import "SliderSwitchView.h"
#import "EnvOnlineMapVC.h"
#import "EnvOnlienListVC.h"
@interface EnvOnlineMonVC ()<SUNSlideSwitchViewDelegate>
{
    SliderSwitchView *slideSwitchView;
    NSMutableArray *tableList_arr;
    NSMutableArray *typeList;
    NSDictionary *typedic;
    int curntnum;
    BOOL isupdata;
}
@end

@implementation EnvOnlineMonVC
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    curntnum=0;
    tableList_arr=[[NSMutableArray alloc]init];
    typeList =[[NSMutableArray alloc]init];
    
    
    EnvOnlienListVC *envArealevel=[[EnvOnlienListVC alloc]init];
    envArealevel.title=@"监测列表";
    envArealevel.callback=^(UIViewController *pushview)
    {
        [self.navigationController pushViewController:pushview animated:YES];
    };
    [tableList_arr addObject:envArealevel];
    EnvOnlineMapVC *envArealevel1=[[EnvOnlineMapVC alloc]init];
    envArealevel1.title=@"监测地图";
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
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [view setBackgroundColor:COLOR_TOP];
    [self.view addSubview:view];
    slideSwitchView=[[SliderSwitchView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-20-49)];
    slideSwitchView.isScroll=YES;
    slideSwitchView.isNoMainScroll=YES;
    slideSwitchView.viewArray=tableList_arr;
    slideSwitchView.slideSwitchViewDelegate=self;
    [self.view addSubview:slideSwitchView];
    slideSwitchView.tabItemNormalColor = UIColorFromRGB(0x868686);
    slideSwitchView.tabItemSelectedColor = COLOR_TOP;
    slideSwitchView.hdColor=COLOR_TOP;
    [slideSwitchView buildUI];//创建srcolltop按钮
    //默认加载第一个列表
    if([[tableList_arr objectAtIndex:curntnum] isKindOfClass:[EnvOnlienListVC class]]){//表示列表
         EnvOnlienListVC *onlineList =   [tableList_arr objectAtIndex:curntnum];
        [onlineList getdataInfo:NO];
    }else{
        EnvOnlineMapVC *onlinemap =   [tableList_arr objectAtIndex:curntnum];
        [onlinemap getdataInfo];
    }
}
- (void)slideSwitchView:(SliderSwitchView *)view didselectTab:(NSUInteger)number
{
    if([[tableList_arr objectAtIndex:number] isKindOfClass:[EnvOnlienListVC class]]){//表示列表
        EnvOnlienListVC *onlineList =   [tableList_arr objectAtIndex:number];
        [onlineList getdataInfo:NO];
    }else{
        EnvOnlineMapVC *onlinemap =   [tableList_arr objectAtIndex:number];
        [onlinemap getdataInfo];
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
