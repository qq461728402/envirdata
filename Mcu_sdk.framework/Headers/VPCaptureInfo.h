//
//  VPCaptureInfo.h
//  PlayViewWork
//
//  Created by Dengsh on 13-10-18.
//  Copyright (c) 2013年 chenmengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPCaptureInfo : NSObject

@property (nonatomic, strong) NSString      *strCapturePath;/**< 大图路径 */
@property (nonatomic, strong) NSString      *strThumbnail;/**< 缩略图路径 */
@property (nonatomic, strong) NSString      *strWaterMaskImg;/**< 水印路径 */
@property (nonatomic, assign) NSTimeInterval fTimeInfo;/**< 抓图时间信息 */
@property (nonatomic, assign) unsigned int   nPicQuality;/**< 大图图片质量 */

@end
