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
@interface EnvCameraInfoVC ()
@property (nonatomic,strong)UIScrollView *mainScr;
@property (nonatomic,strong)NSArray *unitAry;
@property (nonatomic,strong)ListView *unameview;
@property (nonatomic,strong)ListView *manageview;
@property (nonatomic,strong)ListView *linkPhoneview;
@property (nonatomic,strong)ListView *onlineStates;
@property (nonatomic,strong)UIView *hourView;
@end

@implementation EnvCameraInfoVC
@synthesize uid,u_type;
@synthesize mainScr,unitAry;
@synthesize unameview,manageview,linkPhoneview,onlineStates,hourView;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor colorWithRGB:0xedeeef]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
