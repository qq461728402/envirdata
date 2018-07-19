//
//  AddTaskViewController.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/17.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import "TaskModel.h"
@interface AddTaskViewController : UIViewController<BMKLocationAuthDelegate,BMKLocationManagerDelegate>
@property (nonatomic,copy) void (^callback)(BOOL issu);
@property (nonatomic,strong)NSString *kind;//1新增、2转发
@property (nonatomic,strong)NSString *uid;//用户ID
@property (nonatomic,strong)NSString *uname;//用户名称
@property (nonatomic,strong)NSMutableArray *pricrAry;
@property (nonatomic,strong)TaskModel *reldata;//关联任务
@property (nonatomic,strong)BMKLocationManager *locationManager;
@property (nonatomic,strong)NSNumber *jd;
@property (nonatomic,strong)NSNumber *wd;
@end
