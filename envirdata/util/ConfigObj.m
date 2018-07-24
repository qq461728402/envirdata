//
//  ConfigObj.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/3.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "ConfigObj.h"
#import <QuickLook/QuickLook.h>
#import <math.h>
@implementation ConfigObj
+(void)configObj{
    //设置状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //处理键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    //提示框
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMaximumDismissTimeInterval:1.5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setMinimumSize:CGSizeMake(100, 40)];
    [SVProgressHUD setCornerRadius:8];
    //导航栏配置
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:BoldFont(17),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setBackIndicatorImage:PNGIMAGE(@"back")];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:PNGIMAGE(@"back")];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:0.001],
                                 
                                 NSForegroundColorAttributeName:[UIColor clearColor]};

    [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:COLOR_TOP];
//    [[UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil]
//     setTintColor:[UIColor blackColor]];
    //设置文件浏览器导航栏
    UIBarButtonItem *qlitme =[UIBarButtonItem appearanceWhenContainedIn:[QLPreviewController class], nil];
    NSDictionary *qlitmeattributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 
                                 NSForegroundColorAttributeName:[UIColor whiteColor]};
    [qlitme setTitleTextAttributes:qlitmeattributes forState:UIControlStateNormal];
    [[UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil] setBackgroundImage:[UIImage imageWithColor:COLOR_TOP] forBarMetrics:UIBarMetricsDefault];
    
    //检测网络
    AFNetworkReachabilityManager * networkmanager =[AFNetworkReachabilityManager sharedManager];
    [networkmanager startMonitoring];
    [networkmanager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [SVProgressHUD showInfoWithStatus:@"无网络链接"];
        }
    }];
}
+(UIImage*)getIconImge
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    return [UIImage imageNamed:icon];
}
+(float)font_sizeWith:(float)fontsize strLong:(int)strLong{
    NSString *str=@"";
    for (int i=0; i<strLong; i++) {
        str=[str stringByAppendingString:@"哈"];
    }
    CGSize  StrSize  =[str sizeWithAttributes:@{NSFontAttributeName:Font(fontsize)}];
    return StrSize.width;
}
+(float)font_sizeWithStr:(float)fontsize str:(NSString*)str{
    CGSize  StrSize  =[str sizeWithAttributes:@{NSFontAttributeName:Font(fontsize)}];
    return StrSize.width;
}



+(NSString*)getWeekDay:(NSString*)currentStr

{
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    
    NSDate*date =[dateFormat dateFromString:currentStr];
    
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",nil];
    
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    
    NSDateComponents*theComponents = [calendar components:calendarUnit fromDate:date];
    
    return[weekdays objectAtIndex:theComponents.weekday];
    
}
+(int)getIAQIbyFactor:(NSString*)factor val:(double)val{
    double value = 0;
    if(val){
        value = val;
    }
    double IH = 0;
    double IL = 0;
    double BH = 0;
    double BL = 0;
    NSString *fac =  [factor lowercaseString];
    if ([fac isEqualToString:@"so2_1"]) {
       int x = [self calcStartStr:SO2_1 :value];
        NSArray *SO2_1Ary =[SO2_1 componentsSeparatedByString:@","];
        if(x==0){
            return 0;
        }
        IH = [AQI_NUM[x] doubleValue];
        IL = [AQI_NUM[x-1] doubleValue];
        BH = [SO2_1Ary[x] doubleValue];
        BL = [SO2_1Ary[x-1] doubleValue];
    }else if ([fac isEqualToString:@"so2_24"]){
        int x = [self calcStartStr:SO2_24 :value];
        NSArray *SO2_1Ary =[SO2_24 componentsSeparatedByString:@","];
        if(x==0){
            return 0;
        }
        IH = [AQI_NUM[x] doubleValue];
        IL = [AQI_NUM[x-1] doubleValue];
        BH = [SO2_1Ary[x] doubleValue];
        BL = [SO2_1Ary[x-1] doubleValue];
    }
    else if ([fac isEqualToString:@"no2_24"]){
        int x = [self calcStartStr:NO2_24 :value];
        NSArray *SO2_1Ary =[NO2_24 componentsSeparatedByString:@","];
        if(x==0){
            return 0;
        }
        IH = [AQI_NUM[x] doubleValue];
        IL = [AQI_NUM[x-1] doubleValue];
        BH = [SO2_1Ary[x] doubleValue];
        BL = [SO2_1Ary[x-1] doubleValue];
    }
    else if ([fac isEqualToString:@"no2_1"]){
        int x = [self calcStartStr:NO2_1 :value];
        NSArray *SO2_1Ary =[NO2_1 componentsSeparatedByString:@","];
        if(x==0){
            return 0;
        }
        IH = [AQI_NUM[x] doubleValue];
        IL = [AQI_NUM[x-1] doubleValue];
        BH = [SO2_1Ary[x] doubleValue];
        BL = [SO2_1Ary[x-1] doubleValue];
    }
    else if ([fac isEqualToString:@"o3_1"]){
        int x = [self calcStartStr:O3_1 :value];
        NSArray *SO2_1Ary =[O3_1 componentsSeparatedByString:@","];
        if(x==0){
            return 0;
        }
        IH = [AQI_NUM[x] doubleValue];
        IL = [AQI_NUM[x-1] doubleValue];
        BH = [SO2_1Ary[x] doubleValue];
        BL = [SO2_1Ary[x-1] doubleValue];
    }
    else if ([fac isEqualToString:@"o3_8"]){
        int x = [self calcStartStr:O3_8 :value];
        NSArray *SO2_1Ary =[O3_8 componentsSeparatedByString:@","];
        if(x==0){
            return 0;
        }
        IH = [AQI_NUM[x] doubleValue];
        IL = [AQI_NUM[x-1] doubleValue];
        BH = [SO2_1Ary[x] doubleValue];
        BL = [SO2_1Ary[x-1] doubleValue];
    }
    else if ([fac isEqualToString:@"pm10"]){
        int x = [self calcStartStr:PM10 :value];
        NSArray *SO2_1Ary =[PM10 componentsSeparatedByString:@","];
        if(x==0){
            return 0;
        }
        IH = [AQI_NUM[x] doubleValue];
        IL = [AQI_NUM[x-1] doubleValue];
        BH = [SO2_1Ary[x] doubleValue];
        BL = [SO2_1Ary[x-1] doubleValue];
    }
    else if ([fac isEqualToString:@"pm25"]){
        int x = [self calcStartStr:PM25 :value];
        NSArray *SO2_1Ary =[PM25 componentsSeparatedByString:@","];
        if(x==0){
            return 0;
        }
        IH = [AQI_NUM[x] doubleValue];
        IL = [AQI_NUM[x-1] doubleValue];
        BH = [SO2_1Ary[x] doubleValue];
        BL = [SO2_1Ary[x-1] doubleValue];
    }
    else if ([fac isEqualToString:@"co_1"]){
        int x = [self calcStartStr:CO_1 :value];
        NSArray *SO2_1Ary =[CO_1 componentsSeparatedByString:@","];
        if(x==0){
            return 0;
        }
        IH = [AQI_NUM[x] doubleValue];
        IL = [AQI_NUM[x-1] doubleValue];
        BH = [SO2_1Ary[x] doubleValue];
        BL = [SO2_1Ary[x-1] doubleValue];
    }else if ([fac isEqualToString:@"co_24"]){
        int x = [self calcStartStr:CO_24 :value];
        NSArray *SO2_1Ary =[CO_24 componentsSeparatedByString:@","];
        if(x==0){
            return 0;
        }
        IH = [AQI_NUM[x] doubleValue];
        IL = [AQI_NUM[x-1] doubleValue];
        BH = [SO2_1Ary[x] doubleValue];
        BL = [SO2_1Ary[x-1] doubleValue];
    }
    if (IH>0) {
      return  (int) ceil((IH-IL)*(value-BL)/(BH-BL) + IL);
    }
    return 0;
}

