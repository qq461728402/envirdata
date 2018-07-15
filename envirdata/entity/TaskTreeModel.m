//
//  TaskTreeModel.m
//  envirdata
//
//  Created by 熊佳佳 on 18/07/15.
//  Copyright © 2018年 dx. All rights reserved.
//

#import "TaskTreeModel.h"
@implementation TaskTreeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
	return @{@"tid":@"id"};
}

@end