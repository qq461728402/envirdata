//
//  StatePointAnnotation.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/14.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKPointAnnotation.h"
@interface StatePointAnnotation : BMKPointAnnotation
@property (nonatomic,strong)NSString *uid;
-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title uid:(NSString*)uid;
@end