+(int) calcStartStr:(NSString*)soure :(double)val{
    
    NSArray *soureAry = [soure componentsSeparatedByString:@","];
    double value = 0;
    if(val){
        value = val;
    }
    int position = -1;
    int num = (int)soureAry.count;
    double err = 0.001;
    for (int i = 0; i < num; i++) {
        double temp = [soureAry[i] doubleValue];
        if(value+err <= temp || value-err<=temp){
            position = i;
            break;
        }
    }
    if(position<0){
        position = num - 1;
    }
    return position;
}



+(int)getLevelByAQI:(double)aqiD{
    
    double aqi = 0;
    if(aqiD){
        aqi = aqiD;
    }
    if(aqi < 1){
        return 0; // 表示离线
    }else if(aqi <= [AQI_NUM[1] intValue]){ // 优 绿色 一级
        return 1;
    }else if(aqi <= [AQI_NUM[2] intValue]){ // 良 黄色 二级
        return 2;
    }else if(aqi <= [AQI_NUM[3] intValue]){ // 轻度污染 橙色 三级
        return 3;
    }else if(aqi <= [AQI_NUM[4] intValue]){ // 中度污染 红色 四级
        return 4;
    }else if(aqi <= [AQI_NUM[5] intValue]){ // 重度污染 紫色 五级
        return 5;
    }else{ // 严重污染 褐红色 六级
        return 6;
    }
    return 0;
}
+(NSString*)getLevelName:(int)level{
    NSString *result =@"";
    switch (level){
        case 1:
            result = @"优";
            break;
        case 2:
            result = @"良";
            break;
        case 3:
            result = @"轻度污染";
            break;
        case 4:
            result = @"中度污染";
            break;
        case 5:
            result = @"重度污染";
            break;
        case 6:
            result = @"严重污染";
            break;
        default:
            result = @"--";
            break;
    }
    return  result;
}
+(UIColor*)getColorByLevel:(int)level{
    UIColor *result =[UIColor new];
    switch (level){
        case 1:
            result = API_LEVEL1;
            break;
        case 2:
            result = API_LEVEL2;
            break;
        case 3:
            result = API_LEVEL3;
            break;
        case 4:
            result = API_LEVEL4;
            break;
        case 5:
            result = API_LEVEL5;
            break;
        case 6:
            result = API_LEVEL6;
            break;
        default:
            result = API_NODATA;
            break;
    }
    return result;
}

/// 百度坐标转高德坐标
+ (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor
{
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude - 0.0065, y = coor.latitude - 0.006;
    CLLocationDegrees z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CLLocationDegrees gg_lon = z * cos(theta);
    CLLocationDegrees gg_lat = z * sin(theta);
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}


@end
