//
//  TaskTreeModel.h
//  envirdata
//
//  Created by 熊佳佳 on 18/07/15.
//  Copyright © 2018年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskTreeModel : NSObject

@property (nonatomic, strong) NSNumber * checknum;
@property (nonatomic, strong) NSString * tid;
@property (nonatomic, strong) NSString * level;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * pid;
@property (nonatomic, strong) NSString * team;
@property (nonatomic, strong) NSNumber * teamid;
@property (nonatomic, strong) NSNumber * todonum;
@property (nonatomic, strong) NSMutableArray *chlidren;//chlidren
@property (nonatomic, assign) BOOL isExpanded;//是否打开
@property (nonatomic, assign) int creatLevle;
@end
