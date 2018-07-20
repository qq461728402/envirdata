//
//  VersionModel.h
//  envirdata
//
//  Created by 熊佳佳 on 18/07/20.
//  Copyright © 2018年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionModel : NSObject

@property (nonatomic, strong) NSString * appname;
@property (nonatomic, strong) NSString * appvid;
@property (nonatomic, strong) NSString * descript;
@property (nonatomic, strong) NSNumber * download;
@property (nonatomic, strong) NSNumber * isforce;
@property (nonatomic, strong) NSString * uploadby;
@property (nonatomic, strong) NSString * uploader;
@property (nonatomic, strong) NSString * uploadtime;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * versioncode;

@end