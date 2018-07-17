//
//  DealPalyView.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/16.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DealPalyViewDelegate;
@interface DealPalyView : UIView
@property (nonatomic,assign)BOOL isPausing;//是否暂停 或 不能播放
@property(nonatomic, assign)id<DealPalyViewDelegate> delegate;
@end
@protocol DealPalyViewDelegate <NSObject>
/**
 云台控制代理方法
 @param ptzCommand 云台控制命令
 @param stop 是否停止
 @param end  是否结束
 */
-(void)deal_ptzOperationInControl:(int)ptzCommand stop:(BOOL)stop end:(BOOL)end;
-(void)deal_playrefreshRealPlay;
-(void)deal_capture;
-(void)deal_pausing:(BOOL)isstop;
@end
