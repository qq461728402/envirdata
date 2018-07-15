//
//  RealPlayManagerEx.h
//  Mcu_sdk
//
//  Created by chenmengyi on 2017/7/1.
//  Copyright © 2017年 hikvision. All rights reserved.
//

/*
 该头文件适用于直接通过url取流
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VideoPlayUtility.h"

@protocol  RealPlayManagerExDelegate;

@interface RealPlayManagerEx : NSObject
@property (nonatomic,weak)id<RealPlayManagerExDelegate> delegate;

/**
 初始化并设置代理
 
 @param delegate 预览管理类代理对象
 @return 实例对象
 */
- (instancetype)initWithDelegate:(id<RealPlayManagerExDelegate>) delegate;

/**
 开始预览
 
 @param playUrl  预览url    拼接的预览url
 @param playView 预览视图    用户指定的展示播放的视图
 @param complete 回调函数    finish返回YES时,代表当前操作成功.finish返回NO时,message会返回预览过程中的失败信息
 */
- (void)startRealPlay:(NSString *)playUrl playView:(UIView *)playView complete:(void(^)(BOOL finish, NSString *message))complete;

/**
 停止预览
 
 @return YES停止预览成功,NO停止预览失败
 */
- (BOOL)stopRealPlay;

/**
 对播放画面进行抓图
 
 @param captureInfo 设置的抓图信息对象.抓图信息通过调用VideoPlayUtility类的 + getCaptureInfo: toCaptureInfo: 方法设置
 @return YES抓图成功,NO抓图失败
 */
- (BOOL)capture:(VPCaptureInfo *)captureInfo;

/**
 对播放画面进行录像
 
 @param recordInfo 设置的录像信息对象. 录像信息通过调用VideoPlayUtility类的 +getRecordInfo: toRecordInfo: 方法设置
 @return YES开始录像成功,NO开始录像失败
 */
- (BOOL)startRecord:(VPRecordInfo *)recordInfo;

/**
 停止录像
 
 @return YSE停止录像成功,NO停止录像失败
 */
- (BOOL)stopRecord;

/**
 打开声音
 
 @return YES打开声音成功;NO打开声音失败
 */
- (BOOL)openAudio;

/**
 关闭声音
 
 @return YES关闭声音成功;NO关闭声音失败
 */
- (BOOL)turnoffAudio;

/**
 *  开始云台控制
 *
 *  @param ptzCommond 云台命令 //云台命令: 11 焦距增大, 12焦距较小, 13聚焦增大, 14聚焦减小, 15光圈增大, 16光圈减小, 21 上, 22下, 23,左, 24右, 25左上, 26右上, 27左下, 28 右下, 8 设置预置点, 9清除预置点. 39调用预置点.
 *  @param presentIndex 预置点值（最大255）
 *  @param syscode    设备syscode
 *  @param magStreamSerAddr mag地址
 *  @param magHttpSerPort   mag端口号
 *  @param isCascadeFlag  YES:级联设备  NO：非级联设备
 *  @param isStart        YES:开始     NO：结束
 */
- (void)ptzControl:(NSInteger)ptzCommond ptzCommand:(NSInteger)ptzCommand presentIndex:(NSInteger)presentIndex syscode:(NSString *)syscode magSerAddr:(NSString *)magSerAddr magHttpSerPort:(NSString *)magHttpSerPort isCascadeFlag:(BOOL)isCascadeFlag isStart:(BOOL)isStart;

/**
 开始对讲操作
 
 @param talkChannel 选择的对讲通道号  //对讲通道分为模拟通道和数字通道.模拟通道号请直接按照模拟通道总个数,直接传入从1到通道总个数的任一数字.即为模拟通道号   //数字通道号,请按照数字通道总个数,直接传入从1到通道总个数的任一数字的值再加上500,即为数字通道号
 @param indexCode 设备编号
 @param magSerAddr mag地址
 @param magTalkSerPort mag对讲端口
 */
- (void)startTalkingWithChannel:(NSInteger)talkChannel deviceIndexCode:(NSString *)indexCode magSerAddr:(NSString *)magSerAddr magTalkSerPort:(NSString *)magTalkSerPort;

/**
 结束对讲操作
 
 @return YES:关闭对讲成功,NO:关闭对讲失败
 */
- (BOOL)stopTalking;

@end

@protocol RealPlayManagerExDelegate <NSObject>
@required
/**
 播放库预览状态回调
 
 用户可通过播放库返回的不同播放状态进行自己的业务处理
 
 @param playState 当前播放状态
 @param realPlayManagerEx 预览管理类
 */
- (void)realPlayCallBackEx:(PLAY_STATE)playState realManager:(RealPlayManagerEx *)realPlayManager;

@optional
/**
 对讲开启成功或失败的状态回调
 
 用户可根据开启对讲的状态回调进行自己的业务处理
 
 @param isFailed 开始对讲是否失败  YES:失败,  NO:成功
 */
- (void)talkingFailedCallBackEx:(BOOL)isFailed;

@end
