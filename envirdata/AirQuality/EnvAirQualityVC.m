//
//  EnvAirQualityVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/11.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvAirQualityVC.h"
#import "NearestGkzRealModel.h"
#import "NearestAreaRealModel.h"
#import "ForecastAreaModel.h"
#import "EnvAreaLevelVC.h"
@interface EnvAirQualityVC ()
@property (nonatomic,strong)NearestGkzRealModel *nearestGkz;
@property (nonatomic,strong)NearestAreaRealModel *areaRealModel;
@property (nonatomic,strong)UIScrollView *mainScr;
@property (nonatomic,strong)UILabel *areaLb;//区域名称
@property (nonatomic,strong)UILabel *primary_pollu;//首要污染物
@property (nonatomic,strong)UILabel *time;//更新时间
@property (nonatomic,strong)UILabel *aqi;//aqi
@property (nonatomic,strong)UILabel *level;//等级
@property (nonatomic,strong)UILabel *pm25v;//pm2.5
@property (nonatomic,strong)UILabel *pm10v;//pm10
@property (nonatomic,strong)UILabel *SO2v;//SO2
@property (nonatomic,strong)UILabel *NO2v;//NO2
@property (nonatomic,strong)UILabel *oneline1;
@property (nonatomic,strong)UILabel *oneline2;
@property (nonatomic,strong)UILabel *oneline3;
@property (nonatomic,strong)UILabel *oneline4;
@property (nonatomic,strong)UILabel *O3v;
@property (nonatomic,strong)UILabel *oneline5;
@property (nonatomic,strong)UILabel *COv;
@property (nonatomic,strong)UILabel *oneline6;
@property (nonatomic,strong)UILabel *a_areanamelb;//行政区域
@property (nonatomic,strong)UILabel *a_aqi;//
@property (nonatomic,strong)UILabel *a_tiem;
@property (nonatomic,strong)UILabel *a_primary_pollu;//主要污染物
@property (nonatomic,strong)UILabel *a_level;
@property (nonatomic,strong)UILabel *a_pm25v;
@property (nonatomic,strong)UILabel *a_pm10v;
@property (nonatomic,strong)UILabel *a_so2v;
@property (nonatomic,strong)UILabel *a_no2v;
@property (nonatomic,strong)UILabel *a_o3v;
@property (nonatomic,strong)UILabel *a_cov;
@property (nonatomic,strong)UILabel *a_oneline1;
@property (nonatomic,strong)UILabel *a_oneline2;
@property (nonatomic,strong)UILabel *a_oneline3;
@property (nonatomic,strong)UILabel *a_oneline4;
@property (nonatomic,strong)UILabel *a_oneline5;
@property (nonatomic,strong)UILabel *a_oneline6;
@property (nonatomic,strong)UIView *f_dataView;



@end

