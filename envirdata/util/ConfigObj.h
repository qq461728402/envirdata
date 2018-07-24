//
//  ConfigObj.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/3.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IQKeyboardManager.h"
#import "SVProgressHUD.h"
#import "BMKLocation.h"
static NSString const *AQI_NUM[8] = {@"0",@"50",@"100",@"150",@"200",@"300",@"400",@"500"};



static NSString  *SO2_24=@"0,50,150,475,800,1600,2100,2620";

static NSString  *SO2_1 =@"0,150,500,650,800,1600,2100,2620";
static NSString  *NO2_24 =@"0,40,80,180,280,565,750,940";
static NSString  *NO2_1 =@"0,100,200,700,1200,2340,3090,3840";
static NSString  *PM10 =@"0,50,150,250,350,420,500,600";
static NSString  *CO_24 =@"0,2,4,14,24,36,48,60";
static NSString  *CO_1 =@"0,5,10,35,60,90,120,150";
static NSString  *O3_1 =@"0,160,200,300,400,800,1000,1200";
static NSString  *O3_8=@"0,100,160,215,265,800,1000,1200";
static NSString  *PM25=@"0,35,75,115,150,250,350,500";

@interface ConfigObj : NSObject
+(void)configObj;
+(UIImage*)getIconImge;
+(float)font_sizeWith:(float)fontsize strLong:(int)strLong;

+(float)font_sizeWithStr:(float)fontsize str:(NSString*)str;

+(NSString*)getWeekDay:(NSString*)currentStr;

//获取AQI等级
+(int)getLevelByAQI:(double)aqiD;
//获取等级名称
+(NSString*)getLevelName:(int)level;
//根据等级获取颜色值
+(UIColor*)getColorByLevel:(int)level;
//根据环境监测获取AQI
+(int)getIAQIbyFactor:(NSString*)factor val:(double)val;

/// 百度坐标转高德坐标
+ (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor;

@end
