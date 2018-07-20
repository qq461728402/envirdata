//
//  ReportModel.h
//  envirdata
//
//  Created by 熊佳佳 on 18/07/19.
//  Copyright © 2018年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportModel : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * reportId;
@property (nonatomic, strong) NSNumber * sontypeid;
@property (nonatomic, strong) NSString * sontypename;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSNumber * typeId;
@property (nonatomic, strong) NSString * url;

@end