//
//  EnvAreaLevelListVC.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/12.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnvAreaLevelListVC : UIViewController
@property (nonatomic, copy) void (^callback)(UIViewController *pushview);
@property (nonatomic,strong)NSString *areaid;
@property (nonatomic,strong)NSString *api;
-(void)getdataInfo;
@end
