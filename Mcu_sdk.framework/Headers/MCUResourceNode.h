//
//  MCUResources.h
//  Mcu_sdk
//
//  Created by westke on 16/3/2.
//  Copyright © 2016年 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ResourceNodeType) {
    ResourceNodeTypeControlCenter = 1, //控制中心
    ResourceNodeTypeRegion,                 //区域
    ResourceNodeTypeCamera                 //监控点
};

@interface MCUResourceNode : NSObject

@property (nonatomic, copy) NSString           *nodeID;           /**< 节点ID , nodeType为3时，其相当于cameraID */
@property (nonatomic, copy) NSString           *parentNodeID;     /**< 父节点ID */
@property (nonatomic, copy) NSString           *nodeName;         /**< 节点名称 nodeType为3时，其相当于cameraName */
@property (nonatomic, copy) NSString           *sysCode;          /**< 监控点的sysCode，此处不为空 */
@property (nonatomic, copy) NSString           *userCapability;   /**< 监控点权限控制，@"1,2,4", 1代表有预览权限，2代表有录像回放权限，4代表有云台控制权限 */
@property (nonatomic, assign) ResourceNodeType  nodeType;         /**< nodeType：1对应平台里的控制中心，2代表平台里的区域， 3，对应监控点 */
@property (nonatomic, assign) BOOL              cascadeFlag;      /**< 监控点是否为级联，0非级联，1为级联 */
@property (nonatomic, assign) BOOL              isOnline;         /**< 监控点是否在线，0不在线，1在线 */

@end
