//
//  CRecordSegment.h
//  iVMS-8700-MCU
//
//  Created by leejianzhang on 15-3-26.
//  Copyright (c) 2015年 HikVision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPlaySDK.h"

@interface CRecordSegment : NSObject

@property (nonatomic, assign)   TIME_STRUCT          beginTime;// 开始时间
@property (nonatomic, assign)   TIME_STRUCT          endTime;   // 结束时间
@property (nonatomic, assign)   int              recordType;            // 录像类型
@property (nonatomic, assign)   int              mediaDataLen;        // 媒体数据大小
@property (nonatomic, assign)   int              metaDataLen;
@property (nonatomic, assign)   BOOL             isLocked;           // 是否锁定录像
@property (nonatomic, copy)     NSString        *playUrl;               // 播放地址

/**
 *	@brief	设置开始时间
 *
 *	@param 	beginTime 	开始时间
 */
- (void)setBeginTime:(TIME_STRUCT)beginTime;

/**
 *	@brief	设置结束时间
 *
 *	@param 	endTime 	结束时间
 */
- (void)setEndTime:(TIME_STRUCT)endTime;

@end

