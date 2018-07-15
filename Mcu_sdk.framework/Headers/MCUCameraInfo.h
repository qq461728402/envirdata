//
//  MCUCameraInfo.h
//  Mcu_sdk
//
//  Created by westke on 16/3/1.
//  Copyright © 2016年 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCUCameraInfo : NSObject

@property (nonatomic, copy) NSString    *sysCode;       /**<监控点sysCode*/
@property (nonatomic, copy) NSString    *cameraID;      /**<监控点id*/
@property (nonatomic, copy) NSString    *cameraName; /**<监控点名称*/
@property (nonatomic, copy) NSString    *userCapability; /**<用户权限 1代表实时预览，2代表录像回放，3代表云台控制 */
@property (nonatomic, copy) NSString    *deviceID;       /**< 对应的设备ID */
@property (nonatomic, copy) NSString    *gbSysCode;      /**< 级联的时候用gbSysCode组装播放的URL */
@property (nonatomic, copy) NSString     *guid;             /**< 录像唯一标识*/
@property (nonatomic, assign) NSInteger  type;              /**< 监控点类型, 0枪机 1半球 2快球 3.云台 */
@property (nonatomic, copy) NSString     *recordPos;      /**< 录像保存的位置 */
@property (nonatomic, assign) NSInteger  channelNo;      /**< 所属通道号 */
@property (nonatomic, assign) NSInteger  deviceNetID;   /**< 设备网域ID*/
@property (nonatomic, assign) BOOL       cascadeFlag;    /**< 级联表示，0表示非级联，1表示级联 */
@property (nonatomic, assign) BOOL       isOnline;       /**< 是否在线*/

@end
