//
//  VideoPlaySDK.h
//  PlayViewWork
//
//  Created by Dengsh on 13-10-17.
//  Copyright (c) 2013年 chenmengyu. All rights reserved.
//

#ifndef PlayViewWork_VideoPlaySDK_h
#define PlayViewWork_VideoPlaySDK_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C"
{
#endif

#define  VIDEOPLAYSDKAPI

@class VideoPlayInfo;
@class VPCaptureInfo;
@class VPRecordInfo;

/******************************************************************************/
// 宏
/******************************************************************************/
#define VP_HANDLE void *
#define CALLBACK

/******************************************************************************/
// 枚举
/******************************************************************************/
/**
 *	@brief	取流协议类型
 */
typedef enum _PROTOCAL_TYPE
{
    PROTOCAL_TCP = 0,                                                           /**< 取流采用TCP */
    PROTOCAL_UDP = 1,                                                           /**< 取流采用UDP */
}PROTOCAL_TYPE;

/**
 *	@brief	主子码流
 */
typedef enum _VP_STREAM_TYPE
{
    STREAM_MAIN = 0,                                                            /**< 主码流 */
    STREAM_SUB  = 1,                                                            /**< 子码流 */
    STREAM_MAG  = 2,                                                            /**< MAG   */
}VP_STREAM_TYPE;

/**
 *	@brief	取流方式
 */
typedef enum _STREAM_METHOD
{
    STREAM_METHOD_AUTO = 0,                                                     /**< 取流方式，自动 */
    STREAM_METHOD_VTDU = 1,                                                     /**< 取流方式，从流媒体，目前只支持从流媒体 */
    STREAM_METHOD_LOCAL = 2,                                                    /**< 取流方式，从本地文件 */
}STREAM_METHOD;

/**
 *	@brief	播放模式，实时预览或者远程回放
 */
typedef enum _PLAY_TYPE
{
    REAL_PLAY = 0,                                                              /**< 实时预览 */
    PLAY_BACK = 1,                                                              /**< 远程回放 */
}PLAY_TYPE;

/**
 *	@brief	播放状态
 */
typedef enum _PLAY_STATE
{
    PLAY_STATE_PLAYING      = 0,                                                /**< 正在播放 */
    PLAY_STATE_STOPED       = 1,                                                /**< 停止播放 */
    PLAY_STATE_STARTED      = 2,                                                /**< 开始播放 */
    PLAY_STATE_FAILED       = 3,                                                /**< 播放失败 */
    PLAY_STATE_PAUSE        = 4,                                                /**< 播放暂停 仅在远程回放暂停后*/
    PLAY_STATE_EXCEPTION    = 5,                                                /**< 播放异常（默认30秒未来流） */
}PLAY_STATE;

/**
 *	@brief	数据类型
 */
typedef enum _STREAM_DATA_TYPE
{
    DATA_HEAD = 0,                                                              /**< 数据头 */
    DATA_BODY = 1,                                                              /**< 数据 */
}STREAM_DATA_TYPE;

/**
 *	@brief	时间
 */
typedef struct _TIME_STRUCT
{
    unsigned int dwYear;                                                        /**< 年 */
	unsigned int dwMonth;                                                       /**< 月 */
	unsigned int dwDay;                                                         /**< 日 */
	unsigned int dwHour;                                                        /**< 时 */
	unsigned int dwMinute;                                                      /**< 分 */
	unsigned int dwSecond;                                                      /**< 秒 */
}TIME_STRUCT;

/**
 鱼眼安装类型
 
 - VPFishEyePlaceTypeNone: 不矫正
 - VPFishEyePlaceTypeWall: 壁装（法线水平）
 - VPFishEyePlaceTypeFloor: 地面安装（法线向上）
 - VPFishEyePlaceTypeCeiling: 顶装方式（法线向下）
 */
typedef NS_ENUM(int, VPFishEyePlaceType)
{
    VPFishEyePlaceTypeNone = 0x0,
    VPFishEyePlaceTypeWall = 0x1,
    VPFishEyePlaceTypeFloor = 0x2,
    VPFishEyePlaceTypeCeiling = 0x3
};

/**
 鱼眼矫正类型
 
 - VPFishEyeCorrectTypePTZ: PTZ
 - VPFishEyeCorrectType180: 180度矫正（对于2P）
 - VPFishEyeCorrectType360: 360度矫正（对应1P）
 - VPFishEyeCorrectTypeLat: 纬度拉伸
 */
typedef NS_ENUM(int, VPFishEyeCorrectType) {
    VPFishEyeCorrectTypePtz = 0x100,
    VPFishEyeCorrectType180 = 0x200,
    VPFishEyeCorrectType360 = 0x300,
    VPFishEyeCorrectTypeLat = 0x400
};
    
/******************************************************************************/
// 回调函数
/******************************************************************************/
// 数据回调函数
typedef void (CALLBACK *fDataCallBack)(STREAM_DATA_TYPE dataType, unsigned char *pBuffer, unsigned int nBufSize);
// 状态回调函数
typedef void (CALLBACK *fStatusCallBack)(PLAY_STATE playState, VP_HANDLE hLogin, void *pHandl);

/******************************************************************************/
// VIDEOPLAYSDK_ERROR
/******************************************************************************/
#define VIDEOPLAYSDK_ERROR_STREAMMETHOD         10001                           /**< 错误或者未知的取流方式 */
#define VIDEOPLAYSDK_ERROR_HANDLE               10002                           /**< 视频播放句柄错误 */
#define VIDEOPLAYSDK_ERROR_NOT_PLAYING          10003                           /**< 当前未播放 */
#define VIDEOPLAYSDK_ERROR_PLAYER_HANDLE        10004                           /**< 当前播放库句柄错误 */
#define VIDEOPLAYSDK_ERROR_FILE_HANDLE          10005                           /**< 文件操作句柄错误 */
#define VIDEOPLAYSDK_ERROR_MALLOC_BUFF          10006                           /**< malloc内存错误 */
#define VIDEOPLAYSDK_ERROR_LOGINID              10007                           /**< loginid错误 */
#define VIDEOPLAYSDK_ERROR_CREATE_FOLDER        10008                           /**< 创建文件夹失败 */
#define VIDEOPLAYSDK_ERROR_WRITE_FILE           10009                           /**< 写文件失败 */
#define VIDEOPLAYSDK_ERROR_SYSTRANSFORM         10010                           /**< 转封装失败 */
#define VIDEOPLAYSDK_ERROR_OPEN_FILE            10011                           /**< 打开文件失败 */
#define VIDEOPLAYSDK_ERROR_FILE_PATHE           10012                           /**< 文件路径错误 */
#define VIDEOPLAYSDK_ERROR_VIDEOPLAYINFO_NULL   10013                           /**< 播放信息为空 */
#define VIDEOPLAYSDK_ERROR_CALLBACK_NULL        10014                           /**< 回调方法为空 */
#define VIDEOPLAYSDK_ERROR_PLAYVIEW_NULL        10015                           /**< 播放窗口为空 */
#define VIDEOPLAYSDK_ERROR_CAPTURE_RECORD_INFO  10016                           /**< 抓图或者录像信息为空 */
#define VIDEOPLAYSDK_ERROR_DELETE_FILE          10017                           /**< 删除文件失败 */
#define VIDEOPLAYSDK_ERROR_CAMERAID_NULL        10018                           /**< cameraID为空 */

/******************************************************************************/
// 接口
/******************************************************************************/
/**
 *	@brief	初始化sdk
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_InitSDK(void);

/**
 *	@brief	反初始化sdk
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_ClearSDK(void);

/**
 *	@brief	登录
 *
 *	@param  videoInfo 播放信息
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI VP_HANDLE VP_Login(VideoPlayInfo *videoInfo);

/**
 *	@brief	登出
 *
 *	@param 	hLogin 	播放句柄
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_Logout(VP_HANDLE hLogin);

/**
 *	@brief	设置状态回调方法
 *
 *	@param 	hLogin 	播放句柄
 *	@param 	fStatusCallBackFun  状态回调函数指针
 *	@param 	pHandl            使用状态回调的对象
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_SetStatusCallBack(VP_HANDLE hLogin, fStatusCallBack fStatusCallBackFun, void *pHandl);

/**
 *	@brief	开启预览
 *
 *	@param 	hLogin 	播放句柄
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_RealPlay(VP_HANDLE hLogin);

/**
 *	@brief	开启远程回放
 *
 *	@param 	hLogin 	播放句柄
 *	@param 	fStartTime 	回放开始时间
 *	@param 	fStopTime 	回放结束时间
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_PlayBack(VP_HANDLE hLogin, NSTimeInterval fStartTime, NSTimeInterval fStopTime);

/**
 *	@brief	停止播放
 *
 *	@param 	hLogin 	播放句柄
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_StopPlay(VP_HANDLE hLogin);

/**
 *  开启本地录像播放
 *
 *  @param hLogin 播放句柄
 *
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_StartPlayRecord(VP_HANDLE hLogin);

/**
 *  停止本地录像播放
 *
 *  @param hLogin 播放句柄
 *
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_StopPlayRecord(VP_HANDLE hLogin);

/**
 *	@brief	暂停回放
 *
 *	@param 	hLogin 	播放句柄
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_PausePlayBack(VP_HANDLE hLogin);

/**
 *	@brief	重新启动回放
 *
 *	@param 	hLogin 	播放句柄
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_ResumePlayBack(VP_HANDLE hLogin);

/**
 *	@brief	抓图
 *
 *	@param 	hLogin 	播放句柄
 *	@param 	captureInfo 	抓图信息
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_Capture(VP_HANDLE hLogin, VPCaptureInfo *captureInfo);

/**
 *	@brief	开始录像
 *
 *	@param 	hLogin 	播放句柄
 *	@param 	recrodInfo 	录像信息
 *	@param 	bSystransform 	是否开启转封装
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_StartRecord(VP_HANDLE hLogin, VPRecordInfo *recrodInfo, bool bSystransform);

/**
 *	@brief	结束录像
 *
 *	@param 	hLogin 	播放句柄   
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_StopRecord(VP_HANDLE hLogin);

/**
 *	@brief	设置声音开启关闭
 *
 *	@param 	hLogin 	播放句柄
 *	@param 	bOpen 	true 开启 false 关闭
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_AudioCtrl(VP_HANDLE hLogin, bool bOpen);

/**
 *	@brief	设置音量
 *
 *	@param 	hLogin 	播放句柄
 *	@param 	nVolume 	true 开启 false 关闭
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_SetVolume(VP_HANDLE hLogin, unsigned int nVolume);

/**
 *	@brief	获取osd时间
 *
 *	@param 	hLogin 	播放句柄
 *
 *	@return	osd时间，以秒计算
 */
VIDEOPLAYSDKAPI long VP_GetOsdTime(VP_HANDLE hLogin);

/**
 *	@brief	获取数据大小
 *
 *	@param 	hLogin 	播放句柄
 *
 *	@return	数据长度
 */
VIDEOPLAYSDKAPI long VP_GetDataSize(VP_HANDLE hLogin);

/**
 *	@brief	获取播放状态
 *
 *	@param 	hLogin 	播放句柄
 *
 *	@return	播放状态
 */
VIDEOPLAYSDKAPI PLAY_STATE VP_GetPlayState(VP_HANDLE hLogin);
    
/**
 *	@brief	获取视频分辨率
 *
 *	@param 	hLogin 	播放句柄
 *	@param 	nWidth 	宽
 *	@param 	nHeight 	高
 *
 *	@return	true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_GetVideoSize(VP_HANDLE hLogin, unsigned int * nWidth, unsigned int * nHeight);

/**
 *  @brief 获取文件总时间
 *
 *  @param hLogin 播放句柄
 *
 *  @return 文件总时间
 */
VIDEOPLAYSDKAPI unsigned int VP_GetFileTotleTime(VP_HANDLE hLogin);

/**
 *  @brief 获取文件已经播放的时间
 *
 *  @param hLogin 播放句柄
 *
 *  @return 文件已经播放的时间
 */
VIDEOPLAYSDKAPI unsigned int VP_GetFilePlayedTime(VP_HANDLE hLogin);
   
    
/**
 *  @brief 设置文件播放位置
 *
 *  @param hLogin 播放句柄 playPercentage 当前播放百分比的位置
 *
 *  @return 0 失败 非0成功
 */
VIDEOPLAYSDKAPI unsigned int VP_SetFilePlayedPercentage(VP_HANDLE hLogin,float playPercentage);

/**
 *  @brief 设置文件播放位置
 *
 *  @param hLogin 播放句柄 playTime 要播放的时间
 *
 *  @return 0 失败 非0成功
 */
VIDEOPLAYSDKAPI unsigned int VP_SetFilePlayedTime(VP_HANDLE hLogin,unsigned int playTime);
    
/**
 *	@brief	获取错误码
 *
 *	@param 	hLogin 	播放句柄
 *
 *	@return	true 开启 false 关闭
 */
VIDEOPLAYSDKAPI long VP_GetLastError(VP_HANDLE hLogin);

/**
 *	@brief	获取SDK版本
 *
 *	@return	当前SDK版本号
 */
VIDEOPLAYSDKAPI NSString* VP_GetVersion();

/**
 *	@brief	获取是否启用硬解
 *
 *	@return	返回解码类型。1-软解 2-硬解 0-错误
 */
VIDEOPLAYSDKAPI int VP_GetDecodeEngine(VP_HANDLE hLogin);
    
// 以下接口为新增接口支持电子放大、录像回放快进快退、鱼眼设备矫正，SDK版本号为V1.0 build20170524

/**
 *  @brieft 获得码流分辨率
 *  @param hLogin 播放句柄
 *  @param pWidth 宽
 *  @param pHeight 高
 *  @return true 开启 false 关闭
 */
VIDEOPLAYSDKAPI bool VP_GetPictureSize(VP_HANDLE hLogin, int *pWidth, int *pHeight);

/**
 *  @brief	电子放大设置播放区域
 *  @param hLogin 播放句柄
 *  @param rect 播放区域
 *  @return	true 开启 false 关闭
 */
VIDEOPLAYSDKAPI bool VP_SetDisplayRegion(VP_HANDLE hLogin, CGRect rect);

/**
 *  @brief 回放快进
 *  @param hLogin 播放句柄
 *  @param speedTimes 速度的倍率
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_PlayBackFast(VP_HANDLE hLogin, unsigned int speedTimes);

/**
 *  @brief 回放慢进
 *  @param hLogin 播放句柄
 *  @param speedTimes 速度的倍率
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_PlayBackSlow(VP_HANDLE hLogin, unsigned int speedTimes);

/**
 *  @brief 开启鱼眼矫正
 *  @param hLogin 播放句柄
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_FishEyeCorrectEnable(VP_HANDLE hLogin);

/**
 *  @brief 关闭鱼眼矫正
 *  @param hLogin 播放句柄
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_FishEyeCorrectDisable(VP_HANDLE hLogin);

/**
 *  @brief 获取鱼眼矫正子端口
 *  @param hLogin 播放句柄
 *  @param placeType 安装类型
 *  @param correctType 矫正类型
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_FishEyeCorrectGetSubPort(VP_HANDLE hLogin, VPFishEyePlaceType placeType, VPFishEyeCorrectType correctType);

/**
 *  @brief 删除鱼眼矫正子端口
 *  @param hLogin 播放句柄
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_FishEyeCorrectDeleteSubPort(VP_HANDLE hLogin);

/**
 *  @brief 设置鱼眼矫正展示视图
 *  @param hLogin 播放句柄
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_FishEyeCorrectSetDisplayView(VP_HANDLE hLogin);

/**
 *  @brief 设置ptz云台端口
 *  @param hLogin 播放句柄
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_FishEyeCorrectSetCurrentPtzPort(VP_HANDLE hLogin);

/**
 *  @brief 获取ptz端口
 *  @param hLogin 播放句柄
 *  @param point ptz操作开始点击的点
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_FishEyeCorrectGetCurrentPtzPort(VP_HANDLE hLogin, CGPoint point);

/**
 *  @brief 获取ptz矫正参数
 *  @param hLogin 播放句柄
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_FishEyeCorrectGetPtzCorrectParam(VP_HANDLE hLogin);

/**
 *  @brief ptz方向矫正
 *  @param hLogin 播放句柄
 *  @param ptzRefWnd ptz点击开始时的点
 *  @param ptzWnd ptz滑动后的点
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_FishEyeCorrectPtzDirectionCorrect(VP_HANDLE hLogin, CGPoint ptzRefWnd, CGPoint ptzWnd);

/**
 *  @brief ptz放大矫正
 *  @param hLogin 播放句柄
 *  @param zoomIn 放大
 *  @return true 成功 false 失败
 */
VIDEOPLAYSDKAPI bool VP_FishEyeCorrectPtzZoomCorrect(VP_HANDLE hLogin, bool zoomIn);
    
#ifdef __cplusplus
}
#endif

#endif
