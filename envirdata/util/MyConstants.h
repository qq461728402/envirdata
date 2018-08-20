//
//  MyConstants.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/10.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#ifndef MyConstants_h
#define MyConstants_h

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

#define PNGIMAGE(NAME) [UIImage imageNamed:NAME]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]
#define BoldFont(x) [UIFont boldSystemFontOfSize:x]
#define Font(x) [UIFont systemFontOfSize:x>20?20:x]

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//
#define USER_DEFAULTS(NAME) [[NSUserDefaults standardUserDefaults] objectForKey:(NAME)];

#define SCALE(scale)  scale*kScreenWidth/375.0

#define WEAKSELF     typeof(self) __weak weakSelf = self;

// 偏差定义为9像素
#define kMaxVariance        9
// 轻扫事件最大时间间隔
#define kMaxSwipeInterval   0.2f
// 轻扫自动停止时间间隔
#define kAutoStopInterval   0.5f
// 捏合展开操作自动停止时间
#define kMaxDelayInterval   1.0f

#define PTZ_COMMAND_ZOOM_IN             11      //焦距增大
#define PTZ_COMMAND_ZOOM_OUT            12      //焦距减小
#define PTZ_COMMAND_FOCUS_NEAR          13      //聚焦增大
#define PTZ_COMMAND_FOCUS_FAR           14      //聚焦减小
#define PTZ_COMMAND_IRIS_OPEN           15      //光圈增大
#define PTZ_COMMAND_IRIS_CLOSE          16      //光圈减小

#define PTZ_COMMAND_TILT_UP             21
#define PTZ_COMMAND_TILT_DOWN           22
#define PTZ_COMMAND_PAN_LEFT            23
#define PTZ_COMMAND_PAN_RIGHT           24
#define PTZ_COMMAND_UP_LEFT             25
#define PTZ_COMMAND_UP_RIGHT            26
#define PTZ_COMMAND_DOWN_LEFT           27
#define PTZ_COMMAND_DOWN_RIGHT          28


#endif /* MyConstants_h */
