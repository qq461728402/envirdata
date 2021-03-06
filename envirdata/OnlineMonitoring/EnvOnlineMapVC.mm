//
//  EnvOnlineMapVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/14.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvOnlineMapVC.h"
#import "BMKMapView.h"
#import "OnlineMonModel.h"
#import "StatePointAnnotation.h"
#import "PointPointAnnotation.h"
#import "WarnPointAnnotation.h"
#import "DkeyModel.h"
#import "LBpopView.h"
#import "EnvCameraInfoVC.h"
#import "EnvUnitDataTimeVC.h"
#import "UnusuallyPonitAnnotation.h"
#import "GKPhoto.h"
#import "GKPhotoBrowser.h"
@interface EnvOnlineMapVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate,LBpopDelegate>
@property (nonatomic,strong)BMKLocationService *locService;
@property (nonatomic,strong)BMKMapView *onlineMap;
@property (nonatomic,strong)LBpopView *lbpopView;
@property (nonatomic,strong)NSString *utype;//筛选类型
@property (nonatomic,strong)NSArray *onlinelistAry;
@property (nonatomic,strong)NSArray *warningAry;
@property (nonatomic,strong)NSMutableArray *dkeylistAry;
@property (nonatomic,assign)int utypeindex;
@property (nonatomic,strong)NSMutableArray *allpointAry;//保存所有标记点
@end

