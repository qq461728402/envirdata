//
//  ConfigObj.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/3.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "ConfigObj.h"

@implementation ConfigObj
+(void)configObj{
    //设置状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //处理键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    //提示框
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMaximumDismissTimeInterval:1.5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setMinimumSize:CGSizeMake(100, 40)];
    [SVProgressHUD setCornerRadius:8];
    //导航栏配置
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:Font(16)}];
    [[UINavigationBar appearance] setBackIndicatorImage:PNGIMAGE(@"back")];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:PNGIMAGE(@"back")];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:0.001],
                                 
                                 NSForegroundColorAttributeName:[UIColor clearColor]};

    [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:COLOR_TOP];
    //检测网络
    AFNetworkReachabilityManager * networkmanager =[AFNetworkReachabilityManager sharedManager];
    [networkmanager startMonitoring];
    [networkmanager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [SVProgressHUD showInfoWithStatus:@"无网络链接"];
        }
    }];
}
+(UIImage*)getIconImge
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    return [UIImage imageNamed:icon];
}
@end
