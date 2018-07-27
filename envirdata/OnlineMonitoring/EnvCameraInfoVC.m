//
//  EnvCameraInfoVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/14.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvCameraInfoVC.h"
#import "CameraInfoModel.h"
#import "NewUnitPicHourDataModel.h"
#import "ListView.h"
#import "HourDataView.h"
#import "HistoryDataMultIndexVC.h"
#import "HistoryViolationPictureVC.h"
#import "GKPhotoBrowser.h"
#import "GKCover.h"
#import "AddTaskViewController.h"
//海康威视
#import "Mcu_sdk/RealPlayManager.h"
#import "Mcu_sdk/RealPlayManagerEx.h"
#import "Mcu_sdk/VPCaptureInfo.h"
#import "Mcu_sdk/VPRecordInfo.h"
#import "PlayView.h"
#import "DealPalyView.h"
#import "PointWarnVC.h"
#import "AddPatrolTasksVC.h"
#import "MUnitModel.h"
static dispatch_queue_t video_intercom_queue() {
    static dispatch_queue_t url_request_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        url_request_queue = dispatch_queue_create("voice.intercom.queue", DISPATCH_QUEUE_SERIAL);
    });
    
    return url_request_queue;
}

@interface EnvCameraInfoVC ()<GKPhotoBrowserDelegate,DealPalyViewDelegate,RealPlayManagerDelegate,RealPlayManagerExDelegate>
{
    PlayView * g_playView;/**< 播放块*/
    DealPalyView *deal_playView;/**< 处理播放*/
    UIButton *g_topBtn;
    UIImageView *g_nopalyImageView;
    RealPlayManager *g_playMamager;/**<  预览管理类对象*/
    RealPlayManagerEx *g_playManagerEx;
    UIActivityIndicatorView *g_activity;
    VP_STREAM_TYPE  g_currentQuality;/**< 当前播放码流*/
}
@property (nonatomic,strong)UIScrollView *mainScr;
@property (nonatomic,strong)NSArray *unitAry;
@property (nonatomic,strong)ListView *unameview;
@property (nonatomic,strong)ListView *manageview;
@property (nonatomic,strong)ListView *linkPhoneview;
@property (nonatomic,strong)ListView *onlineStates;
@property (nonatomic,strong)UIView *hourView;
@property (nonatomic, weak) UIView *actionSheet;
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, assign) BOOL isLandspace;
@property (nonatomic,strong)NSString *navname;
@property (nonatomic,strong)CameraInfoModel *carmeraInfo;
@end

