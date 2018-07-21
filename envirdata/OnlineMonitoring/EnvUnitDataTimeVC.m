//
//  EnvUnitDataTimeVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/14.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvUnitDataTimeVC.h"
#import "UnitDataTimeModel.h"
@interface EnvUnitDataTimeVC ()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *aqilb;
@property (nonatomic,strong)UILabel *levelLb;
@property (nonatomic,strong)UILabel *timelb;
@property (nonatomic,strong)UILabel *pm25_lb;
@property (nonatomic,strong)UILabel *pm10_lb;
@property (nonatomic,strong)UILabel *so2_lb;
@property (nonatomic,strong)UILabel *no2_lb;
@property (nonatomic,strong)UILabel *co_lb;
@property (nonatomic,strong)UILabel *o3_lb;
@property (nonatomic,strong)UILabel *windspeed_lb;
@property (nonatomic,strong)UILabel *winddir_lb;
@end

@implementation EnvUnitDataTimeVC
@synthesize uid;
@synthesize bgView,aqilb,levelLb,timelb,pm25_lb,pm10_lb,so2_lb,no2_lb,co_lb,o3_lb,windspeed_lb,winddir_lb;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCALE(180), SCALE(180))];
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = SCALE(90);
    [self.view addSubview:bgView];
    bgView.centerX=SCREEN_WIDTH/2.0;
    UIView *cbview=[[UIView alloc]initWithFrame:CGRectMake(bgView.left, bgView.bottom-SCALE(90), bgView.width, bgView.height/2.0)];
    [cbview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:cbview];
    aqilb =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCALE(90), SCALE(60))];
    aqilb.font=BoldFont(30);
    aqilb.textColor=[UIColor whiteColor];
    aqilb.textAlignment=NSTextAlignmentCenter;
    aqilb.centerX=bgView.width/2.0;
    [bgView addSubview:aqilb];
    levelLb =[[UILabel alloc]initWithFrame:CGRectMake(0, aqilb.bottom, SCALE(90), SCALE(30))];
    levelLb.font=Font(15);
    levelLb.textColor=[UIColor whiteColor];
    levelLb.textAlignment=NSTextAlignmentCenter;
    levelLb.centerX=bgView.width/2.0;
    [bgView addSubview:levelLb];
    timelb =[[UILabel alloc]initWithFrame:CGRectMake(0, bgView.bottom-SCALE(90), SCALE(120), SCALE(30))];
    timelb.font=Font(15);
    timelb.textColor=COLOR_TOP;
    timelb.centerX=SCREEN_WIDTH/2.0;
    [self.view addSubview:timelb];
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, timelb.bottom+10, SCREEN_WIDTH, 2)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xdfeaee]];
    [self.view addSubview:oneline];
    
    UIView *infoslb=[[UIView alloc]initWithFrame:CGRectMake(0, oneline.bottom, oneline.width, 140)];
    float infow = (infoslb.width-30)/2;
    //PM2.5
    UILabel *pm_name=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, infow, SCALE(21))];
    pm_name.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_name.font=Font(15);
    pm_name.text=@"PM2.5";
    [infoslb addSubview:pm_name];
    UILabel *pm_dw =[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.bottom, pm_name.width, pm_name.height)];
    pm_dw.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_dw.font=Font(13);
    pm_dw.text=@"ug/m³";
    [infoslb addSubview:pm_dw];
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_dw.bottom-0.5, pm_name.width, 0.5)];
    [line setBackgroundColor:[UIColor colorWithRGB:0xdfeaee]];
    [infoslb addSubview:line];
    
    pm25_lb=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.top, pm_name.width, pm_name.height*2)];
    pm25_lb.textColor=COLOR_TOP;
    pm25_lb.textAlignment=NSTextAlignmentRight;
    pm25_lb.font=Font(14);
    [infoslb addSubview:pm25_lb];
    
    //PM10
    pm_name=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.right+10, pm_name.top, infow, SCALE(21))];
    pm_name.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_name.font=Font(15);
    pm_name.text=@"PM10";
    [infoslb addSubview:pm_name];
    pm_dw =[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.bottom, pm_name.width, pm_name.height)];
    pm_dw.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_dw.font=Font(13);
    pm_dw.text=@"ug/m³";
    [infoslb addSubview:pm_dw];
     line=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_dw.bottom-0.5, pm_name.width, 0.5)];
    [line setBackgroundColor:[UIColor colorWithRGB:0xdfeaee]];
    [infoslb addSubview:line];
    pm10_lb=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.top, pm_name.width, pm_name.height*2)];
    pm10_lb.textColor=COLOR_TOP;
    pm10_lb.textAlignment=NSTextAlignmentRight;
    pm10_lb.font=Font(14);
    [infoslb addSubview:pm10_lb];
    
    //SO
    pm_name=[[UILabel alloc]initWithFrame:CGRectMake(10, pm_dw.bottom+1, infow, SCALE(21))];
    pm_name.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_name.font=Font(15);
    pm_name.text=@"SO₂";
    [infoslb addSubview:pm_name];
    pm_dw =[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.bottom, pm_name.width, pm_name.height)];
    pm_dw.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_dw.font=Font(13);
    pm_dw.text=@"ug/m³";
    [infoslb addSubview:pm_dw];
    line=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_dw.bottom-0.5, pm_name.width, 0.5)];
    [line setBackgroundColor:[UIColor colorWithRGB:0xdfeaee]];
    [infoslb addSubview:line];
    so2_lb=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.top, pm_name.width, pm_name.height*2)];
    so2_lb.textColor=COLOR_TOP;
    so2_lb.textAlignment=NSTextAlignmentRight;
    so2_lb.font=Font(14);
    [infoslb addSubview:so2_lb];
    
    //no2
    pm_name=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.right+10, pm_name.top, infow, SCALE(21))];
    pm_name.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_name.font=Font(15);
    pm_name.text=@"NO₂";
    [infoslb addSubview:pm_name];
    pm_dw =[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.bottom, pm_name.width, pm_name.height)];
    pm_dw.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_dw.font=Font(13);
    pm_dw.text=@"ug/m³";
    [infoslb addSubview:pm_dw];
    line=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_dw.bottom-0.5, pm_name.width, 0.5)];
    [line setBackgroundColor:[UIColor colorWithRGB:0xdfeaee]];
    [infoslb addSubview:line];
    no2_lb=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.top, pm_name.width, pm_name.height*2)];
    no2_lb.textColor=COLOR_TOP;
    no2_lb.textAlignment=NSTextAlignmentRight;
    no2_lb.font=Font(14);
    [infoslb addSubview:no2_lb];
    
    //CO
    pm_name=[[UILabel alloc]initWithFrame:CGRectMake(10, pm_dw.bottom, infow, SCALE(21))];
    pm_name.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_name.font=Font(15);
    pm_name.text=@"CO";
    [infoslb addSubview:pm_name];
    pm_dw =[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.bottom, pm_name.width, pm_name.height)];
    pm_dw.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_dw.font=Font(13);
    pm_dw.text=@"ug/m³";
    [infoslb addSubview:pm_dw];
    line=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_dw.bottom-0.5, pm_name.width, 0.5)];
    [line setBackgroundColor:[UIColor colorWithRGB:0xdfeaee]];
    [infoslb addSubview:line];
    co_lb=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.top, pm_name.width, pm_name.height*2)];
    co_lb.textColor=COLOR_TOP;
    co_lb.textAlignment=NSTextAlignmentRight;
    co_lb.font=Font(14);
    [infoslb addSubview:co_lb];
    
    //o3
    pm_name=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.right+10, pm_name.top, infow, SCALE(21))];
    pm_name.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_name.font=Font(15);
    pm_name.text=@"O₃";
    [infoslb addSubview:pm_name];
    pm_dw =[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.bottom, pm_name.width, pm_name.height)];
    pm_dw.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_dw.font=Font(13);
    pm_dw.text=@"ug/m³";
    [infoslb addSubview:pm_dw];
    line=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_dw.bottom-0.5, pm_name.width, 0.5)];
    [line setBackgroundColor:[UIColor colorWithRGB:0xdfeaee]];
    [infoslb addSubview:line];
    o3_lb=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.top, pm_name.width, pm_name.height*2)];
    o3_lb.textColor=COLOR_TOP;
    o3_lb.textAlignment=NSTextAlignmentRight;
    o3_lb.font=Font(14);
    [infoslb addSubview:o3_lb];
    
    //风速
    pm_name=[[UILabel alloc]initWithFrame:CGRectMake(10, pm_dw.bottom, infow, SCALE(21))];
    pm_name.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_name.font=Font(15);
    pm_name.text=@"风速";
    [infoslb addSubview:pm_name];
    pm_dw =[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.bottom, pm_name.width, pm_name.height)];
    pm_dw.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_dw.font=Font(13);
    pm_dw.text=@"m/s";
    [infoslb addSubview:pm_dw];
    line=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_dw.bottom-0.5, pm_name.width, 0.5)];
    [line setBackgroundColor:[UIColor colorWithRGB:0xdfeaee]];
    [infoslb addSubview:line];
    windspeed_lb=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.top, pm_name.width, pm_name.height*2)];
    windspeed_lb.textColor=COLOR_TOP;
    windspeed_lb.textAlignment=NSTextAlignmentRight;
    windspeed_lb.font=Font(14);
    [infoslb addSubview:windspeed_lb];
    //风向
    pm_name=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.right+10, pm_name.top, infow, SCALE(21)*2)];
    pm_name.textColor=[UIColor colorWithRGB:0x2e4057];
    pm_name.font=Font(15);
    pm_name.text=@"风向";
    [infoslb addSubview:pm_name];
    line=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.bottom-0.5, pm_name.width, 0.5)];
    [line setBackgroundColor:[UIColor colorWithRGB:0xdfeaee]];
    [infoslb addSubview:line];
    winddir_lb=[[UILabel alloc]initWithFrame:CGRectMake(pm_name.left, pm_name.top, pm_name.width, pm_name.height)];
    winddir_lb.textColor=COLOR_TOP;
    winddir_lb.textAlignment=NSTextAlignmentRight;
    winddir_lb.font=Font(14);
    [infoslb addSubview:winddir_lb];
    infoslb.height=windspeed_lb.bottom;
    UILabel *onle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 2, infoslb.height)];
    [onle setBackgroundColor:[UIColor colorWithRGB:0xdfeaee]];
    onle.centerX=SCREEN_WIDTH/2.0;
    [infoslb addSubview:onle];
    
    [self.view addSubview:infoslb];
    [self getUnitDataTime];
    // Do any additional setup after loading the view.
}
#pragma mark--------------获取监测站点的实时监测数据-----------
-(void)getUnitDataTime{
    [self networkPost:API_GETUNITDATATIME parameter:@{@"uid":uid} progresHudText:@"加载中..." completionBlock:^(id rep) {
        UnitDataTimeModel *unitDataTimeModel=[UnitDataTimeModel mj_objectWithKeyValues:rep];
        aqilb.text=[NSString stringWithFormat:@"%@",unitDataTimeModel.aqi];
        int level = [ConfigObj getLevelByAQI:[unitDataTimeModel.aqi doubleValue]];
        levelLb.text = [ConfigObj getLevelName:level];
        [bgView setBackgroundColor:[ConfigObj getColorByLevel:level]];
        timelb.text=unitDataTimeModel.time;
        pm25_lb.text=[NSString stringWithFormat:@"%@",unitDataTimeModel.pm25];
        pm10_lb.text=[NSString stringWithFormat:@"%@",unitDataTimeModel.pm10];
        so2_lb.text=[NSString stringWithFormat:@"%@",unitDataTimeModel.so2];
        no2_lb.text=[NSString stringWithFormat:@"%@",unitDataTimeModel.no2];
        co_lb.text=[NSString stringWithFormat:@"%@",unitDataTimeModel.co];
        o3_lb.text=[NSString stringWithFormat:@"%@",unitDataTimeModel.o3];
        windspeed_lb.text=unitDataTimeModel.windspeed;
        winddir_lb.text=unitDataTimeModel.winddir;
    }];
    [self networkPost:API_GETUNITPICSADDRESS parameter:@{@"uid":uid} progresHudText:@"加载中..." completionBlock:^(id rep) {
            
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
