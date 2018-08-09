//
//  ApiConfig.h
//  envirdata
//
//  Created by 熊佳佳 on 18/7/10.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#ifndef ApiConfig_h
#define ApiConfig_h

//#define HOST_API @"http://139.159.243.179:22816/"
//#define BASE_API  @"http://139.159.243.179:22816/app/"


#define HOST_API @"http://ios.grand-tech.com.cn:22816/"
#define BASE_API  @"http://ios.grand-tech.com.cn:22816/app/"


//#define HOST_API @"http://192.168.0.226:8080/"
//#define BASE_API  @"http://192.168.0.226:8080/app/"

#define API_CHECKUSER @"api/checkUser"  //登录接口
#define API_BINDDEVICE @"api/bindDevice" //绑定设备号
#define FILE_UPLOADING @"uploadImg" //图片上传
#define API_GETMENU @"api/getMenu" //获取功能模块

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
#define API_ADDBURNPOINT @"api/addBurnPoint" //添加警告站点

//管理协同
#define API_GETMONITORTASKTREE3  @"api/getMonitorTaskTree3"
#define API_GETMONITORTASKLIST @"api/getMonitorTaskList" //任务列表
#define API_GETMONITORUSER @"api/getMonitorUser" //获取人员信息
#define API_GETREGIONTASKLIST @"api/getRegionTaskList" //区域内任务列表  //regionid
#define API_ADDMONITORTASK @"api/addMonitorTask"//添加任务
#define API_UPDMONITORTASK @"api/updMonitorTask" //处置任务
#define API_FINISHTASK @"api/finishTask"//任务销号处理

//管理协同2
#define API_GETPATROLTASKS @"api/getPatrolTasks" //移动巡查任务列表
#define API_GETCOMPLAINTTAKS @"api/getComplaintTasks" //监察任务列表
#define API_GETUNITLIST @"api/getUnitList"//获取站点信息
#define API_GETTYPEDESCIPT @"api/getTypeDescipt"//获取类型信息
#define API_GETBYAREAIDDEPARTMENTINFOS @"api/getByareaidDepartmentInfos"//获取单位信息
#define API_GETADDPATROLTASKS @"api/getAddPatrolTasks"//发起移动巡查任务接口
#define API_INSETCOMPLAINT @"api/insetComplaint"//新增投诉
#define API_HANDLEPATROLTASKS @"api/handlePatrolTasks"//处理任务
#define API_HANDLECOMPLAINT @"api/handleComplaint" //处理投诉
//GPS轨迹
#define API_GETTRACKID @"api/getTrackId"//请求轨迹ID
#define API_APPPIONT @"api/addPoints" //上传轨迹点
#define API_GETTRACKLIST @"api/getTrackList" //指定日期的轨迹列表
#define API_GETTRACKBYID @"api/getTrackById" //获取定位点
//分析报告
#define API_GETYESTERDAYCOUNT2 @"api/getYesterdayCount2"//昨日汇总
#define API_GETREPORTLIST @"api/getReportList" //分析报告
//个人中心
#define API_GETVERSION @"api/getVersion"//检测接口
#define API_GETFEEDBACKLIST @"api/getFeedbackList"//意见反馈列表
#define API_SUBMITFEEDBACK @"api/submitFeedback"//意见反馈接口
#define API_HANDBOOK @"static/handbook/沙坪坝区环境监控移动平台用户操作手册.html"

#endif /* ApiConfig_h */
