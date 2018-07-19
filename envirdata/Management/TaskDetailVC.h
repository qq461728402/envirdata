//
//  TaskDetailVC.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/18.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
@interface TaskDetailVC : UIViewController
@property (nonatomic,copy) void (^callback)(BOOL issu);
@property (nonatomic,assign)BOOL isOnlyLook;
@property (nonatomic,strong)TaskModel *taskModel;
@end
