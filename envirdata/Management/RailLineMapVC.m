//
//  RailLineMapVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/19.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "RailLineMapVC.h"
#import "PGDatePickManager.h"
#import "PGDatePicker.h"
#import "RailLineModel.h"
#import "RailLinePointModel.h"
@interface RailLineMapVC ()<PGDatePickerDelegate,BMKLocationServiceDelegate>
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)UITextField *time_tf;
@property (nonatomic,strong)PGDatePickManager *datePickManager;
@property (nonatomic,strong)BMKMapView *railLineMap;
@property (nonatomic,strong)BMKLocationService *locService;
@property (nonatomic,strong)NSMutableArray *railAry;
@property (nonatomic,assign)BOOL isFrist;
@end

@implementation RailLineMapVC
@synthesize time,time_tf,datePickManager,railLineMap,userId,railAry;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    railAry=[[NSMutableArray alloc]init];
    NSDate * nowDate =[NSDate date];
    time = [nowDate stringWithFormat:@"yyyy-MM-dd"];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCALE(40))];
    [headerView setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    [self.view addSubview:headerView];
    CGSize size =[@"2017-12-12" sizeWithAttributes:@{NSFontAttributeName:Font(14)}];
    
    time_tf =[[UITextField alloc]initWithFrame:CGRectMake(0, SCALE(5), size.width+10, SCALE(30))];
    time_tf.textAlignment=NSTextAlignmentCenter;
    time_tf.font=Font(14);
    time_tf.backgroundColor=[UIColor whiteColor];
    time_tf.enabled=YES;
    time_tf.text=time;
    ViewRadius(time_tf, 4);
    time_tf.userInteractionEnabled=YES;
    time_tf.right=headerView.width-SCALE(8);
    [time_tf bk_whenTapped:^{
        if (!datePickManager) {
            datePickManager = [[PGDatePickManager alloc]init];
            datePickManager.isShadeBackgroud = true;
            datePickManager.style = PGDatePickManagerStyle3;
            PGDatePicker *datePicker = datePickManager.datePicker;
            datePicker.delegate = self;
            [datePicker setDate:[NSDate date]];
            datePicker.datePickerType = PGPickerViewType1;
            datePicker.isHiddenMiddleText = false;
            datePicker.isHiddenWheels = false;
            datePicker.datePickerMode = PGDatePickerModeDate;
        }
        [self presentViewController:datePickManager animated:false completion:nil];
    }];
    [headerView addSubview:time_tf];
    
    UILabel *sjlb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, SCALE(40))];
    sjlb.font=Font(15);
    sjlb.text=@"时间：";
    sjlb.textAlignment=NSTextAlignmentRight;
    sjlb.right=time_tf.left;
    [headerView addSubview:sjlb];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    railLineMap =[[BMKMapView alloc]initWithFrame:CGRectMake(0, headerView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-headerView.bottom)];
    railLineMap.zoomLevel = 16;//缩放等级
    [railLineMap setMapType:BMKMapTypeStandard];//地图类型
    railLineMap.userTrackingMode=BMKUserTrackingModeNone;
    railLineMap.showsUserLocation=YES;//显示定位图层
    railLineMap.showMapScaleBar=YES;
    //railLineMap.minZoomLevel=12;
    //railLineMap.maxZoomLevel=20;
    railLineMap.delegate=self;
    [self.view addSubview:railLineMap];
    [self getTrackList];
    // Do any additional setup after loading the view.
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [railLineMap updateLocationData:userLocation];
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [railLineMap updateLocationData:userLocation];
}
-(BMKOverlayView*)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.lineWidth = 3;
        /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
        polylineView.colors = [NSArray arrayWithObjects:
                               [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:1],
                               [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1],
                               [[UIColor alloc] initWithRed:1 green:1 blue:0 alpha:0.5], nil];
        return polylineView;
    }return  nil;
}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate * date = [calendar dateFromComponents:dateComponents];
    time = [date stringWithFormat:@"yyyy-MM-dd"];
    time_tf.text=time;
    [self getTrackList];
}
#pragma mark----------获取指定日期轨迹列表---------
-(void)getTrackList{
    _isFrist=NO;
    [railLineMap removeOverlays:railAry];
    railAry=[[NSMutableArray alloc]init];
    [self networkPost:API_GETTRACKLIST parameter:@{@"date":time,@"userid":userId} progresHudText:@"获取中..." completionBlock:^(id rep) {
       NSArray *taskIdAry =[RailLineModel mj_objectArrayWithKeyValuesArray:rep];
        if (taskIdAry.count>0) {
            [taskIdAry bk_each:^(RailLineModel *obj) {
                [self getTrackById:obj.trackid];
            }];
        }else{
            [self showMsgInfo:@"今日暂无巡查轨迹"];
        }
    }];
}
-(void)getTrackById:(NSString*)trackid{
    [self networkPost:API_GETTRACKBYID parameter:@{@"trackid":trackid} progresHudText:@"获取中..." completionBlock:^(id rep) {
        NSArray * railPointAry =[RailLinePointModel mj_objectArrayWithKeyValuesArray:rep];
        if (railPointAry.count==0) {
            return ;
        }
        if (_isFrist==NO&&railPointAry.count>0) {
            RailLinePointModel *centerModel=railPointAry[0];
            CLLocationCoordinate2D centerCoor;
            centerCoor.latitude=[centerModel.lat doubleValue];
            centerCoor.longitude=[centerModel.lng doubleValue];
            railLineMap.centerCoordinate = centerCoor;
            _isFrist=YES;
        }
        //构建分段颜色索引数组
        NSArray *colorIndexs = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:2],
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:2], nil];
        CLLocationCoordinate2D *coords = malloc([railPointAry count] * sizeof(CLLocationCoordinate2D));
        for(int i=0;i<railPointAry.count;i++){
            RailLinePointModel *railModel=railPointAry[i];
            coords[i].latitude =[railModel.lat doubleValue];
            coords[i].longitude =[railModel.lng doubleValue];
        }
         BMKPolyline *polyLine = [BMKPolyline polylineWithCoordinates:coords count:[railPointAry count] textureIndex:colorIndexs];
        [railAry addObject:polyLine];
        [railLineMap addOverlays:railAry];
    }];
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
