//
//  EnvOnlineMapVC.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/14.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface EnvOnlineMapVC : UIViewController
@property (nonatomic, copy) void (^callback)(UIViewController *pushview);
-(void)getdataInfo;
@end
