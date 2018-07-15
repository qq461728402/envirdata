//
//  MCUVmsNetSDK.h
//  iVMS-8700-MCU
//
//  Created by leejianzhang on 15-3-30.
//  Copyright (c) 2015年 HikVision. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MCULoginData;

@interface MCUVmsNetSDK : NSObject
@property (nonatomic, strong, readonly) MCULoginData        *loginData; /**< 登录信息*/

+ (MCUVmsNetSDK*)shareInstance;

/**
 *  初始化msp的IP与端口
 
    用来配置登录平台所需的地址和端口号,平台默认端口号为443
 *
 *  @param address msp的IP地址
 *  @param port    msp的端口
 */
- (void)configMspWithAddress:(NSString *)address port:(NSString *)port;

/**
 登录平台接口

 @param username 用户名
 @param password 用户密码
 @param success 登录成功的回调
 @param failure 登录失败的回调
 */
- (void)loginMspWithUsername:(NSString *)username password:(NSString * )password success:(void (^)(id object))success failure:(void (^)( NSError *error))failure;

/**
 退出登录接口

 @param success 退出登录成功的回调
 @param failure 退出登录失败的回调
 */
- (void)logoutMsp:(void (^)(id object))success failure:(void (^)(NSError *error))failure;

/**
 *  获取组织树节点的第一级节点资源
 *  @param sysType    获取类型 1:视频 2:门禁  此处用户选择传递1,获取视频资源即可
 *  @param success        成功回调函数
 *  @param failure        失败回调函数
 */
- (void)requestRootNodeWithSysType:(NSInteger)sysType success:(void (^)( id object))success failure:(void (^)(NSError *error))failure;

/**
 *  获取组织树节点的子节点资源
 *  nodeType代表当前节点类型.节点类型是3,代表是监控点类型,是用户用来进行预览和回放操作所需的节点类型. 用户可根据 MCUResourceNode类中的nodeType进行区分
 *
 *  @param sysType        资源类型 1:视频 2:门禁, 此处用户选择传递1,获取视频资源即可
 *  @param nodeType       当前节点类型 1:控制中心 2:区域
 *  @param currentID      请求获取子资源的节点的ID
 *  @param numPerPage     每页获取数量
 *  @param curPage        当前第几页
 *  @param success        成功回调函数
 *  @param failure        失败回调函数
 */
- (void)requestResourceWithSysType:(NSInteger)sysType nodeType:(NSInteger)nodeType currentID:(NSString *)currentID numPerPage:(NSInteger)numPerPage curPage:(NSInteger)curPage success:(void (^)( id object))success failure:(void (^)(NSError *error))failure;

/**
 *  向MSP发送请求
 *
 *  @param params     请求参数
 *  @param methodName 请求方法
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (void)requestMSPWithParams:(NSDictionary *)params requestMethodName:(NSString *)methodName success:(void(^)(id result))success failure:(void (^)(NSError *error))failure;

@end
