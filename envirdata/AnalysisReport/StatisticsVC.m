//
//  StatisticsVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/19.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "StatisticsVC.h"
#import "YesterDayModel.h"
@interface StatisticsVC ()
@property (nonatomic,strong)YesterDayModel *yesterDayModel;
@property (nonatomic,strong)UIScrollView *mainScr;
@property (nonatomic,strong)UILabel *areaName_lb;
@property (nonatomic,strong)UILabel *time_lb;
@property (nonatomic,strong)UILabel *aqi_vlb;
@property (nonatomic,strong)UILabel *ylts_vlb;
@property (nonatomic,strong)UILabel *primary_polluvlb;
@property (nonatomic,strong)UILabel *unit_totalvlb;
@property (nonatomic,strong)UILabel *unit_nomvlb;
@property (nonatomic,strong)UILabel *unit_illegallb;
@property (nonatomic,strong)UILabel *unit_illegalpiclb;
@property (nonatomic,strong)UILabel *task_numlb;
@property (nonatomic,strong)UILabel *finish_numlb;
@property (nonatomic,strong)UILabel *notfinish_numlb;
@property (nonatomic,strong)UILabel *patrol_numlb;
@end

@implementation StatisticsVC
@synthesize areaid,yesterDayModel,mainScr;
@synthesize areaName_lb,time_lb,aqi_vlb,ylts_vlb,primary_polluvlb,unit_totalvlb,unit_nomvlb,unit_illegallb,unit_illegalpiclb,task_numlb,finish_numlb,notfinish_numlb,patrol_numlb;
- (void)viewDidLoad {
    [super viewDidLoad];
    areaid=[[SingalObj defaultManager].userInfoModel.areaid stringValue];
    mainScr =[[UIScrollView alloc]init];
    mainScr.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:mainScr];
    WEAKSELF
    [mainScr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    areaName_lb =[[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 30)];
    areaName_lb.font=BoldFont(24);
    areaName_lb.textColor=[UIColor colorWithRGB:0x404040];
    areaName_lb.textAlignment=NSTextAlignmentCenter;
    [mainScr addSubview:areaName_lb];
    
    time_lb=[[UILabel alloc]initWithFrame:CGRectMake(0, areaName_lb.bottom, areaName_lb.width, 18)];
    time_lb.font=Font(16);
    time_lb.textColor=[UIColor colorWithRGB:0x404040];
    time_lb.textAlignment=NSTextAlignmentCenter;
    [mainScr addSubview:time_lb];
    
    UILabel *kqzl=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), time_lb.bottom, 200, 30)];
    kqzl.font=Font(16);
    kqzl.text=@"空气质量情况";
    kqzl.textColor=[UIColor colorWithRGB:0x919190];
    [mainScr addSubview:kqzl];

    
    float vw =(SCREEN_WIDTH-SCALE(8))/2.0;
    UILabel *aql_lb=[[UILabel alloc]initWithFrame:CGRectMake(kqzl.left, kqzl.bottom, [ConfigObj font_sizeWithStr:14 str:@"AQI："], 30)];
    aql_lb.font=Font(14);
    aql_lb.text=@"AQI：";
    [mainScr addSubview:aql_lb];
    aqi_vlb =[[UILabel alloc]initWithFrame:CGRectMake(aql_lb.right, aql_lb.top, vw-aql_lb.width, aql_lb.height)];
    aqi_vlb.font=Font(14);
    aqi_vlb.textColor=COLOR_TOP;
    [mainScr addSubview:aqi_vlb];
    
    UILabel *ylts_lb=[[UILabel alloc]initWithFrame:CGRectMake(aqi_vlb.right, aql_lb.top, [ConfigObj font_sizeWithStr:14 str:@"优良天数："], aql_lb.height)];
    ylts_lb.text=@"优良天数：";
    ylts_lb.font=Font(14);
    [mainScr addSubview:ylts_lb];
    ylts_vlb =[[UILabel alloc]initWithFrame:CGRectMake(ylts_lb.right, aql_lb.top, vw-ylts_lb.width, aql_lb.height)];
    ylts_vlb.font=Font(14);
    ylts_vlb.textColor=COLOR_TOP;
    [mainScr addSubview:ylts_vlb];
    
    UILabel *sy_lb=[[UILabel alloc]initWithFrame:CGRectMake(aql_lb.left, aql_lb.bottom, [ConfigObj font_sizeWithStr:14 str:@"首要污染物："], aql_lb.height)];
    sy_lb.text=@"首要污染物：";
    sy_lb.font=Font(14);
    [mainScr addSubview:sy_lb];
    primary_polluvlb =[[UILabel alloc]initWithFrame:CGRectMake(sy_lb.right, sy_lb.top, vw-sy_lb.width, sy_lb.height)];
    primary_polluvlb.font=Font(14);
    primary_polluvlb.textColor=COLOR_TOP;
    [mainScr addSubview:primary_polluvlb];
    
    //站点监测情况
    kqzl=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), sy_lb.bottom, 200, 30)];
    kqzl.font=Font(16);
    kqzl.text=@"站点监测情况";
    kqzl.textColor=[UIColor colorWithRGB:0x919190];
    [mainScr addSubview:kqzl];
    
    aql_lb=[[UILabel alloc]initWithFrame:CGRectMake(kqzl.left, kqzl.bottom, [ConfigObj font_sizeWithStr:14 str:@"监测站点："], 30)];
    aql_lb.font=Font(14);
    aql_lb.text=@"监测站点：";
    [mainScr addSubview:aql_lb];
    unit_totalvlb =[[UILabel alloc]initWithFrame:CGRectMake(aql_lb.right, aql_lb.top, vw-aql_lb.width, aql_lb.height)];
    unit_totalvlb.font=Font(14);
    unit_totalvlb.textColor=COLOR_TOP;
    [mainScr addSubview:unit_totalvlb];
    
    aql_lb=[[UILabel alloc]initWithFrame:CGRectMake(unit_totalvlb.right, aql_lb.top, [ConfigObj font_sizeWithStr:14 str:@"正常站点："], aql_lb.height)];
    aql_lb.font=Font(14);
    aql_lb.text=@"正常站点：";
    [mainScr addSubview:aql_lb];
    
    unit_nomvlb =[[UILabel alloc]initWithFrame:CGRectMake(aql_lb.right, aql_lb.top, vw-aql_lb.width, aql_lb.height)];
    unit_nomvlb.font=Font(14);
    unit_nomvlb.textColor=COLOR_TOP;
    [mainScr addSubview:unit_nomvlb];
    
    
    aql_lb=[[UILabel alloc]initWithFrame:CGRectMake(kqzl.left, aql_lb.bottom, [ConfigObj font_sizeWithStr:14 str:@"违规站点："], aql_lb.height)];
    aql_lb.font=Font(14);
    aql_lb.text=@"违规站点：";
    [mainScr addSubview:aql_lb];
    
    unit_illegallb =[[UILabel alloc]initWithFrame:CGRectMake(aql_lb.right, aql_lb.top, vw-aql_lb.width, aql_lb.height)];
    unit_illegallb.font=Font(14);
    unit_illegallb.textColor=COLOR_TOP;
    [mainScr addSubview:unit_illegallb];
    
    
    aql_lb=[[UILabel alloc]initWithFrame:CGRectMake(unit_illegallb.right, aql_lb.top, [ConfigObj font_sizeWithStr:14 str:@"违规图片："], aql_lb.height)];
    aql_lb.font=Font(14);
    aql_lb.text=@"违规图片：";
    [mainScr addSubview:aql_lb];
    unit_illegalpiclb =[[UILabel alloc]initWithFrame:CGRectMake(aql_lb.right, aql_lb.top, vw-aql_lb.width, aql_lb.height)];
    unit_illegalpiclb.font=Font(14);
    unit_illegalpiclb.textColor=COLOR_TOP;
    [mainScr addSubview:unit_illegalpiclb];
    //网格监管情况
    kqzl=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), aql_lb.bottom, 200, aql_lb.height)];
    kqzl.font=Font(16);
    kqzl.text=@"网格监管情况";
    kqzl.textColor=[UIColor colorWithRGB:0x919190];
    [mainScr addSubview:kqzl];
    
    aql_lb=[[UILabel alloc]initWithFrame:CGRectMake(kqzl.left, kqzl.bottom, [ConfigObj font_sizeWithStr:14 str:@"新增任务："], aql_lb.height)];
    aql_lb.font=Font(14);
    aql_lb.text=@"新增任务：";
    [mainScr addSubview:aql_lb];
    task_numlb =[[UILabel alloc]initWithFrame:CGRectMake(aql_lb.right, aql_lb.top, vw-aql_lb.width, aql_lb.height)];
    task_numlb.font=Font(14);
    task_numlb.textColor=COLOR_TOP;
    [mainScr addSubview:task_numlb];
    
    
    aql_lb=[[UILabel alloc]initWithFrame:CGRectMake(task_numlb.right, aql_lb.top, [ConfigObj font_sizeWithStr:14 str:@"处理任务："], aql_lb.height)];
    aql_lb.font=Font(14);
    aql_lb.text=@"处理任务：";
    [mainScr addSubview:aql_lb];
    finish_numlb =[[UILabel alloc]initWithFrame:CGRectMake(aql_lb.right, aql_lb.top, vw-aql_lb.width, aql_lb.height)];
    finish_numlb.font=Font(14);
    finish_numlb.textColor=COLOR_TOP;
    [mainScr addSubview:finish_numlb];

    aql_lb=[[UILabel alloc]initWithFrame:CGRectMake(kqzl.left, aql_lb.bottom, [ConfigObj font_sizeWithStr:14 str:@"超期任务："], aql_lb.height)];
    aql_lb.font=Font(14);
    aql_lb.text=@"超期任务：";
    [mainScr addSubview:aql_lb];
    
    notfinish_numlb =[[UILabel alloc]initWithFrame:CGRectMake(aql_lb.right, aql_lb.top, vw-aql_lb.width, aql_lb.height)];
    notfinish_numlb.font=Font(14);
    notfinish_numlb.textColor=COLOR_TOP;
    [mainScr addSubview:notfinish_numlb];
    
    aql_lb=[[UILabel alloc]initWithFrame:CGRectMake(notfinish_numlb.right, aql_lb.top, [ConfigObj font_sizeWithStr:14 str:@"巡查总数："], aql_lb.height)];
    aql_lb.font=Font(14);
    aql_lb.text=@"巡查总数：";
    [mainScr addSubview:aql_lb];
    patrol_numlb =[[UILabel alloc]initWithFrame:CGRectMake(aql_lb.right, aql_lb.top, vw-aql_lb.width, aql_lb.height)];
    patrol_numlb.font=Font(14);
    patrol_numlb.textColor=COLOR_TOP;
    [mainScr addSubview:patrol_numlb];
    
    [mainScr setContentSize:CGSizeMake(SCREEN_WIDTH, aql_lb.bottom+30)];
    
    
    // Do any additional setup after loading the view.
}
-(void)getYesterDay{
    [self networkPost:API_GETYESTERDAYCOUNT2 parameter:@{@"areaid":[areaid numberValue]} progresHudText:@"加载中..." completionBlock:^(id rep) {
        yesterDayModel =[YesterDayModel mj_objectWithKeyValues:rep];
        areaName_lb.text=yesterDayModel.areaname;
        time_lb.text=yesterDayModel.time;
        aqi_vlb.text=[NSString stringWithFormat:@"%@%@",yesterDayModel.aqi,[ConfigObj getLevelName:[ConfigObj getLevelByAQI:[yesterDayModel.aqi doubleValue]]]];
        ylts_vlb.text=[[yesterDayModel.level12 stringValue] stringByAppendingString:@"天"];
        primary_polluvlb.text=yesterDayModel.primary_pollu;
        unit_totalvlb.text=[[yesterDayModel.unit_total stringValue] stringByAppendingString:@"个"];
        unit_nomvlb.text=[[yesterDayModel.unit_normal stringValue] stringByAppendingString:@"个"];
        unit_illegallb.text=[[yesterDayModel.unit_illegal stringValue] stringByAppendingString:@"个"];
        unit_illegalpiclb.text=[[yesterDayModel.unit_illegalpic stringValue] stringByAppendingString:@"张"];
        task_numlb.text=[[yesterDayModel.task_num stringValue] stringByAppendingString:@"个"];
        finish_numlb.text=[[yesterDayModel.finish_num stringValue] stringByAppendingString:@"个"];
        notfinish_numlb.text=[[yesterDayModel.notfinish_num stringValue] stringByAppendingString:@"个"];
        patrol_numlb.text=[[yesterDayModel.patrol_num stringValue] stringByAppendingString:@"个"];
    }];
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
