//
//  YesterDayModel.h
//  envirdata
//
//  Created by 熊佳佳 on 18/07/20.
//  Copyright © 2018年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YesterDayModel : NSObject

@property (nonatomic, strong) NSNumber * aqi;
@property (nonatomic, strong) NSString * areaname;
@property (nonatomic, strong) NSNumber * finish_num;
@property (nonatomic, strong) NSNumber * level;
@property (nonatomic, strong) NSNumber * level12;
@property (nonatomic, strong) NSNumber * notfinish_num;
@property (nonatomic, strong) NSNumber * patrol_num;
@property (nonatomic, strong) NSString * primary_pollu;
@property (nonatomic, strong) NSNumber * task_num;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSNumber * unit_illegal;
@property (nonatomic, strong) NSNumber * unit_illegalpic;
@property (nonatomic, strong) NSNumber * unit_normal;
@property (nonatomic, strong) NSNumber * unit_total;
@property (nonatomic, strong) NSString * virtualId;

@end