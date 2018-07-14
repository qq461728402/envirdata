//
//  WarnPointAnnotation.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/14.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "WarnPointAnnotation.h"

@implementation WarnPointAnnotation
-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title uid:(OnlineMonModel*)onlineModel
{
    self=[super init];
    if (self) {
        self.coordinate=coordinate;
        self.title=title;
        self.onlineModel=onlineModel;
    }
    return self;
}
@end
