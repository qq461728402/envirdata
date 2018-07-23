//
//  AppDelegate.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/3.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "EnvTabBarController.h"
#import "LoginVC.h"
#import "ConfigObj.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <Mcu_sdk/MCUVmsNetSDK.h>
#import <Mcu_sdk/VideoPlaySDK.h>
#import "VersionModel.h"
@interface AppDelegate ()

@end
BMKMapManager* _mapManager;
@implementation AppDelegate
+ (AppDelegate *)Share
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ConfigObj configObj];
    //个推
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    //启动百度地图
    _mapManager = [[BMKMapManager alloc]init];
    
    BOOL ret = [_mapManager start:BaiduAK generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //海康威视
    //初始化
     VP_InitSDK();
    //MSP 的 IP 端口配置
    [[MCUVmsNetSDK shareInstance] configMspWithAddress:MSP_ADDRESS port:MSP_PORT];
    //登录接口
    [[MCUVmsNetSDK shareInstance] loginMspWithUsername:MSP_USERNAME password:[MSP_PASSWORD md5String] success:^(id object) {
        
    } failure:^(NSError *error) {
        
    }];
    // 注册 APNs
    [self registerRemoteNotification];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSDictionary *userInfo = USER_DEFAULTS(@"userInfo")
    if (userInfo) {
        [SingalObj defaultManager].trackid = USER_DEFAULTS(@"trackid");
        //存储用户信息
        UserInfoModel *userInfoModel =[UserInfoModel mj_objectWithKeyValues:userInfo];
        [SingalObj defaultManager].userInfoModel=userInfoModel;
        [self gotohome];
    }else{
        [self gotologin];
    }
    [self getvison];
    [self getTrackId];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}
-(void)gotologin{
    LoginVC *loginvc =[[LoginVC alloc]init];
    self.window.rootViewController=loginvc;
}
-(void)gotohome{
    EnvTabBarController *tabbar=[[EnvTabBarController alloc]init];
    UINavigationController *tab_nav=[[UINavigationController alloc]initWithRootViewController:tabbar];
    tab_nav.hidesBottomBarWhenPushed=YES;
    [SingalObj defaultManager].rootNav =tab_nav.navigationController;
    self.window.rootViewController=tab_nav;
}
#pragma mark----------获取TrackID---
//请求轨迹ID
-(void)getTrackId{
    [self networkPost:API_GETTRACKID parameter:@{} progresHudText:nil completionBlock:^(id rep) {
        //保存用户信息
        NSString *trackId=rep[@"trackid"];
        [[NSUserDefaults standardUserDefaults] setObject:trackId forKey:@"trackid"];
        [SingalObj defaultManager].trackid=trackId;
    }];
}

#pragma mark----------版本更新----------------
-(void)getvison{
    [self networkPost:API_GETVERSION parameter:@{@"apptype":@(999)} progresHudText:@"加载中..." completionBlock:^(id rep) {
        VersionModel *versionModel=[[VersionModel alloc]init];
        if ([rep isKindOfClass:[NSArray class]]) {
            NSArray * versonAry=[VersionModel mj_objectArrayWithKeyValuesArray:rep];
            if (versonAry.count>0) {
                versionModel=versonAry[0];
            }
        }else{
             versionModel = [VersionModel mj_objectWithKeyValues:rep];
        }
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
        if (![versionModel.versioncode isEqualToString:currentVersion]) {
            UIAlertView *alert=[UIAlertView bk_showAlertViewWithTitle:@"温馨提示" message:versionModel.descript cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex==1) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:versionModel.url]];
                }
            }];
            [alert show];
        }
    }];
}
/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}


/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // 处理APNs代码，通过userInfo可以取到推送的信息（包括内容，角标，自定义参数等）。如果需要弹窗等其他操作，则需要自行编码。
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    //静默推送收到消息后也需要将APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}

#endif

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)networkPost:(NSString*)url parameter:(NSDictionary*)parameter progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock{
    if ([hudText isNotBlank]) {
         [SVProgressHUD showWithStatus:hudText];
    }
    NSDictionary * parameterdic = @{@"param":[parameter mj_JSONString]};
    [[AFAppDotNetAPIClient shareClient] POST:url parameters: parameterdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([hudText isNotBlank]) {
            [SVProgressHUD dismiss];
        }
        NSLog(@"%@",[responseObject mj_JSONString]);
        if ([responseObject[@"code"] intValue]==0) {
            completionBlock(responseObject[@"data"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"] ;
        NSString *errorStr = [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"failure--%@",errorStr);
        //        [SVProgressHUD showInfoWithStatus:@"加载错误"];
    }];
}
@end
