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
    if ([hudText isNotBlank]) {
        [SVProgressHUD showWithStatus:hudText];
    }
     NSDictionary * parameterdic = @{@"param":[parameter mj_JSONString]};
    [[AFAppDotNetAPIClient shareClient] GET:url parameters:parameterdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([hudText isNotBlank]) {
            [SVProgressHUD dismiss];
        }
        NSLog(@"%@",[responseObject mj_JSONString]);
        if ([responseObject[@"code"] intValue]==0) {
            completionBlock(responseObject[@"data"]);
        }else{
            [self showMsgInfo:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        [SVProgressHUD dismiss];
//        [SVProgressHUD showInfoWithStatus:@"加载错误"];
    }];
}
-(void)networkPost:(NSString*)url parameter:(NSDictionary*)parameter progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock{
    if ([hudText isNotBlank]) {
        [SVProgressHUD showWithStatus:hudText];
    }
    NSDictionary * parameterdic = @{@"param":[parameter mj_JSONString]};
    [[AFAppDotNetAPIClient shareClient] POST:url parameters: parameterdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([hudText isNotBlank]) {
             [SVProgressHUD dismiss];
        }
        NSLog(@"%@",[responseObject mj_JSONString]);
        if ([responseObject[@"code"] intValue]==0) {
            completionBlock(responseObject[@"data"]);
        }else{
            [self showMsgInfo:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"] ;
        NSString *errorStr = [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"failure--%@",errorStr);
        [SVProgressHUD dismiss];
//        [SVProgressHUD showInfoWithStatus:@"加载错误"];
    }];
}
-(void)networkPostAll:(NSString*)url parameter:(NSDictionary*)parameter progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock{
    if ([hudText isNotBlank]) {
        [SVProgressHUD showWithStatus:hudText];
    }
    NSDictionary * parameterdic = @{@"param":[parameter mj_JSONString]};
    [[AFAppDotNetAPIClient shareClient] POST:url parameters: parameterdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject mj_JSONString]);
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"] ;
        NSString *errorStr = [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"failure--%@",errorStr);
        [SVProgressHUD dismiss];
    }];
}
//只支持单张图片上传
-(void)networkUpfile:(NSString*)url imageAry:(UIImage*)image parameter:(NSDictionary*)parameter progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock{
    if ([hudText isNotBlank]) {
        [SVProgressHUD showWithStatus:hudText];
    }
    [[AFAppDotNetAPIClient shareClient] POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"---上传进度--- %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject mj_JSONString]);
        if ([responseObject[@"code"] intValue]==0) {
            completionBlock(responseObject[@"data"]);
        }else{
            [self showMsgInfo:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"xxx上传失败xxx %@", error);
    }];
}


-(void) showMsgBox:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg
                                                delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)showMsgInfo:(NSString *)msg{
    [MBProgressHUD showMessage1:msg toView:self.view];
}

@end