@implementation EnvAirQualityVC
@synthesize mainScr,areaLb,nearestGkz,primary_pollu,time,aqi,level,pm25v,oneline1,oneline2,pm10v,SO2v,oneline3,NO2v,oneline4,O3v,oneline5,COv,oneline6,areaRealModel;
@synthesize a_primary_pollu,a_areanamelb,a_aqi,a_level,a_pm25v,a_pm10v,a_so2v,a_no2v,a_o3v,a_cov,a_oneline1,a_oneline2,a_oneline3,a_oneline4,a_oneline5,a_oneline6,a_tiem;
@synthesize f_dataView;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BaiduAK authDelegate:self];
    [self baiduConfig];
    UIFont *defont=Font(15);
    
    //背景图片
    UIImageView *bgImage=[[UIImageView alloc]initWithImage:PNGIMAGE(@"sy_bg")];
    bgImage.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:bgImage];
    
    WEAKSELF
    mainScr =[[UIScrollView alloc]initWithFrame:self.view.bounds];
    mainScr.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf baiduConfig];
    }];
    [self.view addSubview:mainScr];
    
    //定位区域
    areaLb =[[UILabel alloc]initWithFrame:CGRectMake(0, SCALE(30), SCALE(140), SCALE(40))];
    areaLb.centerX=SCREEN_WIDTH/2.0;
    areaLb.font=[UIFont fontWithName:@"iconfont" size:24];
    areaLb.textColor=[UIColor whiteColor];
    areaLb.backgroundColor=COLOR_TOP;
    areaLb.textAlignment=NSTextAlignmentCenter;
    areaLb.text =@" \U0000e611";
    ViewRadius(areaLb, areaLb.height/2.0);
    [mainScr addSubview:areaLb];
    //污染物
    UIView *primary_view=[[UIView alloc]initWithFrame:CGRectMake(SCALE(10), areaLb.bottom, SCREEN_WIDTH-SCALE(20), 300)];
    [mainScr addSubview:primary_view];
    //背景图片
    UIImageView *wrwImageBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, primary_view.width, primary_view.height)];
    UIImage *bgImge=[UIImage imageNamed:@"对话框"];
    CGFloat top = bgImge.size.height * 0.5;
    CGFloat left = 35;
    CGFloat bottom = bgImge.size.height * 0.5;
    CGFloat right = 35;
    bgImge = [bgImge resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
    [wrwImageBg setImage:bgImge];
    [primary_view addSubview:wrwImageBg];
    
    
    UILabel *primary_pollu1=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(10), SCALE(35), [ConfigObj font_sizeWith:16 strLong:6], 24)];
    primary_pollu1.font=Font(16);
    primary_pollu1.textColor=COLOR_TOP;
    primary_pollu1.text=@"首要污染物：";
    [primary_view addSubview:primary_pollu1];
    
    primary_pollu=[[UILabel alloc]initWithFrame:CGRectMake(primary_pollu1.right, primary_pollu1.top,200, primary_pollu1.height)];
    primary_pollu.font=Font(16);
    primary_pollu.textColor=COLOR_TOP;
    [primary_view addSubview:primary_pollu];
    
    UILabel *sjlb=[[UILabel alloc]initWithFrame:CGRectMake(primary_pollu1.left, primary_pollu1.bottom, [ConfigObj font_sizeWith:14 strLong:5], primary_pollu1.height)];
    sjlb.font=Font(14);
    sjlb.textColor=COLOR_TOP;
    sjlb.text=@"更新时间：";
    [primary_view addSubview:sjlb];
    
    time =[[UILabel alloc]initWithFrame:CGRectMake(sjlb.right, sjlb.top, primary_pollu.width, sjlb.height)];
    time.font=Font(14);
    time.textColor=COLOR_TOP;
    [primary_view addSubview:time];
    
    aqi=[[UILabel alloc]initWithFrame:CGRectMake(0, primary_pollu1.top, 120, 30)];
    aqi.font=Font(30);
    aqi.textColor=COLOR_TOP;
    aqi.text=@"";
    aqi.textAlignment=NSTextAlignmentRight;
    aqi.right=primary_view.width-SCALE(10);
    [primary_view addSubview:aqi];
    
    CGSize aqiw=[@"30" sizeWithAttributes:@{NSFontAttributeName:aqi.font}];
    level =[[UILabel alloc]initWithFrame:CGRectMake(0, aqi.bottom+5, aqiw.width, SCALE(30))];
    level.right=aqi.right;
    level.font=Font(14);
    level.adjustsFontSizeToFitWidth=YES;
    level.textColor=[UIColor whiteColor];
    level.textAlignment=NSTextAlignmentCenter;
    ViewRadius(level, 4);
    [level setBackgroundColor:API_LEVEL1];
    [primary_view addSubview:level];
    
    float pm2with =(primary_view.width-(primary_pollu1.left*4))/3.0;
    float wdheight =18;
    //PM2.5
    UILabel *PM2=[[UILabel alloc]initWithFrame:CGRectMake(primary_pollu1.left, level.bottom+10, pm2with, 20)];
    PM2.text=@"PM2.5";
    PM2.textColor=COLOR_TOP;
    PM2.font=Font(16);
    [primary_view addSubview:PM2];
    UILabel *dw=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, PM2.bottom, PM2.width, wdheight)];
    dw.text=@"ug/m³";
    dw.textColor=COLOR_TOP;
    dw.font=defont;
    [primary_view addSubview:dw];
    pm25v =[[UILabel alloc]initWithFrame:dw.frame];
    pm25v.textColor=COLOR_TOP;
    pm25v.textAlignment=NSTextAlignmentRight;
    pm25v.font=dw.font;
    [primary_view addSubview:pm25v];
    oneline1 =[[UILabel alloc]initWithFrame:CGRectMake(dw.left, dw.bottom, dw.width, 1)];
    [oneline1 setBackgroundColor:API_LEVEL1];
    [primary_view addSubview:oneline1];
    //PM10
    PM2=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, oneline1.bottom+8, PM2.width, PM2.height)];
    PM2.text=@"PM10";
    PM2.textColor=COLOR_TOP;
    PM2.font=Font(16);
    [primary_view addSubview:PM2];
    dw=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, PM2.bottom, PM2.width, wdheight)];
    dw.text=@"ug/m³";
    dw.textColor=COLOR_TOP;
    dw.font=defont;
    [primary_view addSubview:dw];
    pm10v =[[UILabel alloc]initWithFrame:dw.frame];
    pm10v.textColor=COLOR_TOP;
    pm10v.textAlignment=NSTextAlignmentRight;
    pm10v.font=dw.font;
    [primary_view addSubview:pm10v];
    oneline2 =[[UILabel alloc]initWithFrame:CGRectMake(dw.left, dw.bottom, dw.width, 1)];
    [oneline2 setBackgroundColor:API_LEVEL1];
    [primary_view addSubview:oneline2];
    //SO2
    PM2=[[UILabel alloc]initWithFrame:CGRectMake(PM2.right+primary_pollu1.left, level.bottom+10, PM2.width, PM2.height)];
    PM2.text=@"SO₂";
    PM2.textColor=COLOR_TOP;
    PM2.font=Font(16);
    [primary_view addSubview:PM2];
    dw=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, PM2.bottom, PM2.width, wdheight)];
    dw.text=@"ug/m³";
    dw.textColor=COLOR_TOP;
    dw.font=defont;
    [primary_view addSubview:dw];
    SO2v =[[UILabel alloc]initWithFrame:dw.frame];
    SO2v.textColor=COLOR_TOP;
    SO2v.textAlignment=NSTextAlignmentRight;
    SO2v.font=dw.font;
    [primary_view addSubview:SO2v];
    oneline3 =[[UILabel alloc]initWithFrame:CGRectMake(dw.left, dw.bottom, dw.width, 1)];
    [oneline3 setBackgroundColor:API_LEVEL1];
    [primary_view addSubview:oneline3];
    //NO2
    PM2=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, oneline3.bottom+8, PM2.width, PM2.height)];
    PM2.text=@"NO₂";
    PM2.textColor=COLOR_TOP;
    PM2.font=Font(16);
    [primary_view addSubview:PM2];
    dw=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, PM2.bottom, PM2.width, wdheight)];
    dw.text=@"ug/m³";
    dw.textColor=COLOR_TOP;
    dw.font=defont;
    [primary_view addSubview:dw];
    NO2v =[[UILabel alloc]initWithFrame:dw.frame];
    NO2v.textColor=COLOR_TOP;
    NO2v.textAlignment=NSTextAlignmentRight;
    NO2v.font=dw.font;
    [primary_view addSubview:NO2v];
    oneline4 =[[UILabel alloc]initWithFrame:CGRectMake(dw.left, dw.bottom, dw.width, 1)];
    [oneline4 setBackgroundColor:API_LEVEL1];
    [primary_view addSubview:oneline4];
    
    //O3
    PM2=[[UILabel alloc]initWithFrame:CGRectMake(PM2.right+primary_pollu1.left, level.bottom+10, PM2.width, PM2.height)];
    PM2.text=@"O₃";
    PM2.textColor=COLOR_TOP;
    PM2.font=Font(16);
    [primary_view addSubview:PM2];
    dw=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, PM2.bottom, PM2.width, wdheight)];
    dw.text=@"ug/m³";
    dw.textColor=COLOR_TOP;
    dw.font=defont;
    [primary_view addSubview:dw];
    O3v =[[UILabel alloc]initWithFrame:dw.frame];
    O3v.textColor=COLOR_TOP;
    O3v.textAlignment=NSTextAlignmentRight;
    O3v.font=dw.font;
    [primary_view addSubview:O3v];
    oneline5 =[[UILabel alloc]initWithFrame:CGRectMake(dw.left, dw.bottom, dw.width, 1)];
    [oneline5 setBackgroundColor:API_LEVEL1];
    [primary_view addSubview:oneline5];
    
    //CO
    PM2=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, oneline5.bottom+8, PM2.width, PM2.height)];
    PM2.text=@"CO";
    PM2.textColor=COLOR_TOP;
    PM2.font=Font(16);
    [primary_view addSubview:PM2];
    dw=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, PM2.bottom, PM2.width, wdheight)];
    dw.text=@"ug/m³";
    dw.textColor=COLOR_TOP;
    dw.font=defont;
    [primary_view addSubview:dw];
    COv =[[UILabel alloc]initWithFrame:dw.frame];
    COv.textColor=COLOR_TOP;
    COv.textAlignment=NSTextAlignmentRight;
    COv.font=dw.font;
    [primary_view addSubview:COv];
    oneline6 =[[UILabel alloc]initWithFrame:CGRectMake(dw.left, dw.bottom, dw.width, 1)];
    [oneline6 setBackgroundColor:API_LEVEL1];
    [primary_view addSubview:oneline6];
    wrwImageBg.height=primary_view.height=oneline6.bottom+SCALE(12);

    
    //横线
    UILabel *onlines=[[UILabel alloc]initWithFrame:CGRectMake(primary_view.left, primary_view.bottom+10, primary_view.width, 2)];
    [onlines setBackgroundColor:[UIColor whiteColor]];
    [mainScr addSubview:onlines];
    
    
    UIView *a_areview=[[UIView alloc]initWithFrame:CGRectMake(primary_view.left, onlines.bottom+10, primary_view.width, 300)];
    [a_areview setBackgroundColor:[UIColor clearColor]];
    [mainScr addSubview:a_areview];
    
    
    a_areanamelb =[[UILabel alloc]initWithFrame:CGRectMake(SCALE(10), 0, 150, 30)];
    a_areanamelb.textColor=[UIColor whiteColor];
    a_areanamelb.font=[UIFont fontWithName:@"iconfont" size:24];
    a_areanamelb.text=@"\U0000e7b7";
    [a_areview addSubview:a_areanamelb];
    
    UILabel *a_primary =[[UILabel alloc]initWithFrame:CGRectMake(a_areanamelb.left, a_areanamelb.bottom, [ConfigObj font_sizeWith:16 strLong:6], 24)];
    a_primary.textColor=[UIColor whiteColor];
    a_primary.text=@"首页污染物：";
    a_primary.font=Font(16);
    [a_areview addSubview:a_primary];
    
    a_primary_pollu =[[UILabel alloc]initWithFrame:CGRectMake(a_primary.right, a_primary.top, 200, a_primary.height)];
    a_primary_pollu.textColor=a_primary.textColor;
    a_primary_pollu.font=a_primary.font;
    [a_areview addSubview:a_primary_pollu];
    
    
    UILabel *a_sjlb=[[UILabel alloc]initWithFrame:CGRectMake(a_primary.left, a_primary.bottom, [ConfigObj font_sizeWith:14 strLong:5], a_primary.height)];
    a_sjlb.font=Font(14);
    a_sjlb.textColor=a_primary.textColor;
    a_sjlb.text=@"更新时间：";
    [a_areview addSubview:a_sjlb];
    a_tiem =[[UILabel alloc]initWithFrame:CGRectMake(a_sjlb.right, a_sjlb.top, primary_pollu.width, a_sjlb.height)];
    a_tiem.font=Font(14);
    a_tiem.textColor=a_primary.textColor;
    [a_areview addSubview:a_tiem];
    
    
    a_aqi =[[UILabel alloc]initWithFrame:CGRectMake(0, a_primary_pollu.top-25, 200, 30)];
    a_aqi.font=Font(30);
    a_aqi.textColor=a_primary.textColor;
    a_aqi.text=@"";
    a_aqi.textAlignment=NSTextAlignmentRight;
    a_aqi.right=a_areview.width-SCALE(10);
    [a_areview addSubview:a_aqi];
    
    
    a_level =[[UILabel alloc]initWithFrame:CGRectMake(0, a_aqi.bottom+5, aqiw.width, SCALE(30))];
    a_level.right=a_aqi.right;
    ViewRadius(a_level, 4);
    a_level.font=Font(14);
    a_level.adjustsFontSizeToFitWidth=YES;
    a_level.textColor=[UIColor whiteColor];
    a_level.textAlignment=NSTextAlignmentCenter;
    [a_level setBackgroundColor:API_LEVEL1];
    [a_areview addSubview:a_level];
    
    UIView *a_bgview=[[UIView alloc]initWithFrame:CGRectMake(0, a_tiem.bottom+10, a_areview.width, 200)];
    [a_bgview setBackgroundColor:[UIColor colorWithRGB:0x02ddfd alpha:0.2]];
    [a_areview addSubview:a_bgview];
    
    float a_pm2with =(a_bgview.width-(a_areanamelb.left*4))/3.0;
    //PM2
    PM2=[[UILabel alloc]initWithFrame:CGRectMake(a_primary.left, 10, a_pm2with, 20)];
    PM2.text=@"PM2.5";
    PM2.textColor=a_primary.textColor;
    PM2.font=Font(16);
    [a_bgview addSubview:PM2];
    dw=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, PM2.bottom, PM2.width, wdheight)];
    dw.text=@"ug/m³";
    dw.textColor=a_primary.textColor;
    dw.font=defont;
    [a_bgview addSubview:dw];
    a_pm25v =[[UILabel alloc]initWithFrame:dw.frame];
    a_pm25v.textColor=a_primary.textColor;
    a_pm25v.textAlignment=NSTextAlignmentRight;
    a_pm25v.font=dw.font;
    [a_bgview addSubview:a_pm25v];
    a_oneline1 =[[UILabel alloc]initWithFrame:CGRectMake(dw.left, dw.bottom, dw.width, 1)];
    [a_oneline1 setBackgroundColor:API_LEVEL1];
    [a_bgview addSubview:a_oneline1];
    
    //PM10
    PM2=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, a_oneline1.bottom+8, PM2.width, PM2.height)];
    PM2.text=@"PM10";
    PM2.textColor=a_primary.textColor;
    PM2.font=Font(16);
    [a_bgview addSubview:PM2];
    dw=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, PM2.bottom, PM2.width, wdheight)];
    dw.text=@"ug/m³";
    dw.textColor=a_primary.textColor;;
    dw.font=defont;
    [a_bgview addSubview:dw];
    a_pm10v =[[UILabel alloc]initWithFrame:dw.frame];
    a_pm10v.textColor=a_primary.textColor;;
    a_pm10v.textAlignment=NSTextAlignmentRight;
    a_pm10v.font=dw.font;
    [a_bgview addSubview:a_pm10v];
    a_oneline2 =[[UILabel alloc]initWithFrame:CGRectMake(dw.left, dw.bottom, dw.width, 1)];
    [a_oneline2 setBackgroundColor:API_LEVEL1];
    [a_bgview addSubview:a_oneline2];
    
    
    //SO2
    PM2=[[UILabel alloc]initWithFrame:CGRectMake(PM2.right+a_primary.left, 10, PM2.width, PM2.height)];
    PM2.text=@"SO₂";
    PM2.textColor=a_primary.textColor;;
    PM2.font=Font(16);
    [a_bgview addSubview:PM2];
    dw=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, PM2.bottom, PM2.width, wdheight)];
    dw.text=@"ug/m³";
    dw.textColor=a_primary.textColor;;
    dw.font=defont;
    [a_bgview addSubview:dw];
    a_so2v =[[UILabel alloc]initWithFrame:dw.frame];
    a_so2v.textColor=a_primary.textColor;
    a_so2v.textAlignment=NSTextAlignmentRight;
    a_so2v.font=dw.font;
    [a_bgview addSubview:a_so2v];
    a_oneline3 =[[UILabel alloc]initWithFrame:CGRectMake(dw.left, dw.bottom, dw.width, 1)];
    [a_oneline3 setBackgroundColor:API_LEVEL1];
    [a_bgview addSubview:a_oneline3];
    
    //NO2
    PM2=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, a_oneline3.bottom+8, PM2.width, PM2.height)];
    PM2.text=@"NO₂";
    PM2.textColor=a_primary.textColor;;
    PM2.font=Font(16);
    [a_bgview addSubview:PM2];
    dw=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, PM2.bottom, PM2.width, wdheight)];
    dw.text=@"ug/m³";
    dw.textColor=a_primary.textColor;;
    dw.font=defont;
    [a_bgview addSubview:dw];
    a_no2v =[[UILabel alloc]initWithFrame:dw.frame];
    a_no2v.textColor=a_primary.textColor;
    a_no2v.textAlignment=NSTextAlignmentRight;
    a_no2v.font=dw.font;
    [a_bgview addSubview:a_no2v];
    a_oneline4 =[[UILabel alloc]initWithFrame:CGRectMake(dw.left, dw.bottom, dw.width, 1)];
    [a_oneline4 setBackgroundColor:API_LEVEL1];
    [a_bgview addSubview:a_oneline4];
    
    
    //O3
    PM2=[[UILabel alloc]initWithFrame:CGRectMake(PM2.right+a_primary.left, 10, PM2.width, PM2.height)];
    PM2.text=@"O₃";
    PM2.textColor=a_primary.textColor;;
    PM2.font=Font(16);
    [a_bgview addSubview:PM2];
    dw=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, PM2.bottom, PM2.width, wdheight)];
    dw.text=@"ug/m³";
    dw.textColor=a_primary.textColor;;
    dw.font=defont;
    [a_bgview addSubview:dw];
    a_o3v =[[UILabel alloc]initWithFrame:dw.frame];
    a_o3v.textColor=a_primary.textColor;
    a_o3v.textAlignment=NSTextAlignmentRight;
    a_o3v.font=dw.font;
    [a_bgview addSubview:a_o3v];
    a_oneline5 =[[UILabel alloc]initWithFrame:CGRectMake(dw.left, dw.bottom, dw.width, 1)];
    [a_oneline5 setBackgroundColor:API_LEVEL1];
    [a_bgview addSubview:a_oneline5];
    
    //CO
    PM2=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, a_oneline5.bottom+8, PM2.width, PM2.height)];
    PM2.text=@"CO";
    PM2.textColor=a_primary.textColor;
    PM2.font=Font(16);
    [a_bgview addSubview:PM2];
    dw=[[UILabel alloc]initWithFrame:CGRectMake(PM2.left, PM2.bottom, PM2.width, wdheight)];
    dw.text=@"ug/m³";
    dw.textColor=a_primary.textColor;
    dw.font=defont;
    [a_bgview addSubview:dw];
    a_cov =[[UILabel alloc]initWithFrame:dw.frame];
    a_cov.textColor=a_primary.textColor;
    a_cov.textAlignment=NSTextAlignmentRight;
    a_cov.font=dw.font;
    [a_bgview addSubview:a_cov];
    a_oneline6 =[[UILabel alloc]initWithFrame:CGRectMake(dw.left, dw.bottom, dw.width, 1)];
    [a_oneline6 setBackgroundColor:API_LEVEL1];
    [a_bgview addSubview:a_oneline6];
    a_bgview.height=a_oneline6.bottom+10;
    a_areview.height=a_bgview.bottom;
    UIView *f_bgview=[[UIView alloc]initWithFrame:CGRectMake(a_areview.left, a_areview.bottom+SCALE(10), a_areview.width, SCALE(40))];
    
    [f_bgview setBackgroundColor:[UIColor colorWithRGB:0x02ddfd alpha:0.2]];
    [mainScr addSubview:f_bgview];
    UILabel *f_kqlb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 200, f_bgview.height)];
    f_kqlb.font=Font(16);
    f_kqlb.textColor=[UIColor whiteColor];
    f_kqlb.text=@"空气质量预报";
    [f_bgview addSubview:f_kqlb];
    
    f_dataView =[[UIView alloc]initWithFrame:CGRectMake(f_bgview.left, f_bgview.bottom+SCALE(8), f_bgview.width,10)];
    
    [mainScr addSubview:f_dataView];
    
    
    // Do any additional setup after loading the view.
}
#pragma mark----------baidu配置---------
-(void)baiduConfig{
    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeGCJ02;//适应高德地图
    //设置距离过滤参数（M）
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (location) {//得到定位信息，添加annotation
            if (location.location) {
                [SingalObj defaultManager].userLocation=location.location;
                NSLog(@"LOC = %@",location.location);}
            [self getNearestGkzReal:location.location];
                      if (location.rgcData) {
                        NSLog(@"rgc = %@",[location.rgcData description]);
                    }
            }
        //开启连续定位
        [_locationManager startUpdatingLocation];
    }];
}
#pragma mark----------------最近国控站实况接口-------
-(void)getNearestGkzReal:(CLLocation *)location{
    NSLog(@"%@",@(location.coordinate.latitude));
    NSDictionary *paramter = @{@"cur_lon":@(location.coordinate.longitude),@"cur_lat":@(location.coordinate.latitude)};
    [self networkPost:API_GETNEARESTGKZREAL parameter:paramter progresHudText:@"加载中..." completionBlock:^(id rep) {
         nearestGkz = [NearestGkzRealModel mj_objectWithKeyValues:rep];
         primary_pollu.text=nearestGkz.primary_pollu;
         areaLb.text =[NSString stringWithFormat:@"%@ \U0000e611",nearestGkz.uname];
         time.text=[NSString stringWithFormat:@"%@ 时",nearestGkz.time];
         aqi.text=[NSString stringWithFormat:@"%@",nearestGkz.aqi];
    
        int PM25AQI = [ConfigObj getIAQIbyFactor:@"pm25" val:[nearestGkz.pm25 doubleValue]];
        NSLog(@"%i",PM25AQI);
        
        int PM10AQI =[ConfigObj getIAQIbyFactor:@"pm10" val:[nearestGkz.pm10 doubleValue]];
        int SO2_1AQI =[ConfigObj getIAQIbyFactor:@"so2_1" val:[nearestGkz.so2 doubleValue]];
        
        int NO2_1AQI =[ConfigObj getIAQIbyFactor:@"no2_1" val:[nearestGkz.no2 doubleValue]];
        
        int O3_1AQI =[ConfigObj getIAQIbyFactor:@"o3_1" val:[nearestGkz.o3 doubleValue]];
        
         int CO_1AQI =[ConfigObj getIAQIbyFactor:@"co_1" val:[nearestGkz.co doubleValue]];
        
        
       oneline1.backgroundColor = [ConfigObj getColorByLevel:[ConfigObj getLevelByAQI:PM25AQI]];
       oneline2.backgroundColor=[ConfigObj getColorByLevel:[ConfigObj getLevelByAQI:PM10AQI]];
       oneline3.backgroundColor=[ConfigObj getColorByLevel:[ConfigObj getLevelByAQI:SO2_1AQI]];
       oneline4.backgroundColor=[ConfigObj getColorByLevel:[ConfigObj getLevelByAQI:NO2_1AQI]];
        oneline5.backgroundColor=[ConfigObj getColorByLevel:[ConfigObj getLevelByAQI:O3_1AQI]];
        oneline6.backgroundColor=[ConfigObj getColorByLevel:[ConfigObj getLevelByAQI:CO_1AQI]];
        level.backgroundColor=[ConfigObj getColorByLevel:nearestGkz.level];
        level.text=[ConfigObj getLevelName:nearestGkz.level];
        pm25v.text=[NSString stringWithFormat:@"%@",nearestGkz.pm25];
        pm10v.text=[NSString stringWithFormat:@"%@",nearestGkz.pm10];
        SO2v.text=[NSString stringWithFormat:@"%@",nearestGkz.so2];
        NO2v.text=[NSString stringWithFormat:@"%@",nearestGkz.no2];
        O3v.text=[NSString stringWithFormat:@"%@",nearestGkz.o3];
        COv.text=[NSString stringWithFormat:@"%@",nearestGkz.co];
        [self getNearestAreaReal:nearestGkz.uid :location];
        
    }];
}
#pragma mark-------当前行政区域实况接口--------------
-(void)getNearestAreaReal:(NSString*)nodeid :(CLLocation *)location{
    NSDictionary *paramter = @{@"cur_lon":@(location.coordinate.longitude),@"cur_lat":@(location.coordinate.latitude)};
    [self networkPost:API_GETNEARESTAREAREAL parameter:paramter progresHudText:@"加载中..." completionBlock:^(id rep) {
        areaRealModel=[NearestAreaRealModel mj_objectWithKeyValues:rep];
        //实时监控需要区域ID
//        [SingalObj defaultManager].areaid=[NSString stringWithFormat:@"%@",areaRealModel.areaid];
        
        a_areanamelb.text=[NSString stringWithFormat:@"%@ \U0000e7b7",areaRealModel.areaname];
        a_areanamelb.userInteractionEnabled=YES;
        [a_areanamelb bk_whenTapped:^{
            EnvAreaLevelVC *evArealevel=[[EnvAreaLevelVC alloc]init];
            evArealevel.title=@"实时监测";
            evArealevel.areaid =[NSString stringWithFormat:@"%@",areaRealModel.areaid];
            UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
            [nav pushViewController:evArealevel animated:YES];
        }];
        a_primary_pollu.text=areaRealModel.primary_pollu;
        a_tiem.text=[NSString stringWithFormat:@"%@ 时",areaRealModel.time];
        a_aqi.text=[NSString stringWithFormat:@"%@",areaRealModel.aqi];
        
        
        int PM25AQI = [ConfigObj getIAQIbyFactor:@"pm25" val:[areaRealModel.pm25 doubleValue]];
        NSLog(@"%i",PM25AQI);
        
        int PM10AQI =[ConfigObj getIAQIbyFactor:@"pm10" val:[areaRealModel.pm10 doubleValue]];
        int SO2_1AQI =[ConfigObj getIAQIbyFactor:@"so2_1" val:[areaRealModel.so2 doubleValue]];
        
        int NO2_1AQI =[ConfigObj getIAQIbyFactor:@"no2_1" val:[areaRealModel.no2 doubleValue]];
        
        int O3_1AQI =[ConfigObj getIAQIbyFactor:@"o3_1" val:[areaRealModel.o3 doubleValue]];
        
        int CO_1AQI =[ConfigObj getIAQIbyFactor:@"co_1" val:[areaRealModel.co doubleValue]];

        a_oneline1.backgroundColor = [ConfigObj getColorByLevel:[ConfigObj getLevelByAQI:PM25AQI]];
        a_oneline2.backgroundColor=[ConfigObj getColorByLevel:[ConfigObj getLevelByAQI:PM10AQI]];
        a_oneline3.backgroundColor=[ConfigObj getColorByLevel:[ConfigObj getLevelByAQI:SO2_1AQI]];
        a_oneline4.backgroundColor=[ConfigObj getColorByLevel:[ConfigObj getLevelByAQI:NO2_1AQI]];
        a_oneline5.backgroundColor=[ConfigObj getColorByLevel:[ConfigObj getLevelByAQI:O3_1AQI]];
        a_oneline6.backgroundColor=[ConfigObj getColorByLevel:[ConfigObj getLevelByAQI:CO_1AQI]];
        
        a_level.backgroundColor=[ConfigObj getColorByLevel:areaRealModel.level];
        a_level.text=[ConfigObj getLevelName:areaRealModel.level];
        a_pm25v.text=[NSString stringWithFormat:@"%@",areaRealModel.pm25];
        a_pm10v.text=[NSString stringWithFormat:@"%@",areaRealModel.pm10];
        a_so2v.text=[NSString stringWithFormat:@"%@",areaRealModel.so2];
        a_no2v.text=[NSString stringWithFormat:@"%@",areaRealModel.no2];
        a_o3v.text=[NSString stringWithFormat:@"%@",areaRealModel.o3];
        a_cov.text=[NSString stringWithFormat:@"%@",areaRealModel.co];
        [mainScr.mj_header endRefreshing];
        [self getforecastArea:location];
    }];
}
#pragma mark---------空气质量预报--------
-(void)getforecastArea :(CLLocation *)location{
    NSDictionary *paramter = @{@"cur_lon":@(location.coordinate.longitude),@"cur_lat":@(location.coordinate.latitude)};
    [self networkPost:API_GETFORECASTAREA parameter:paramter progresHudText:@"加载中..." completionBlock:^(id rep) {
        NSArray *foreArray =[ForecastAreaModel mj_objectArrayWithKeyValuesArray:rep];
       
        int length=foreArray.count<3?(int)foreArray.count:3;
        float w =f_dataView.width/3.0;
        CGSize aqiw=[@"30" sizeWithAttributes:@{NSFontAttributeName:aqi.font}];
        float f_hight=20;
        for (int i=0; i<length; i++) {
            f_hight=0;
            ForecastAreaModel *foreModel = [foreArray objectAtIndex:i];
            UILabel *namelb=[[UILabel alloc]initWithFrame:CGRectMake(i*w, SCALE(5), w, 21)];
            namelb.textColor=COLOR_TOP;
            namelb.font=Font(14);
            namelb.textAlignment=NSTextAlignmentCenter;
            namelb.text=[ConfigObj getWeekDay:foreModel.time];
            [f_dataView addSubview:namelb];
            
            UILabel *wdlb=[[UILabel alloc]initWithFrame:CGRectMake(namelb.left, namelb.bottom, namelb.width, namelb.height)];
            wdlb.textColor=COLOR_TOP;
            wdlb.font=Font(14);
            wdlb.textAlignment=NSTextAlignmentCenter;
            wdlb.text=foreModel.aqirank;
            [f_dataView addSubview:wdlb];
            UILabel *f_levellb =[[UILabel alloc]initWithFrame:CGRectMake(0, wdlb.bottom, aqiw.width, SCALE(30))];
            f_levellb.font=Font(14);
            f_levellb.adjustsFontSizeToFitWidth=YES;
            f_levellb.textColor=[UIColor whiteColor];
            f_levellb.textAlignment=NSTextAlignmentCenter;
            ViewRadius(f_levellb, 4);
            f_levellb.centerX=wdlb.centerX;
            f_levellb.backgroundColor=[ConfigObj getColorByLevel:foreModel.level];
            f_levellb.text=[ConfigObj getLevelName:foreModel.level];
            [f_dataView addSubview:f_levellb];
            UILabel *f_primary_pollu=[[UILabel alloc]initWithFrame:CGRectMake(namelb.left, f_levellb.bottom, namelb.width, namelb.height)];
            f_primary_pollu.textColor=COLOR_TOP;
            f_primary_pollu.font=Font(14);
            f_primary_pollu.textAlignment=NSTextAlignmentCenter;
            f_primary_pollu.text=foreModel.primarypollu;
            [f_dataView addSubview:f_primary_pollu];
            f_hight=f_primary_pollu.bottom+10;
        }
        f_dataView.height=f_hight;
        [mainScr setContentSize:CGSizeMake(mainScr.width, f_dataView.bottom+20+49)];
    }];
}
#pragma mark---------------开启连续定位上传运动轨迹-----------
-(void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error{
    if (error)
    {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    } if (location) {//得到定位信息，添加annotation
        if (location.location) {
            NSLog(@"LOC = %@",location.location);
        }
        if (location.rgcData) {
            NSLog(@"rgc = %@",[location.rgcData description]);
        }
        //当前时间
        NSString *curruntDate= [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        //地址
        BMKLocationReGeocode *regoecode  =  location.rgcData;
        NSString *address=[NSString stringWithFormat:@"%@%@%@%@",regoecode.city,regoecode.district,regoecode.street,regoecode.streetNumber];
        //经纬度
        NSNumber *lng =[NSNumber numberWithDouble:location.location.coordinate.longitude];
        NSNumber *lat =[NSNumber numberWithDouble:location.location.coordinate.latitude];
        NSDictionary *pointDic =@{@"time":curruntDate,@"address":address,@"lng":lng,@"lat":lat};
        [self addPoints:@[pointDic]];
    }
}
#pragma mark--------------上传运动轨迹-----------------
-(void)addPoints:(NSArray *)points{
    NSNumber *userid=[SingalObj defaultManager].userInfoModel.userid;
    NSString *trackid =[SingalObj defaultManager].trackid;
    if (![trackid isNotBlank]) {
        [self getTrackId];
        return;
    }
    NSString *mac =[NSString stringWithUUID];
    NSString *gps =[points mj_JSONObject];
    [self networkPostAll:API_APPPIONT parameter:@{@"userid":userid,@"trackid":trackid,@"mac":mac,@"gps":gps} progresHudText:nil completionBlock:^(id rep) {
        if ([rep[@"code"] intValue]==-2) {//表示trackId 过期
            [self getTrackId];
        }
    }];
}
//请求轨迹ID
-(void)getTrackId{
    [self networkPost:API_GETTRACKID parameter:@{} progresHudText:nil completionBlock:^(id rep) {
        //保存用户信息
        [[NSUserDefaults standardUserDefaults] setObject:rep[@"trackid"] forKey:@"trackid"];
        [SingalObj defaultManager].trackid=rep[@"trackid"];
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
