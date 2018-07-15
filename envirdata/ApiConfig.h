//
//  ApiConfig.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/10.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#ifndef ApiConfig_h
#define ApiConfig_h

#define BASE_API  @"http://139.159.243.179:22816/app/"

#define API_CHECKUSER @"api/checkUser"  //登录接口
#define API_BINDDEVICE @"api/bindDevice" //绑定设备号

//空气质量
#define API_GETNEARESTGKZREAL @"api/getNearestGkzReal" //最近国控站实况接口
#define API_GETNEARESTAREAREAL @"api/getNearestAreaReal" //当前行政区域实况接口
#define API_GETFORECASTAREA @"api/getForecastArea" //预报数据接口
#define API_GETAREALEVELAIRQUALITY @"api/getAreaLevelAirQuality" //行政区监测实况接口
#define API_GETCITYGKZPOINTS @"api/getCityGkzPoints" // 站点实时监控状态接口
#define API_GETHISTORYVALUEDATA @"api/getHistoryValueData" //区域（国控站）历史接口

//在线监控
#define API_GETUNITONLINESTATE @"api/getUnitOnlineState" //站点实时监控状态接口
#define API_GETUNITWARNINGPICS @"api/getUnitWarningPics" //预警点的数据接口
#define API_GETTYPEDESCIPT @"api/getTypeDescipt" //站点类型
#define API_GETCAMERAINFO  @"api/getCameraInfo" //获取摄像头信息
#define API_GETNEWUNITPICHOURDATA @"api/getNewUnitPicHourData"//站点监测要素及值
#define API_GETUNITDATATIME @"api/getUnitDataTime" //获取监测站点的实时监测数据
#define API_GETUNITPICSADDRESS @"api/getUnitPicsAddress" //站点监测图片列表接口
#define API_GETHISTORDATAMULTIINDEX @"api/getHistorDataMultiIndex" //站点浓度监测历史接口
#define API_GETHISTORYVIOLATIONPICTURE @"api/getHistoryViolationPicture"//站点历史违规图片

#endif /* ApiConfig_h */
