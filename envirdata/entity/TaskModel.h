//
//  TaskModel.h
//  envirdata
//
//  Created by 熊佳佳 on 18/07/17.
//  Copyright © 2018年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * ctime;
@property (nonatomic, strong) NSString * hcontent;
@property (nonatomic, strong) NSString * hpics;
@property (nonatomic, strong) NSString * htime;
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSNumber * jd;
@property (nonatomic, strong) NSNumber * kind;
@property (nonatomic, strong) NSString * limittime;
@property (nonatomic, strong) NSString * pics;
@property (nonatomic, strong) NSString * position;
@property (nonatomic, strong) NSNumber * receiver;
@property (nonatomic, strong) NSString * receivername;
@property (nonatomic, strong) NSNumber * regionId;
@property (nonatomic, strong) TaskModel * reldata;//关联任务
@property (nonatomic, strong) NSNumber * relid;
@property (nonatomic, strong) NSString * remarks;
@property (nonatomic, strong) NSNumber * sendor;
@property (nonatomic, strong) NSString * sendorname;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) NSNumber * wd;

@end
