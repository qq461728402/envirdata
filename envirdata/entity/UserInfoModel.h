//
//  UserInfoModel.h
//  envirdata
//
//  Created by 熊佳佳 on 18/07/12.
//  Copyright © 2018年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic, strong) NSString * appexpand1;
@property (nonatomic, strong) NSString * appexpand2;
/**
 *  区域ID
 */
@property (nonatomic, strong) NSNumber * areaid;
/**
 *  区域名称
 */
@property (nonatomic, strong) NSString * areaname;
/**
 *  登录名称
 */
@property (nonatomic, strong) NSString * passport;
/**
 *  电话
 */
@property (nonatomic, strong) NSString * phone;
/**
 *  密码
 */
@property (nonatomic, strong) NSString * pwd;
/**
 *  角色ID
 */
@property (nonatomic, strong) NSNumber * roleid;
/**
 *  角色名称
 */
@property (nonatomic, strong) NSString * rolename;
/**
 *  用户ID
 */
@property (nonatomic, strong) NSNumber * userid;
/**
 *  用户名称
 */
@property (nonatomic, strong) NSString * username;

@end