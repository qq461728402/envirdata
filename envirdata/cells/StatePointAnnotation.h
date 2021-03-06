//
//  StatePointAnnotation.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/14.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKPointAnnotation.h"
#import "OnlineMonModel.h"
@interface StatePointAnnotation : BMKPointAnnotation
@property (nonatomic,strong)OnlineMonModel *onlineModel;
-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title uid:(OnlineMonModel*)onlineModel;
@end
