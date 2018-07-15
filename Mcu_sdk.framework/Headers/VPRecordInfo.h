//
//  VPRecordInfo.h
//  PlayViewWork
//
//  Created by Dengsh on 13-10-18.
//  Copyright (c) 2013年 chenmengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPRecordInfo : NSObject

@property(nonatomic, strong) NSString       *strRecordPath; /**< 录像路径 */
@property(nonatomic, strong) NSString       *strThumbnail;/**< 缩略图路径 */
@property(nonatomic, strong) NSString       *strRecPicPath;/**< 大图路径 */
@property(nonatomic, strong) NSString       *strWaterMaskImg;/**< 水印路径 */
@property(nonatomic, assign) BOOL            bSystransform;/**< 是否转封装 */
@property(nonatomic, assign) NSTimeInterval  fTimeInfo;/**< 录像开始时间 */

@end
