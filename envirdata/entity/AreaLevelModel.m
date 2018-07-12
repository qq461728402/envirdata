//
//  AreaLevelModel.m
//  envirdata
//
//  Created by 熊佳佳 on 18/07/12.
//  Copyright © 2018年 dx. All rights reserved.
//

#import "AreaLevelModel.h"
@implementation AreaLevelModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"pm25":@"pm2.5"};
}
@end
