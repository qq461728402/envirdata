//
//  UIViewController+util.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/10.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFAppDotNetAPIClient.h"
#import "SVProgressHUD.h"
@interface UIViewController (util)
@property (nonatomic,copy) void (^callback)(BOOL issu);
-(void)networkGet:(NSString*)url parameter:(NSDictionary*)parameter progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock;
-(void)networkPost:(NSString*)url parameter:(NSDictionary*)parameter progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock;
//提示
-(void)showMsgBox:(NSString *)msg;

@end
