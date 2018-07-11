//
//  UIViewController+util.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/10.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "UIViewController+util.h"

@implementation UIViewController (util)
@dynamic callback;
-(void)networkGet:(NSString *)url parameter:(NSDictionary *)parameter progresHudText:(NSString *)hudText completionBlock:(void (^)(id))completionBlock{
    if (hudText!=nil) {
        [SVProgressHUD showWithStatus:hudText];
    }
    [[AFAppDotNetAPIClient shareClient] GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",[responseObject mj_JSONString]);
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        [SVProgressHUD showInfoWithStatus:@"加载错误"];
        completionBlock(nil);
    }];
}
-(void)networkPost:(NSString*)url parameter:(NSDictionary*)parameter progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock{
    if (hudText!=nil) {
        [SVProgressHUD showWithStatus:hudText];
    }
    [[AFAppDotNetAPIClient shareClient] POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",[responseObject mj_JSONString]);
        if (responseObject[@"code"]==0) {
            completionBlock(responseObject);
        }else{
            [self showMsgInfo:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        [SVProgressHUD showInfoWithStatus:@"加载错误"];
    }];
     
}
-(void) showMsgBox:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg
                                                delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
-(void)showMsgInfo:(NSString *)msg{
    [MBProgressHUD showMessage1:msg toView:self.view];
}

@end
