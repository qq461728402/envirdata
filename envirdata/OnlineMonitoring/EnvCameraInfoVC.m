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
@interface EnvCameraInfoVC ()<GKPhotoBrowserDelegate>
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
@end

@implementation EnvCameraInfoVC
@synthesize uid,u_type,coordinate;
@synthesize mainScr,unitAry;
@synthesize unameview,manageview,linkPhoneview,onlineStates,hourView,navname;
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
    [self getCameraInfo];
    // Do any additional setup after loading the view.
}
#pragma mark--------------根据站点获取摄像头信息-----------
-(void)getCameraInfo{
    [self networkPost:API_GETCAMERAINFO parameter:@{@"uid":uid} progresHudText:@"加载中..." completionBlock:^(id rep) {
        CameraInfoModel *carmeraInfo =[CameraInfoModel mj_objectWithKeyValues:rep];
        unameview.valuelb.text=carmeraInfo.address;
        manageview.valuelb.text=carmeraInfo.manager;
        linkPhoneview.valuelb.text=carmeraInfo.phone;
        linkPhoneview.islink=YES;
        onlineStates.valuelb.text=[carmeraInfo.onlinestatus intValue]==0?@"离线":[carmeraInfo.onlinestatus intValue]==1?@"在线":@"未知";
        if ([carmeraInfo.address isNotBlank]) {
            navname=carmeraInfo.address;
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
    
    NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",coordinate.latitude,coordinate.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
}

- (void)baiduNaviWithCoordinate:(CLLocationCoordinate2D)coordinate andWithMapTitle:(NSString *)map_title{
    NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude,coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
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
