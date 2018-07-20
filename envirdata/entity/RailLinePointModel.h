//
//  RailLinePointModel.h
//  envirdata
//
//  Created by 熊佳佳 on 18/07/19.
//  Copyright © 2018年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RailLinePointModel : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSNumber * lat;
@property (nonatomic, strong) NSNumber * lng;
@property (nonatomic, strong) NSString * time;

@end