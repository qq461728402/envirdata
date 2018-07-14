//
//  AppDelegate.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/3.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GTSDK/GeTuiSdk.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,GeTuiSdkDelegate,UNUserNotificationCenterDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *)Share;
-(void)gotologin;
-(void)gotohome;
@end

