//
//  SingalObj.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/12.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
//单例模式 存储数据对象
@interface SingalObj : NSObject
+(SingalObj*)defaultManager;
@property (nonatomic,strong)UserInfoModel *userInfoModel;

@end
