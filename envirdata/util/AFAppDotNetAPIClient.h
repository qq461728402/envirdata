//
//  AFAppDotNetAPIClient.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/10.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFAppDotNetAPIClient : AFHTTPSessionManager
+(instancetype)shareClient;

@end
