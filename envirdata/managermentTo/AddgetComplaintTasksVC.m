//
//  AddPatrolTasksVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/24.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "AddgetComplaintTasksVC.h"
#import "CTextField.h"
#import "UITextViewPlaceHolder.h"
#import "PictureView.h"
#import "LBpopView.h"
#import "MDepModel.h"
@interface AddgetComplaintTasksVC ()<PictureViewDelegate,LBpopDelegate>
@property (nonatomic,strong)CTextField *title_tf;//站点名称
@property (nonatomic,strong)CTextField *position_tf;//位置
@property (nonatomic,strong)UITextViewPlaceHolder *content_tv;//内容
@property (nonatomic,strong)PictureView *picture_view;//上传图片
@property (nonatomic,strong)CTextField *dep_tf;//部门
@property (nonatomic,strong)UIScrollView *mianScr;//
@property (nonatomic,strong)NSMutableArray*pricrAry;
@property (nonatomic,strong)LBpopView *depPopView;
@property (nonatomic,strong)NSArray *depAry;//站点数组
@property (nonatomic,assign)NSInteger depSelect;
@property (nonatomic,strong)MDepModel *depModel;

@end

@implementation AddgetComplaintTasksVC
@synthesize mianScr;
@synthesize title_tf,position_tf,content_tv,picture_view,dep_tf,jd,wd,locationManager,pricrAry;
@synthesize depPopView,depAry,depSelect,depModel;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor colorWithRGB:0xf1f1f1]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    depSelect=-1;
    [self getByareaidDepartmentInfos];
    [self.view setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    mianScr =[[UIScrollView alloc]init];
    [self.view addSubview:mianScr];
    WEAKSELF
    //先确定view_1的约束
    [mianScr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
    }];

    //标题
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCALE(50))];
    UILabel *sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 65, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"标题：";
    [tempView addSubview:sublb];
    title_tf =[[CTextField alloc]initWithFrame:CGRectMake(sublb.right, SCALE(7), SCREEN_WIDTH-sublb.right-SCALE(8), SCALE(36))];
    title_tf.font=Font(15);
    title_tf.placeholder=@"请输入标题";
    [title_tf setBackgroundColor:[UIColor whiteColor]];
    ViewRadius(title_tf, 4);
    title_tf.userInteractionEnabled=YES;
    [tempView addSubview:title_tf];
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    

    //位置
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, SCALE(50))];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 65, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"位置：";
    [tempView addSubview:sublb];
    
    UIButton *potsionBut=[UIButton buttonWithType:UIButtonTypeCustom];
    potsionBut.frame=CGRectMake(0, SCALE(7), SCALE(36), SCALE(36));
    potsionBut.right=tempView.width-SCALE(8);
    potsionBut.titleLabel.font=[UIFont fontWithName:@"iconfont" size:20];
    [potsionBut setTitle:@"\U0000e650" forState:UIControlStateNormal];
    [potsionBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [potsionBut bk_addEventHandler:^(id sender) {
        [self baiduConfig];
    } forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:potsionBut];
    
    position_tf =[[CTextField alloc]initWithFrame:CGRectMake(sublb.right, SCALE(7), SCREEN_WIDTH-(sublb.right+potsionBut.width+SCALE(13)), SCALE(36))];
    position_tf.font=Font(15);
    position_tf.placeholder=@"请输入位置";
    [position_tf setBackgroundColor:[UIColor whiteColor]];
    ViewRadius(position_tf, 4);
    [tempView addSubview:position_tf];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, tempView.height-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    
    //内容
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, SCALE(80))];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 65, 21)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"内容：";
    [tempView addSubview:sublb];
    content_tv =[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(sublb.right, SCALE(5), SCREEN_WIDTH-sublb.right-SCALE(8), SCALE(70))];
    content_tv.font=Font(15);
    [content_tv setBackgroundColor:[UIColor whiteColor]];
    ViewRadius(content_tv, 4);
    content_tv.placeholder=@"请输入内容";
    [tempView addSubview:content_tv];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, tempView.height-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    
    //图片
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 70)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 5, 65, 21)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"图片：";
    [tempView addSubview:sublb];
    
    picture_view=[[PictureView alloc]initWithFrame:CGRectMake(sublb.right,5, tempView.width-sublb.right-SCALE(8), 60) pictureAry:pricrAry size:CGSizeMake(60, 60) isUpPic:YES];
    picture_view.delegate = self;
    [tempView addSubview:picture_view];
    
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, tempView.height-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    
    //部门
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, SCALE(50))];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 80, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"责任部门：";
    [tempView addSubview:sublb];
    dep_tf =[[CTextField alloc]initWithFrame:CGRectMake(sublb.right, SCALE(7), SCREEN_WIDTH-sublb.right-SCALE(8), SCALE(36))];
    dep_tf.font=Font(15);
    dep_tf.placeholder=@"请选择部门";
    [dep_tf setBackgroundColor:[UIColor whiteColor]];
    ViewRadius(dep_tf, 4);
    
    dep_tf.enabled=YES;
    dep_tf.userInteractionEnabled=YES;
    [dep_tf bk_whenTapped:^{
        if (!depPopView) {
            depPopView=[[LBpopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        }
        depPopView.popType=@"deptype";
        depPopView.selectRowIndex=depSelect;
        depPopView.delegate=self;
        depPopView.popArray=depAry;
        depPopView.popTitle=@"请选择部门";
        [depPopView show];
    }];
    
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [tempView addSubview:dep_tf];
    [mianScr addSubview:tempView];
    
    UIButton *addMonitorBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addMonitorBtn.frame=CGRectMake(SCALE(8), tempView.bottom+20, SCREEN_WIDTH-SCALE(16), SCALE(50));
    [addMonitorBtn bootstrapNoborderStyle:SUBMIT_COLOR titleColor:[UIColor whiteColor] andbtnFont:Font(16)];
    [addMonitorBtn setTitle:@"提 交" forState:UIControlStateNormal];
    ViewRadius(addMonitorBtn, 8);
    [addMonitorBtn bk_addEventHandler:^(id sender) {
        [self addPatrolTasks];
    } forControlEvents:UIControlEventTouchUpInside];
    [mianScr addSubview:addMonitorBtn];
    [mianScr setContentSize:CGSizeMake(SCREEN_WIDTH, addMonitorBtn.bottom+30)];
    // Do any additional setup after loading the view.
}
#pragma mark--------定位--------
-(void)baiduConfig{
    if (!locationManager) {
        //初始化实例
        locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        locationManager.delegate = self;
        //设置返回位置的坐标系类型
        locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        locationManager.pausesLocationUpdatesAutomatically = YES;
        //设置是否允许后台定位
        locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        locationManager.reGeocodeTimeout = 10;
    }
    [locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (location) {//
            if (location.location) {
                NSLog(@"LOC = %@",location.location);
                wd = [NSNumber numberWithFloat:location.location.coordinate.latitude];
                jd = [NSNumber numberWithFloat:location.location.coordinate.longitude];
            }
            if (location.rgcData) {
                BMKLocationReGeocode *regoecode  =  location.rgcData;
                position_tf.text=[NSString stringWithFormat:@"%@%@%@%@",regoecode.city,regoecode.district,regoecode.street,regoecode.streetNumber!=nil?regoecode.streetNumber:@""];
                NSLog(@"rgc = %@",[location.rgcData description]);
            }
        }
    }];
}
#pragma mark-------选取图片--------
-(void)addPicker:(UIImagePickerController *)picker{
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)addUIImagePicker:(UIImagePickerController *)picker
{
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark-----------新增任务----
-(void)addPatrolTasks{
    if (![title_tf.text isNotBlank]) {
        [self showMsgInfo:@"请输入标题"];
        return;
    }else if (![content_tv.text isNotBlank]){
        [self showMsgInfo:@"请输入内容"];
        return;
    }else if(![position_tf.text isNotBlank]){
        [self showMsgInfo:@"请选择或输入位置"];
        return;
    }else if(picture_view.pictureAry.count==0){
        [self showMsgInfo:@"请选择图片"];
        return;
    }else if(![dep_tf.text isNotBlank]){
        [self showMsgInfo:@"请选择责任部门"];
        return;
    }
    WEAKSELF
    __block int i=0;
    __block NSMutableArray *imageAry=[[NSMutableArray alloc]init];
    for(UIImage *image in picture_view.pictureAry){
        [self networkUpfile:FILE_UPLOADING imageAry:image parameter:nil progresHudText:@"提交中..." completionBlock:^(id rep) {
            i++;
            [imageAry addObject:rep[@"url"]];
            if (i>=picture_view.pictureAry.count) {
                NSString *pics =  [imageAry componentsJoinedByString:@","];
                [weakSelf  addPatrolWithPics:pics];
            }
        }];
    }
}
-(void)addPatrolWithPics:(NSString*)pics{
    NSNumber * depid=depModel.depid;
    NSNumber *cuserid =[SingalObj defaultManager].userInfoModel.userid;
    NSString *address =position_tf.text;
    [self networkPost:API_INSETCOMPLAINT parameter:@{@"title":title_tf.text,@"content":content_tv.text,@"pics":pics,@"depid":depid,@"cuser":cuserid,@"address":address} progresHudText:nil completionBlock:^(id rep) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        [self bk_performBlock:^(id obj) {
            if (self.callback) {
                self.callback(YES);
                [self.navigationController popViewControllerAnimated:YES];
            }
        } afterDelay:1];
    }];
}
#pragma mark--------获取部门信息-----
-(void)getByareaidDepartmentInfos{
    NSNumber *areaid =[SingalObj defaultManager].userInfoModel.areaid;
    [self networkPost:API_GETBYAREAIDDEPARTMENTINFOS parameter:@{@"areaid":areaid} progresHudText:@"加载中..." completionBlock:^(id rep) {
        depAry =[MDepModel mj_objectArrayWithKeyValuesArray:rep];
    }];
}
#pragma mark------------------popViewdelegate----------------
-(void)getIndexRow:(int)indexrow warranty:(id)warranty
{
    if ([warranty isEqualToString:@"deptype"]){
        depSelect=indexrow;
        depModel =depAry[indexrow];
        dep_tf.text=depModel.dname;
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
