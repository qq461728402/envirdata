//
//  GetTasksVC.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/23.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetTasksVC : UIViewController
@property (nonatomic, copy) void (^callback)(UIViewController *pushview);
@property (nonatomic,strong)NSString *type; //1 表示现场巡查 2 表示监察任务
-(void)gettasks:(BOOL)isrefsh;
@end
