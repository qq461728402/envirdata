//
//  AddPatrolTasksVC.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/24.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BMKLocationkit/BMKLocationComponent.h>
@interface AddgetComplaintTasksVC : UIViewController<BMKLocationAuthDelegate,BMKLocationManagerDelegate>
@property (nonatomic,copy) void (^callback)(BOOL issu);
@property (nonatomic,strong)BMKLocationManager *locationManager;
@property (nonatomic,strong)NSNumber *jd;
@property (nonatomic,strong)NSNumber *wd;
@end
