//
//  EnvAirQualityVC.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/11.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BMKLocationkit/BMKLocationComponent.h>
@interface EnvAirQualityVC : UIViewController<BMKLocationAuthDelegate,BMKLocationManagerDelegate>
@property (nonatomic,strong)BMKLocationManager *locationManager;
@end
