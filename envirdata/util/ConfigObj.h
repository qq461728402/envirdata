//
//  ConfigObj.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/3.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IQKeyboardManager.h"
#import "SVProgressHUD.h"
@interface ConfigObj : NSObject
+(void)configObj;
+(UIImage*)getIconImge;
+(float)font_sizeWith:(float)fontsize strLong:(int)strLong;
+(NSString*)getWeekDay:(NSString*)currentStr;
@end
