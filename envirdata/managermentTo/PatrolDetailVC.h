//
//  PatrolDetailVC.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/24.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatrolTasksModel.h"
@interface PatrolDetailVC : UIViewController
@property (nonatomic,copy) void (^callback)(BOOL issu);
@property (nonatomic,strong)PatrolTasksModel *patrolTasksModel;
@end