@implementation EnvCameraInfoVC
@synthesize uid,u_type,coordinate;
@synthesize mainScr,unitAry;
@synthesize unameview,manageview,linkPhoneview,onlineStates,hourView,navname,carmeraInfo;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor colorWithRGB:0xedeeef]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    navname=self.title;
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame =CGRectMake(0,0, 60, 44);
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    but.titleLabel.font=Font(16);
    [but addTarget:self action:@selector(gotoNav) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:@"导航"forState:UIControlStateNormal];
    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc]initWithCustomView:but];
    self.navigationItem.rightBarButtonItem = barBut;
    
    mainScr=[[UIScrollView alloc]init];
    mainScr.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:mainScr];
    __weak __typeof(self) weakSelf = self;//这里用一个弱引用来表示self，用于下面的Block中
    //先确定view_1的约束
    [mainScr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    UIView *camerInfoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALE(40)*4)];
    [mainScr addSubview:camerInfoView];
    
    unameview=[[ListView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALE(40)) name:@"站点地址：" value:@""];
    [camerInfoView addSubview:unameview];

    manageview=[[ListView alloc]initWithFrame:CGRectMake(0, unameview.bottom, SCREEN_WIDTH, SCALE(40)) name:@"管理员：" value:@""];
    [camerInfoView addSubview:manageview];
    
    linkPhoneview=[[ListView alloc]initWithFrame:CGRectMake(0, manageview.bottom, SCREEN_WIDTH, SCALE(40)) name:@"联系电话：" value:@""];
    [camerInfoView addSubview:linkPhoneview];
    
    onlineStates=[[ListView alloc]initWithFrame:CGRectMake(0, linkPhoneview.bottom, SCREEN_WIDTH, SCALE(40)) name:@"设备状态：" value:@""];
    [camerInfoView addSubview:onlineStates];
    
    hourView =[[UIView alloc]initWithFrame:CGRectMake(0, camerInfoView.bottom+5, SCREEN_WIDTH, SCALE(40))];
    [mainScr addSubview:hourView];
    
    //创建视频
    g_playView = [[PlayView alloc]initWithFrame:CGRectMake(SCALE(10), 0, SCREEN_WIDTH-SCALE(20), SCALE(200))];
    g_playView.hidden=YES;
    [g_playView setBackgroundColor:[UIColor blackColor]];
    [mainScr addSubview:g_playView];
    
    deal_playView =[[DealPalyView alloc]initWithFrame:g_playView.frame];
    deal_playView.delegate=self;
    deal_playView.hidden=YES;
    [deal_playView setBackgroundColor:[UIColor clearColor]];
    [mainScr addSubview:deal_playView];
    
    g_activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    g_activity.hidesWhenStopped = YES;
    g_activity.center=CGPointMake(g_playView.width/2.0, g_playView.height/2.0);
    [deal_playView addSubview:g_activity];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRealPlay) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetRealPlay) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self getCameraInfo];
    // Do any additional setup after loading the view.
}
#pragma mark--------------根据站点获取摄像头信息-----------
-(void)getCameraInfo{
    [self networkPost:API_GETCAMERAINFO parameter:@{@"uid":uid} progresHudText:@"加载中..." completionBlock:^(id rep) {
        carmeraInfo =[CameraInfoModel mj_objectWithKeyValues:rep];
        unameview.valuelb.text=carmeraInfo.address;
        manageview.valuelb.text=carmeraInfo.manager;
        linkPhoneview.valuelb.text=carmeraInfo.phone;
        linkPhoneview.islink=YES;
        onlineStates.valuelb.text=[carmeraInfo.onlinestatus intValue]==0?@"离线":[carmeraInfo.onlinestatus intValue]==1?@"在线":@"未知";
        if ([carmeraInfo.address isNotBlank]) {
            navname=carmeraInfo.address;
        }
        //初始化数据
        g_playMamager = [[RealPlayManager alloc] initWithDelegate:self];
        g_playManagerEx = [[RealPlayManagerEx alloc] initWithDelegate:self];
        [g_activity startAnimating];
        g_currentQuality = STREAM_SUB;
        if ([carmeraInfo.syscode isNotBlank]&&[carmeraInfo.onlinestatus intValue]!=0) {//有sysCode 并且不处于离线状态
            [g_playMamager startRealPlay:carmeraInfo.syscode videoType:g_currentQuality playView:g_playView complete:^(BOOL finish, NSString *message) {
                if (finish) {
                    NSLog(@"调用预览成功%@", message);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [g_activity stopAnimating];
                         deal_playView.isPausing=YES;
                    });
                } else {
                    NSLog(@"调用预览失败 %@",message);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [g_activity stopAnimating];
                        deal_playView.isPausing=NO;
                    });
                }
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [g_activity stopAnimating];
                 deal_playView.isPausing=NO;
                [self showMsgInfo:@"设备离线,无法使用视频！"];
            });
        }
    }];
    [self networkPost:API_GETNEWUNITPICHOURDATA parameter:@{@"uid":uid,@"unit_type":[u_type numberValue]} progresHudText:@"加载中..." completionBlock:^(id rep) {
        unitAry =[NewUnitPicHourDataModel mj_objectArrayWithKeyValuesArray:rep];
    
        float temph=0.0;
        for (int i=0; i<unitAry.count; i++) {
            NewUnitPicHourDataModel *newunit=unitAry[i];
            NSString * name= @"";
            if ([newunit.type intValue]==1) {
                if ([newunit.value isNotBlank]) {
                     name=[NSString stringWithFormat:@"%@ %@",newunit.value,newunit.remark];
                }else{
                    name=@"--";
                }
            }else if ([newunit.type intValue]==2&&[newunit.value isNotBlank]){
                name=@"异常";
            }else{
                name=@"正常";
            }
            HourDataView *hourDataView =[[HourDataView alloc]initWithFrame:CGRectMake(0, i*SCALE(40), hourView.width, SCALE(40)) name:newunit.name value:name];
            hourDataView.tag=1000+i;
            hourDataView.userInteractionEnabled=YES;
            [hourDataView bk_whenTapped:^{
                NSLog(@"%@",[newunit mj_JSONString]);
                if ([newunit.type intValue]==1) {//查看历史
                    HistoryDataMultIndexVC *historyData=[[HistoryDataMultIndexVC alloc]init];
                    historyData.title=[NSString stringWithFormat:@"%@历史记录",self.title];
                    historyData.utype=u_type;
                    historyData.uid=uid;
                    [self.navigationController pushViewController:historyData animated:YES];
                }else if ([newunit.type intValue]==2&&[newunit.value isNotBlank]){//查看异常图片
                    NSArray *urlAry  = [newunit.value componentsSeparatedByString:@","];
                    if (urlAry.count>0) {
                        NSMutableArray *photos = [NSMutableArray new];
                        [urlAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            GKPhoto *photo = [GKPhoto new];
                            photo.url = [NSURL URLWithString:obj];
                            [photos addObject:photo];
                        }];
                        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
                        browser.delegate=self;
                        browser.showStyle = GKPhotoBrowserShowStyleNone;
                        [browser showFromVC:self];
                    }
                }
            }];
            [hourView addSubview:hourDataView];
            temph=hourView.bottom;
        }
        hourView.height=unitAry.count*SCALE(40);
        //历史违规
         HourDataView *hourDataView =[[HourDataView alloc]initWithFrame:CGRectMake(0, hourView.bottom+5, hourView.width, SCALE(40)) name:@"历史违规" value:@"详情》"];
        hourDataView.userInteractionEnabled=YES;
        [hourDataView bk_whenTapped:^{
            HistoryViolationPictureVC * histroy=[[HistoryViolationPictureVC alloc]init];
            histroy.uid=uid;
            histroy.title=@"历史违规";
            [self.navigationController pushViewController:histroy animated:YES];
        }];
        [mainScr addSubview:hourDataView];
        g_playView.hidden=NO;
        deal_playView.hidden=NO;
        deal_playView.top=hourDataView.bottom+10;
        g_playView.top=hourDataView.bottom+10;
        [mainScr setContentSize:CGSizeMake(mainScr.width, g_playView.bottom+20)];
    }];
}
- (void)photoBrowser:(GKPhotoBrowser *)browser longPressWithIndex:(NSInteger)index {
    NSLog(@"%@",browser.photos[index]);
    if (self.fromView) return;
    UIView *contentView = browser.contentView;
    UIView *fromView = [UIView new];
    fromView.backgroundColor = [UIColor clearColor];
    self.fromView = fromView;
    CGFloat actionSheetH = 0;
    if (self.isLandspace) {
        actionSheetH = 100;
        fromView.frame = contentView.bounds;
        [contentView addSubview:fromView];
    }else {
        actionSheetH = 100 + kSaveBottomSpace;
        fromView.frame = browser.view.bounds;
        [browser.view addSubview:fromView];
    }
    
    UIView *actionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, actionSheetH)];
    actionSheet.backgroundColor = [UIColor whiteColor];
    self.actionSheet = actionSheet;
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, actionSheet.width, 50)];
    [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn bk_addEventHandler:^(id sender) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            GKPhoto *photo =  browser.photos[index];
            UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    } forControlEvents:UIControlEventTouchUpInside];
    
    saveBtn.backgroundColor = [UIColor whiteColor];
    [actionSheet addSubview:saveBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, actionSheet.width, 50)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn bk_addEventHandler:^(id sender) {
        [GKCover hideCover];
    } forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [actionSheet addSubview:cancelBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, actionSheet.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [actionSheet addSubview:lineView];
    
    [GKCover coverFrom:fromView
           contentView:actionSheet
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
         showAnimStyle:GKCoverShowAnimStyleBottom
         hideAnimStyle:GKCoverHideAnimStyleBottom
              notClick:NO
             showBlock:nil
             hideBlock:^{
                 [self.fromView removeFromSuperview];
                 self.fromView = nil;
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
    }
    [GKCover hideCover];
}
#pragma mark------------进入导航--------
-(void)gotoNav{
    
    WEAKSELF
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"苹果自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf appleNaiWithCoordinate:coordinate andWithMapTitle:navname];
        
    }]];
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
           [weakSelf aNaviWithCoordinate:coordinate andWithMapTitle:navname];
            
        }]];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"alertController -- 百度地图");
            [weakSelf baiduNaviWithCoordinate:coordinate andWithMapTitle:navname];
            
        }]];
    }
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
//唤醒苹果自带导航
- (void)appleNaiWithCoordinate:(CLLocationCoordinate2D)coordinate andWithMapTitle:(NSString *)map_title{
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *tolocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    tolocation.name = map_title;
    [MKMapItem openMapsWithItems:@[currentLocation,tolocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                               MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
}
/**
 高德导航
 */
- (void)aNaviWithCoordinate:(CLLocationCoordinate2D)coordinate andWithMapTitle:(NSString *)map_title{
    
    NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",coordinate.latitude,coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:urlsting]];
}

- (void)baiduNaviWithCoordinate:(CLLocationCoordinate2D)coordinate andWithMapTitle:(NSString *)map_title{
    NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude,coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
}
#pragma mark------------开始云台控制---------
-(void)deal_ptzOperationInControl:(int)ptzCommand stop:(BOOL)stop end:(BOOL)end
{
    if (end) {
        [g_playMamager stopPtzControl:ptzCommand withParam1:5];
        
    }else{
        [g_playMamager startPtzControl:ptzCommand withParam1:5];
    }
}
-(void)deal_playrefreshRealPlay{
    [self refreshRealPlay];
}
-(void)deal_capture{
    [self capture];
}
-(void)deal_pausing:(BOOL)isplay{
    if (isplay==NO) {//NO 表示暂停
        if (g_playView.isTalking) {
            dispatch_async(dispatch_get_main_queue(), ^{
                g_playView.isTalking = NO;
            });
            //停止对讲
            dispatch_async(video_intercom_queue(), ^{
                [g_playMamager stopTalking];
            });
        }
        BOOL result = [g_playMamager stopRealPlay];
        if (result) {
            deal_playView.isPausing=NO;
            NSLog(@"停止成功");
        } else {
            NSLog(@"停止失败");
        }
    }else{
        [self refreshRealPlay];
    }
}



#pragma mark - RealPlayManagerDelegate播放库预览状态回调代理方法和语音对讲回调
/**
 播放库预览状态回调
 
 用户可通过播放库返回的不同播放状态进行自己的业务处理
 
 @param playState 当前播放状态
 @param realPlayManager 预览管理类
 */
- (void)realPlayCallBack:(PLAY_STATE)playState realManager:(RealPlayManager *)realPlayManager {
    [g_activity stopAnimating];
    switch (playState) {
        case PLAY_STATE_PLAYING: {//正在播放
            NSLog(@"playing");
            break;
        }
        case PLAY_STATE_STOPED: {//停止播放
            NSLog(@"stoped");
            //g_refreshButton.hidden = NO;
            break;
        }
        case PLAY_STATE_STARTED: {//开始播放
            NSLog(@"started");
            break;
        }
        case PLAY_STATE_FAILED: {//播放失败
            NSLog(@"failed");
            [g_activity stopAnimating];
            deal_playView.isPausing=NO;
            break;
        }
        case PLAY_STATE_EXCEPTION: {//播放异常
            NSLog(@"exception");
            [g_activity stopAnimating];
            deal_playView.isPausing=NO;
            break;
        }
        default:
            break;
    }
}
#pragma mark -- RealPlayManagerExDelegate播放库预览状态回调代理方法和语音对讲回调
- (void)realPlayCallBackEx:(PLAY_STATE)playState realManager:(RealPlayManagerEx *)realPlayManager  {
    [g_activity stopAnimating];
    switch (playState) {
        case PLAY_STATE_PLAYING: {//正在播放
            NSLog(@"playing");
            break;
        }
        case PLAY_STATE_STOPED: {//停止播放
            NSLog(@"stoped");
            //g_refreshButton.hidden = NO;
            break;
        }
        case PLAY_STATE_STARTED: {//开始播放
            NSLog(@"started");
            break;
        }
        case PLAY_STATE_FAILED: {//播放失败
            NSLog(@"failed");
            //g_refreshButton.hidden = NO;
            break;
        }
        case PLAY_STATE_EXCEPTION: {//播放异常
            NSLog(@"exception");
            //g_refreshButton.hidden = NO;
            break;
        }
        default:
            break;
    }
}
//- (void)ptzPresetPositionOperation:(int)command index:(int)index {
//    if (g_ptzPanel.isPanAutoState) {
//        [g_playMamager stopPtzControl:29 withParam1:5];
//        g_ptzPanel.isPanAutoState = NO;
//    }
//    [g_playMamager startPtzControl:command withParam1:index];
//}


//程序变为活跃状态时,重新开始预览
- (void)resetRealPlay {
    [self refreshRealPlay];
}
//程序进入后台时,停止预览操作
- (void)stopRealPlay {
    //如果在进行对讲操作,请关闭对讲
    if (g_playView.isTalking) {
        dispatch_async(dispatch_get_main_queue(), ^{
            g_playView.isTalking = NO;
        });
        //停止对讲
        dispatch_async(video_intercom_queue(), ^{
            [g_playMamager stopTalking];
        });
    }
    BOOL result = [g_playMamager stopRealPlay];
    if (result) {
        deal_playView.isPausing=NO;
        NSLog(@"停止成功");
    } else {
        NSLog(@"停止失败");
    }
    
}
#pragma mark --重新预览
/**
 重新预览 就是重新调用开始预览的方法
 */
- (void)refreshRealPlay {
    g_activity.hidden = NO;
    [g_activity startAnimating];
    if ([carmeraInfo.syscode isNotBlank]&&[carmeraInfo.onlinestatus intValue]!=0) {
        [g_playMamager startRealPlay:carmeraInfo.syscode videoType:STREAM_SUB playView:g_playView complete:^(BOOL finish,NSString *message) {
            if (finish) {
                NSLog(@"调用预览成功");
#warning 刷新UI必须在主线程操作
                dispatch_async(dispatch_get_main_queue(), ^{
                    [g_activity stopAnimating];
                    deal_playView.isPausing=YES;
                });
            } else {
                NSLog(@"调用预览失败 %@",message);
#warning 刷新UI必须在主线程操作
                dispatch_async(dispatch_get_main_queue(), ^{
                    [g_activity stopAnimating];
                    deal_playView.isPausing=NO;
                });
            }
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [g_activity stopAnimating];
            deal_playView.isPausing=NO;
            [self showMsgInfo:@"设备离线,无法使用视频！"];
        });
    }
}

#pragma mark---------抓取截图--------
- (void)capture {
#warning 录像和截图操作不能同时进行
    //1.创建一个抓图信息VPCaptureInfo对象
    VPCaptureInfo *captureInfo = [[VPCaptureInfo alloc] init];
    //2.生成抓图信息
    //此处参数 camera01 是用户自定义参数,可传入监控点名称,用作在截图成功后,拼接在图片名称的前部.如:camera01_20170302202334565.jpg
    if (![VideoPlayUtility getCaptureInfo:@"camera01" toCaptureInfo:captureInfo]) {
        NSLog(@"getCaptureInfo failed");
        return;
    }
    // 3.设置抓图质量 1-100 越高质量越高
    captureInfo.nPicQuality = 80;
    //4.开始抓图
    BOOL result = [g_playMamager capture:captureInfo];
    if (result) {
        NSLog(@"截图成功，图片路径:%@",captureInfo.strCapturePath);
        NSData * data = [NSData dataWithContentsOfFile:captureInfo.strCapturePath];
        UIImage *image =[UIImage imageWithData:data];
        WEAKSELF
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"发起任务" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //判断类型
            NSArray *menuAry = USER_DEFAULTS(@"menuInfo");
            BOOL isglxt1 = [menuAry bk_match:^BOOL(NSDictionary *itemobj) {
                if ([itemobj[@"mark"] isEqualToString:@"glxt1"]) {
                    return YES;
                }else{
                    return NO;
                }
            }];
            if(isglxt1==YES){
                AddTaskViewController *addTaskVc=[[AddTaskViewController alloc]init];
                addTaskVc.title=@"发起任务";
                addTaskVc.kind=@"1";
                addTaskVc.pricrAry=[NSMutableArray arrayWithObject:image];
                [weakSelf.navigationController pushViewController:addTaskVc animated:YES];
            }else{
                AddPatrolTasksVC *addpatrol=[[AddPatrolTasksVC alloc]init];
                addpatrol.title=@"现场巡查";
                addpatrol.isChoose=YES;
                addpatrol.unitModel=[MUnitModel mj_objectWithKeyValues:[carmeraInfo mj_JSONString]];
                addpatrol.pricrAry=[NSMutableArray arrayWithObject:image];
                [weakSelf.navigationController pushViewController:addpatrol animated:YES];
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"添加站点警告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            PointWarnVC *pointWarn=[[PointWarnVC alloc]init];
            pointWarn.pointImage=image;
            pointWarn.pointName=carmeraInfo.uname;
            pointWarn.uid=carmeraInfo.uid;
            pointWarn.title=@"新增站点警告";
            [weakSelf.navigationController pushViewController:pointWarn animated:YES];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        NSLog(@"截图失败");
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRealPlay];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
