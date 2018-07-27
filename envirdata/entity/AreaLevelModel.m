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
-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"co"]||[property.name isEqualToString:@"no2"]||[property.name isEqualToString:@"o3"]||[property.name isEqualToString:@"pm10"]||[property.name isEqualToString:@"pm25"]||[property.name isEqualToString:@"so2"]) {
        NSString *numString = [NSString stringWithFormat:@"%lf",[oldValue doubleValue]];
        NSDecimalNumber *desnum = [NSDecimalNumber decimalNumberWithString:numString];
        NSLog(@"%@",[desnum stringValue]);
        return [desnum stringValue];
    }
    return oldValue;    
}
@end
