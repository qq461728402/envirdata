//
//  MCUDeviceInfo.h
//  Mcu_sdk
//
//  Created by westke on 16/3/1.
//  Copyright © 2016年 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCUDeviceInfo : NSObject

@property (nonatomic, copy) NSString    *username;   /**< 设备的用户名 */
@property (nonatomic, copy) NSString    *password;   /**< 设备的密码 */
@property (nonatomic, copy) NSString    *deviceName; /**< 设备的名字 */
@property (nonatomic, copy) NSString    *indexCode; /**< 设备编号 */
@property (nonatomic, assign) BOOL hasAuthorityPatch;           /** 2.5对讲权限补丁 */
@property (nonatomic, assign) BOOL hasTalkAuthority;            /**< 对讲权限 */
@property (nonatomic, assign) NSInteger digitVoiceChannelNum;   /**< 对讲数字通道总数*/
@property (nonatomic, assign) NSInteger analogVoiceChannelNum;  /**< 对讲模拟通道总数*/
@end
