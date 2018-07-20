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

/// 百度坐标转高德坐标
+ (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor;

@end
