//
//  PlayView.h
//  Mcu_sdk_demo
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PlayViewDelegate;

typedef enum
{
    Up = 21,
    Down,
    Left,
    Right,
    UpLeft,
    UpRight,
    DownLeft,
    DownRight
}Direction;

@interface PlayView : UIView<UIScrollViewDelegate>

@property(nonatomic, retain)UIView *playView;

@property(nonatomic, assign)BOOL isRecording;/**< 是否在录像*/
@property(nonatomic, assign)BOOL isPausing;/**< 是否暂停*/
@property(nonatomic, assign)BOOL isAudioing;/**< 是否开启声音*/
@property(nonatomic, assign)BOOL isEleZooming;/**< 是否开启电子放大*/
@property(nonatomic, assign)BOOL isChangeQuality;/**<是否改变播放码流*/
@property(nonatomic, assign)BOOL isPtz;                 /**<是否进行云台控制*/
@property (nonatomic, assign) BOOL    isTalking; /**< 是否进行对讲*/

@property(nonatomic, assign)BOOL addGesture;/**< 是否添加手势*/

@property(nonatomic, assign)id<PlayViewDelegate> delegate;

/**
 根据云台操作命令,设置播放视图上的自定义播放动画状态

 @param ptzCommand 云台控制命令
 @param stop 是否停止操作
 @param end 是否结束操作
 */
- (void)ptzOperation:(int)ptzCommand stop:(BOOL)stop end:(BOOL)end;

@end

@protocol PlayViewDelegate <NSObject>
/**
 云台控制代理方法

 @param ptzCommand 云台控制命令
 @param stop 是否停止
 @param end  是否结束
 */
-(void)ptzOperationInControl:(int)ptzCommand stop:(BOOL)stop end:(BOOL)end;

@end
