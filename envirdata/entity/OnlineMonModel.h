//
//  OnlineMonModel.h
//  envirdata
//
//  Created by 熊佳佳 on 18/07/14.
//  Copyright © 2018年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlineMonModel : NSObject

@property (nonatomic, strong) NSNumber * jd;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * uname;
@property (nonatomic, strong) NSNumber * utype;
@property (nonatomic, strong) NSString * utype_dval;
@property (nonatomic, strong) NSNumber * wd;
@property (nonatomic, strong) NSNumber * warinid;//预警ID
@property (nonatomic, strong) NSString * pic;

@end