@implementation EnvOnlineMapVC
@synthesize onlineMap,utype,onlinelistAry,dkeylistAry,lbpopView,utypeindex,allpointAry,warningAry;
- (void)viewDidLoad {
    [super viewDidLoad];
    allpointAry=[[NSMutableArray alloc]init];
    utype=@"";
    utypeindex=0;
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    onlineMap =[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    onlineMap.zoomLevel = 13;//缩放等级
//    if ([SingalObj defaultManager].userLocation) {
//        onlineMap.centerCoordinate = [SingalObj defaultManager].userLocation.coordinate;
//    }
    [onlineMap setMapType:BMKMapTypeStandard];//地图类型
    onlineMap.userTrackingMode=BMKUserTrackingModeNone;
    onlineMap.showsUserLocation=YES;//显示定位图层
    onlineMap.translatesAutoresizingMaskIntoConstraints=NO;
    onlineMap.delegate=self;
    [self.view addSubview:onlineMap];
    __weak __typeof(self) weakSelf = self;
    //先确定view_1的约束
    [onlineMap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    UIButton * refersh=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    refersh.translatesAutoresizingMaskIntoConstraints=NO;
    [refersh setImage:PNGIMAGE(@"online_shuaxin") forState:UIControlStateNormal];
    [refersh bk_addEventHandler:^(id sender) {
        [self getdataInfo];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refersh];
    [refersh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(20);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-10);
    }];
    UIButton *typelistBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [typelistBtn setImage:PNGIMAGE(@"online_list") forState:UIControlStateNormal];
    [typelistBtn bk_addEventHandler:^(id sender) {
        if (!lbpopView) {
            lbpopView=[[LBpopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        }
        lbpopView.popType=@"utype";
        lbpopView.selectRowIndex=utypeindex;
        lbpopView.delegate=self;
        lbpopView.popArray=dkeylistAry;
        lbpopView.popTitle=@"请选择站点类型";
        [lbpopView show];
    } forControlEvents:UIControlEventTouchUpInside];
    typelistBtn.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:typelistBtn];
    [typelistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(70);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-10);
    }];
    
    UIImageView *warinImge=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 70)];
    [warinImge setImage:PNGIMAGE(@"icon_legend.png")];
    warinImge.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:warinImge];
    [warinImge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    [self getTypeDescipt];
    // Do any additional setup after loading the view.
}
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    [onlineMap updateLocationData:userLocation];
//}
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    [onlineMap updateLocationData:userLocation];
////    if (![SingalObj defaultManager].userLocation) {
////
////        [SingalObj defaultManager].userLocation=userLocation.location;
////        onlineMap.centerCoordinate = [SingalObj defaultManager].userLocation.coordinate;
////    }
//}
#pragma mark----------获取Typelist----------------------
-(void)getTypeDescipt{
    [self networkPost:API_GETTYPEDESCIPT parameter:@{@"dkey":@"utype"} progresHudText:nil completionBlock:^(id rep) {
        DkeyModel *dkeyMode=[[DkeyModel alloc]init];
        dkeyMode.dkid=[NSNumber numberWithString:@""];
        dkeyMode.dval=@"全部";
        dkeylistAry =[NSMutableArray arrayWithObject:dkeyMode];
        [dkeylistAry addObjectsFromArray:[DkeyModel mj_objectArrayWithKeyValuesArray:rep]];
    }];
}
-(void)getdataInfo{
    [onlineMap removeAnnotations:allpointAry];
    [allpointAry removeAllObjects];
    NSString *areaid =[NSString stringWithFormat:@"%@",[SingalObj defaultManager].userInfoModel.areaid];
    [self networkPost:API_GETUNITONLINESTATE parameter:@{@"areaid":areaid,@"utype":utype} progresHudText:@"加载中..." completionBlock:^(id rep) {
        onlinelistAry = [OnlineMonModel mj_objectArrayWithKeyValuesArray:rep];
        for (OnlineMonModel * onlineMon in onlinelistAry) {
            if ([onlineMon.utype intValue]==1&&[onlineMon.status intValue]==0) {
                CLLocationCoordinate2D coor;
                coor.latitude = [onlineMon.wd doubleValue];
                coor.longitude = [onlineMon.jd doubleValue];
                StatePointAnnotation *statePoint =[[StatePointAnnotation alloc]initWithCoordinate:coor title:onlineMon.uname uid:onlineMon];
                [onlineMap addAnnotation:statePoint];
                [allpointAry addObject:statePoint];
                
            }else if ([onlineMon.status intValue]==0){//其他站点
                CLLocationCoordinate2D coor;
                coor.latitude = [onlineMon.wd doubleValue];
                coor.longitude = [onlineMon.jd doubleValue];
                PointPointAnnotation *pointPoint =[[PointPointAnnotation alloc]initWithCoordinate:coor title:onlineMon.uname uid:onlineMon];
                [onlineMap addAnnotation:pointPoint];
                [allpointAry addObject:pointPoint];
            }else if ([onlineMon.status intValue]==1){//表示异常
                CLLocationCoordinate2D coor;
                coor.latitude = [onlineMon.wd doubleValue];
                coor.longitude = [onlineMon.jd doubleValue];
                UnusuallyPonitAnnotation *pointPoint =[[UnusuallyPonitAnnotation alloc]initWithCoordinate:coor title:onlineMon.uname uid:onlineMon];
                [onlineMap addAnnotation:pointPoint];
                [allpointAry addObject:pointPoint];
            }
            
        }
        [self setCenterPoint:onlinelistAry];
    }];
    //获取预警点数据
    [self networkPost:API_GETUNITWARNINGPICS parameter:@{@"areaid":areaid,@"utype":utype} progresHudText:@"加载中..." completionBlock:^(id rep) {
        warningAry =[OnlineMonModel mj_objectArrayWithKeyValuesArray:rep];
        [warningAry bk_each:^(OnlineMonModel * onlineMon) {
            CLLocationCoordinate2D coor;
            coor.latitude = [onlineMon.wd doubleValue];
            coor.longitude = [onlineMon.jd doubleValue];
            WarnPointAnnotation *pointPoint =[[WarnPointAnnotation alloc]initWithCoordinate:coor title:onlineMon.uname uid:onlineMon];
            [onlineMap addAnnotation:pointPoint];
            [allpointAry addObject:pointPoint];
        }];
    }];
    
}
-(void)setCenterPoint:(NSArray*)allPonit{
    double minLat=0;
    double maxLat=0;
    double minLon=0;
    double maxLon=0;
    for (NSInteger i=0; i<allPonit.count; i++) {
        OnlineMonModel *onlineMon =allPonit[i];
        if (i==0) {
            minLon =[onlineMon.jd doubleValue];
            maxLon =[onlineMon.jd doubleValue];
            minLat =[onlineMon.wd doubleValue];
            maxLat =[onlineMon.wd doubleValue];
        }else{
            minLon =MIN(minLon, [onlineMon.jd doubleValue]);
            maxLon =MAX(maxLon, [onlineMon.jd doubleValue]);
            minLat =MIN(minLat, [onlineMon.wd doubleValue]);
            maxLat =MAX(maxLat, [onlineMon.wd doubleValue]);
        }
    }
    if (allPonit.count>0) {
        CLLocationCoordinate2D centCoor;
        centCoor.latitude = (CLLocationDegrees)((minLat+maxLat) * 0.5f);
        centCoor.longitude = (CLLocationDegrees)((minLon+maxLon) * 0.5f);
//        onlineMap.centerCoordinate = centCoor;
        BMKCoordinateRegion region ;
        //计算地理位置的跨度
        BMKCoordinateSpan span;
        span.latitudeDelta = maxLat - minLat;
        span.longitudeDelta = maxLon - minLon;
        region.span=span;
        region.center=centCoor;
        [onlineMap setRegion:region];
//        [onlineMap setRegion:BMKCoordinateRegionMake(centCoor,span)];
//        MKCoordinateRegion _region = BMKCoordinateRegionMake(centCoor,span);
    
//        //计算地理位置的跨度
//        span.latitudeDelta = maxLat - minLat;
//        span.longitudeDelta = maxLon - minLon;
//        BMKCoordinateRegion * _region = BMKCoordinateRegionMake(centCoor, span);
    }
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[StatePointAnnotation class]]) {
        static NSString *reuseIndetifier = @"stateIndetifier";
        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:reuseIndetifier];
        }
        annotationView.canShowCallout=NO;
        annotationView.image = PNGIMAGE(@"icon_gk_03");
        return annotationView;
    }else if ([annotation isKindOfClass:[PointPointAnnotation class]]){
        static NSString *reuseIndetifier = @"pointIndetifier";
        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:reuseIndetifier];
        }
        annotationView.canShowCallout=NO;
        annotationView.image = PNGIMAGE(@"icon_jc_02");
        return annotationView;
    }
    else if ([annotation isKindOfClass:[UnusuallyPonitAnnotation class]]){
        static NSString *reuseIndetifier = @"warnIndetifier";
        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:reuseIndetifier];
        }
        annotationView.canShowCallout=NO;
        annotationView.image = PNGIMAGE(@"icon_jc_02_1");
        return annotationView;
        
    }
    else if ([annotation isKindOfClass:[WarnPointAnnotation class]]){
        static NSString *reuseIndetifier = @"warnIndetifier";
        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:reuseIndetifier];
        }
        annotationView.canShowCallout=NO;
        annotationView.image = PNGIMAGE(@"warnPoint");
        return annotationView;
    
    }
    return nil;
}
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    if ([view.annotation isKindOfClass:[PointPointAnnotation class]] ||[view.annotation isKindOfClass:[UnusuallyPonitAnnotation class]]) {
        PointPointAnnotation *pointPointA=(PointPointAnnotation*)view.annotation;
        NSLog(@"%@",pointPointA.title);
        OnlineMonModel *onlineModel = pointPointA.onlineModel;
        EnvCameraInfoVC *cameraInfo=[[EnvCameraInfoVC alloc]init];
        cameraInfo.uid=onlineModel.uid;
        CLLocationCoordinate2D coor;
        coor.latitude = [onlineModel.wd doubleValue];
        coor.longitude = [onlineModel.jd doubleValue];
        cameraInfo.coordinate=coor;
        cameraInfo.u_type=[onlineModel.utype stringValue];
        cameraInfo.title=onlineModel.uname;
        self.callback(cameraInfo);
    }else if ([view.annotation isKindOfClass:[StatePointAnnotation class]]){
        StatePointAnnotation *pointPointA=(StatePointAnnotation*)view.annotation;
        NSLog(@"%@",pointPointA.title);
        OnlineMonModel *onlineModel = pointPointA.onlineModel;
        EnvUnitDataTimeVC *unitDataTime=[[EnvUnitDataTimeVC alloc]init];
        unitDataTime.uid=onlineModel.uid;
        unitDataTime.title=onlineModel.uname;
        self.callback(unitDataTime);
    }else if ([view.annotation isKindOfClass:[WarnPointAnnotation class]]){
        WarnPointAnnotation *pointPointA=(WarnPointAnnotation*)view.annotation;
        OnlineMonModel *onlineModel = pointPointA.onlineModel;
        NSArray *urlAry  = [onlineModel.pic componentsSeparatedByString:@","];
        if (urlAry.count>0) {
            NSMutableArray *photos = [NSMutableArray new];
            [urlAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GKPhoto *photo = [GKPhoto new];
                photo.url = [NSURL URLWithString:obj];
                [photos addObject:photo];
            }];
            GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
//            browser.delegate=self;
            browser.showStyle = GKPhotoBrowserShowStyleNone;
            [browser showFromVC:self];
        }
    }
}
#pragma mark------------------popViewdelegate----------------
-(void)getIndexRow:(int)indexrow warranty:(id)warranty
{
    if ([warranty isEqualToString:@"utype"]) {
        utypeindex =indexrow;
        DkeyModel *dkeyMode=dkeylistAry[utypeindex];
        utype =[NSString stringWithFormat:@"%@",dkeyMode.dkid];
        [self getdataInfo];
    }
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
