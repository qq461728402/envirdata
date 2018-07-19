//
//  RailLineMapVC.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/19.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface RailLineMapVC : UIViewController<BMKMapViewDelegate>
@property (nonatomic,strong)NSString *userId;
@end
