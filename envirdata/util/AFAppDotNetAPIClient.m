//
//  AFAppDotNetAPIClient.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/10.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

@implementation AFAppDotNetAPIClient
static AFAppDotNetAPIClient * _afAppDotNetApi;
+(instancetype)shareClient{
    if (!_afAppDotNetApi) {
        //设置baseURL
        NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest=15.0;
        config.allowsCellularAccess=YES;
        _afAppDotNetApi = [[AFAppDotNetAPIClient manager] initWithBaseURL:[NSURL URLWithString:BASE_API] sessionConfiguration:config];
        //是否允许带SSL证书
        _afAppDotNetApi.securityPolicy.allowInvalidCertificates=YES;
        //请求超时时间
        _afAppDotNetApi.requestSerializer.timeoutInterval=10;
        //申明返回的数据是JSON类型
        _afAppDotNetApi.responseSerializer =[AFJSONResponseSerializer serializer];
        _afAppDotNetApi.requestSerializer =[AFJSONRequestSerializer serializer];
    }
    return  _afAppDotNetApi;
}
@end
