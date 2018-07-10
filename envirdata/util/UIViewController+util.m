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
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        [SVProgressHUD showInfoWithStatus:@"加载错误"];
        completionBlock(nil);
    }];
    
}
-(void)showleft{
    UIButton *leftbtn= [[UIButton alloc] initWithFrame:CGRectMake(0,20, 55, 44)];
    [leftbtn setImage:PNGIMAGE(@"back_btn_n") forState:UIControlStateNormal];
    [leftbtn setImage:PNGIMAGE(@"back_btn_h") forState:UIControlStateHighlighted];
    [leftbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    [leftbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    leftbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftbtn bk_addEventHandler:^(id sender) {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 10;
    self.navigationItem.leftBarButtonItems=@[[[UIBarButtonItem alloc]initWithCustomView:leftbtn],negativeSpacer];
}

-(void) showMsgBox:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg
                                                delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
