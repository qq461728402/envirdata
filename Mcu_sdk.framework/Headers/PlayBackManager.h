//
//  PlayBackManager.h
//  Mcu_sdk
//  回放管理类
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VideoPlayUtility.h"
#import "CRecordInfo.h"
#import "CRecordSegment.h"
#import "MCUCameraInfo.h"

@protocol PlayBackManagerDelegate;

@interface PlayBackManager : NSObject

@property (nonatomic, strong) CRecordInfo             *recordInfo;/**< 用于画进度条*/
@property (nonatomic, strong) MCUCameraInfo           *cameraInfo;/**< 监控点信息*/
@property (nonatomic, weak) id <PlayBackManagerDelegate> delegate;

/**
 开始回放
 
 @param cameraSyscode 监控点syscode    监控点唯一标识,在MCUCameraInfo中获取
 @param playView 回放视图   用户指定的展示播放的视图
 @param date 当前日期       用来查询录像的日期
 @param complete finish: YES 播放成功 NO 播放失败 message:回调信息
 */
- (void)startPlayBack:(NSString *)cameraSyscode playView:(UIView *)playView date:(NSDate *)date complete:(void(^)(BOOL finish, NSString *message))complete;

/**
 更新播放至当前时间
 
 在播放片段内,根据时间选择播放进度

 @param currentTime 当前时间
 @param complete finish: YES 播放成功 NO 播放失败 message:回调信息
 */
- (void)updatePlayBackTime:(TIME_STRUCT)currentTime complete:(void(^)(BOOL finish, NSString *message))complete;

/**
 更新播放时间和录像位置
 
 用户可根据选择的录像位置,查询录像的日期,和监控点syscode重新查询录像进行回放
 
 @param date 选择的查询日期
 @param pos 选择的录像位置. 当前录像位置的获取,可通过MCUCameraInfo类recordPos属性获取.
 @param sysCode 监控点sysCode 监控点唯一标识,在MCUCameraInfo中获取
 @param complete finish: YES 播放成功 NO 播放失败 message:回调信息
 */
- (void)pickerStartPlayBack:(NSDate *)date currentPos:(NSString *)pos cameraSyscode:(NSString *)sysCode complete:(void(^)(BOOL finish, NSString *message))complete;

/**
 停止回放接口

 @return YES成功,NO失败
 */
- (BOOL)stopPlayBack;

/**
 获取全局osd时间

 全局osd时间是指当前回放画面对应的录制时间. 对应的是回放画面中左上角正在显示的时间.
 
 @return 返回当前全局osd时间
 */
- (NSTimeInterval)getOsdTime;

/**
 对播放画面进行抓图

 @param captureInfo 设置的抓图信息对象.抓图信息通过调用VideoPlayUtility类的 + getCaptureInfo: toCaptureInfo: 方法设置
 @return YES抓图成功,NO抓图失败
 */
- (BOOL)capture:(VPCaptureInfo *)captureInfo;

/**
 暂停回放操作

 @return YES暂停成功,NO暂停失败.
 */
- (BOOL)pausePlayBack;

/**
 在暂停成功后继续回放

 @return YES回放成功,NO回放失败
 */
- (BOOL)resumePlayBack;

/**
 对播放画面进行录像

 @param recordInfo 设置的录像信息对象. 录像信息通过调用VideoPlayUtility类的 +getRecordInfo: toRecordInfo: 方法设置
 @return YES开始录像成功,NO开始录像失败
 */
- (BOOL)startRecord:(VPRecordInfo *)recordInfo;

/**
 停止录像操作

 @return YES停止录像成功,NO停止录像失败
 */
- (BOOL)stopRecord;

/**
 打开声音

 @return YES打开声音成功,NO打开声音失败
 */
- (BOOL)openAudio;

/**
 关闭声音

 @return YES关闭声音成功,NO关闭声音失败
 */
- (BOOL)turnoffAudio;

#pragma mark ************************************定制需求-文城科技OEM合作项目*************************************

/**
 获取录像信息

 @param cameraSyscode 监控点syscode
 @param date 日期
 @param pos 存储介质
 @param complete finish:YES 查询成功 NO 查询失败
                 message：返回信息
                 recordInfo：录像片段模型信息
 */
- (void)quaryRecordInfo:(NSString *)cameraSyscode date:(NSDate *)date recordPos:(NSString *)pos complete:(void(^)(BOOL finish,NSString *message, CRecordInfo *recordInfo))complete;

/**
 开始回放、根据片段回放

 @param cameraSyscode 监控点syscode
 @param playView 播放画面
 @param pos 存储介质
 @param beginTime 开始时间（可从recordsegment模型中取得）
 @param endTime 结束时间 可从recordsegment模型中取得）
 @param recordInfo 所有录像信息模型
 @param complete finish:YES 回放成功 NO 回放失败
                 message：返回信息
 */
- (void)startPlayBackEx:(NSString *)cameraSyscode playView:(UIView *)playView recordPos:(NSString *)pos beginTime:(TIME_STRUCT)beginTime endTime:(TIME_STRUCT)endTime recordInfo:(CRecordInfo *)recordInfo complete:(void(^)(BOOL finish, NSString *message))complete;

@end

@protocol PlayBackManagerDelegate <NSObject>
/**
 播放库回放回调函数
 
 用户可通过播放库返回的不同播放状态进行自己的业务处理

 @param playState 当前播放状态
 @param playBackManager 回放管理类
 */
- (void)playBackCallBack:(PLAY_STATE)playState playBackManager:(PlayBackManager *)playBackManager;


@end
