//
//  StatePointAnnotation.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/14.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "StatePointAnnotation.h"

@implementation StatePointAnnotation
-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title uid:(NSString*)uid
{
    self=[super init];
    if (self) {
        self.coordinate=coordinate;
        self.title=title;
        self.uid=uid;
    }
    return self;
}

@end
