//
//  ForecastAreaModel.h
//  envirdata
//
//  Created by 熊佳佳 on 18/07/12.
//  Copyright © 2018年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForecastAreaModel : NSObject

@property (nonatomic, strong) NSNumber * aqi;
@property (nonatomic, strong) NSString * aqirank;
@property (nonatomic, strong) NSNumber * areaid;
@property (nonatomic, strong) NSString * areaname;
@property (nonatomic, strong) NSNumber * co;
@property (nonatomic, assign) int  level;
@property (nonatomic, strong) NSNumber * no2;
@property (nonatomic, strong) NSNumber * o3;
@property (nonatomic, strong) NSNumber * pm10;
@property (nonatomic, strong) NSNumber * pm25;
@property (nonatomic, strong) NSString * primarypollu;
@property (nonatomic, strong) NSString * quality;
@property (nonatomic, strong) NSNumber * so2;
@property (nonatomic, strong) NSString * time;

@end
