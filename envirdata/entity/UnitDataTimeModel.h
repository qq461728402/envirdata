//
//  UnitDataTimeModel.h
//  envirdata
//
//  Created by 熊佳佳 on 18/07/14.
//  Copyright © 2018年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitDataTimeModel : NSObject

@property (nonatomic, strong) NSNumber * aqi;
@property (nonatomic, strong) NSNumber * co;
@property (nonatomic, strong) NSNumber * jd;
@property (nonatomic, strong) NSNumber * no2;
@property (nonatomic, strong) NSNumber * o3;
@property (nonatomic, strong) NSString * o3_8h;
@property (nonatomic, strong) NSNumber * pm10;
@property (nonatomic, strong) NSNumber * pm25;
@property (nonatomic, strong) NSNumber * so2;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * uname;
@property (nonatomic, strong) NSNumber * utype;
@property (nonatomic, strong) NSString * utypename;
@property (nonatomic, strong) NSNumber * wd;
@property (nonatomic, strong) NSString * winddir;
@property (nonatomic, strong) NSString * windspeed;

@end