//
//  EnvOnlienListVC.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/14.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnvOnlienListVC : UIViewController
@property (nonatomic, copy) void (^callback)(UIViewController *pushview);
-(void)getdataInfo: (BOOL)isrefesh;
@end
