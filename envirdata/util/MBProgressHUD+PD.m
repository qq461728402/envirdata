//
//  MBProgressHUD+PD.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/10.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "MBProgressHUD+PD.h"

@implementation MBProgressHUD (PD)
/**
 *  =======显示信息
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:17.0];
    hud.userInteractionEnabled= NO;
    hud.minSize = CGSizeMake(SCREEN_WIDTH/4, 24);
    hud.customView = [[UIImageView alloc] initWithImage:PNGIMAGE(icon)];  // 设置图片
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.textColor = UIColorFromRGB(0xffffff);
    hud.bezelView.backgroundColor = UIColorFromRGB(0x000000);
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
}

/**
 *  =======显示 提示信息
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

/**
 *  =======显示
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

/**
 *  =======显示错误信息
 */
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}
/**
 *  显示提示 + 菊花
 *  @param message 信息内容
 *  @return 直接返回一个MBProgressHUD， 需要手动关闭(  ?
 */
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

/**
 *  显示一些信息
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minShowTime=0.5;
    hud.offset=CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT-70);
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color=UIColorFromRGB(0xfffffff);
    hud.label.textColor = UIColorFromRGB(0xffffff);
    hud.bezelView.backgroundColor = UIColorFromRGB(0x000000);
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.animationType=MBProgressHUDAnimationFade;
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
/**
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    
    [self hideHUDForView:view animated:YES];
}


+(void)showMessage1:(NSString*)message toView:(UIView *)view{
    
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode=MBProgressHUDModeCustomView;
    hud.animationType=MBProgressHUDAnimationFade;
    hud.minSize = CGSizeMake(kScreenWidth/4, 24);
    hud.label.textColor = UIColorFromRGB(0xffffff);
    hud.bezelView.backgroundColor = UIColorFromRGB(0x000000);
    hud.margin = 15;
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
}

@end
