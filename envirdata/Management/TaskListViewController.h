//
//  TaskListViewController.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/17.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskListViewController : UIViewController
@property (nonatomic,copy) void (^callback)(BOOL issu);
@property (nonatomic,strong)NSString *receiver;//接收人
@property (nonatomic,strong)NSString *sendor;//发送人
@property (nonatomic,strong)NSString *status;//状态
@end
