//
//  CRecordInfo.h
//  iVMS-8700-MCU
//
//  Created by leejianzhang on 15-3-26.
//  Copyright (c) 2015年 HikVision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRecordInfo : NSObject

@property (nonatomic, assign)   int                     queryType;              // 录像类型
@property (nonatomic, assign)   BOOL                isRecvAll;                // 是否接收完毕
@property (nonatomic, assign)   int                     segmentCount;        // 录像片段数
@property (nonatomic, copy)     NSString            *segmentListPlayUrl; // 录像片段播放地址
@property (nonatomic, strong)    NSMutableArray  *recSegmentList;       // 录像片段列表

@end
