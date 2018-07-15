//
//  VideoPlayInfo.h
//  PlayViewWork
//
//  Created by Dengsh on 13-10-17.
//  Copyright (c) 2013年 chenmengyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPlaySDK.h"

@interface VideoPlayInfo : NSObject

@property (nonatomic, copy)   NSString        *strID;/**< 设备id，或者监控点id */
@property (nonatomic, assign)   long             lChannel;/**< 通道号 */
@property (nonatomic, copy)   NSString        *strDeviceIp;/**< 设备ip */
@property (nonatomic, assign)   unsigned int     nDevicePort; /**< 设备端口 */
@property (nonatomic, copy)   NSString        *strUser;/**< 设备用户名 */
@property (nonatomic, copy)   NSString        *strPsw;/**< 设备密码 */
@property (nonatomic, copy)   NSString        *strPlayUrl;/**< 播放地址（如vtdu地址）或录像文件路径 */
@property (nonatomic, copy)   NSString        *strExtentID;/**< 扩展id */
@property (nonatomic, copy)   NSString        *strExtentIp;/**< 扩展ip */
@property (nonatomic, assign)   unsigned int     nExtentPort;/**< 扩展端口 */
@property (nonatomic, assign)   PROTOCAL_TYPE    protocalType;/**< 取流协议类型 */
@property (nonatomic, assign)   VP_STREAM_TYPE   streamType;/**< 主子码流 */
@property (nonatomic, assign)   STREAM_METHOD    streamMethod; /**< 取流方式 */
@property (nonatomic, assign)   PLAY_TYPE        playType;/**< 播放模式 */
@property (nonatomic, assign)   NSTimeInterval   fStartTime;/**< 回放开始时间 */
@property (nonatomic, assign)   NSTimeInterval   fStopTime;/**< 回放结束时间 */
@property (nonatomic, assign)   id               pPlayHandle;/**< 播放窗口 */
@property (nonatomic, assign)   BOOL             bSystransform;/**< 是否要开启转封装 */
@property (nonatomic, assign)   NSTimeInterval   fStreamTimeOut;/**< 最长不来流超时时间, 如果不设置，则默认为30秒 */
@property (nonatomic, assign)   BOOL             isHDPriority;/**< 硬解优先 */
@property (nonatomic, copy)     NSString        *strSecretKey;/**< AES加密秘钥，传nil则不加密 */

@end
