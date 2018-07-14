//
//  EnvOnlienListVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/14.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvOnlienListVC.h"
#import "OnlineCell.h"
#import "OnlineMonModel.h"
#import "EnvUnitDataTimeVC.h"
#import "EnvCameraInfoVC.h"
@interface EnvOnlienListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *onlineTb;
@property (nonatomic,strong)NSArray *onlinelistAry;
@end

@implementation EnvOnlienListVC
@synthesize onlineTb,onlinelistAry;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALE(40))];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *stateslb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [ConfigObj font_sizeWith:15 strLong:5], headerView.height)];
    stateslb.right=headerView.width-SCALE(8);
    stateslb.font=Font(15);
    stateslb.text=@"状态";
    stateslb.textColor=[UIColor colorWithRGB:0x2e4057];
    stateslb.adjustsFontSizeToFitWidth=YES;
    stateslb.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:stateslb];
    
    UILabel *typelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [ConfigObj font_sizeWith:15 strLong:7], stateslb.height)];
    typelb.right=stateslb.left;
    typelb.font=Font(15);
    typelb.text=@"类型";
    typelb.textColor=[UIColor colorWithRGB:0x2e4057];
    typelb.adjustsFontSizeToFitWidth=YES;
    typelb.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:typelb];
    
    UILabel *namelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, headerView.width-typelb.width-stateslb.width-SCALE(8), headerView.height)];
    namelb.right=typelb.left;
    namelb.font=Font(15);
    namelb.text=@"站点";
    namelb.textColor=[UIColor colorWithRGB:0x2e4057];
    namelb.adjustsFontSizeToFitWidth=YES;
    namelb.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:namelb];
    [self.view addSubview:headerView];
    
    onlineTb=[[UITableView alloc]initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    onlineTb.translatesAutoresizingMaskIntoConstraints=NO;
    onlineTb.delegate=self;
    onlineTb.dataSource=self;
    [self.view addSubview:onlineTb];
    
    __weak __typeof(self) weakSelf = self;//这里用一个弱引用来表示self，用于下面的Block中
    //先确定view_1的约束
    [onlineTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(SCALE(40));
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    __unsafe_unretained __typeof(self) weakSelf1 = self;
    onlineTb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf1 getdataInfo:YES];
    }];
    onlineTb.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // Do any additional setup after loading the view.
}
- (void)viewDidLayoutSubviews{
    if ([onlineTb respondsToSelector:@selector(setSeparatorInset:)]) {
        [onlineTb setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([onlineTb respondsToSelector:@selector(setLayoutMargins:)]) {
        [onlineTb setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}


#pragma mark------------获取数据----------
-(void)getdataInfo:(BOOL) isrefesh{
    NSString *areaid =[NSString stringWithFormat:@"%@",[SingalObj defaultManager].userInfoModel.areaid];
    [self networkPost:API_GETUNITONLINESTATE parameter:@{@"areaid":areaid} progresHudText:isrefesh==NO?@"加载中...":nil completionBlock:^(id rep) {
        onlinelistAry = [OnlineMonModel mj_objectArrayWithKeyValuesArray:rep];
        [onlineTb reloadData];
        [onlineTb.mj_header endRefreshing];
    }];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return onlinelistAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NoticeCell";
    OnlineCell *cell = (OnlineCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[OnlineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.onlineMonModel=onlinelistAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OnlineMonModel * onlineModel= onlinelistAry[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.callback) {
        if ([onlineModel.utype intValue]==1) {//表示国控点
            EnvUnitDataTimeVC *unitDataTime=[[EnvUnitDataTimeVC alloc]init];
            unitDataTime.uid=onlineModel.uid;
            unitDataTime.title=onlineModel.uname;
            self.callback(unitDataTime);
        }else{//其他站点类型 包括异常和正常
            EnvCameraInfoVC *cameraInfo=[[EnvCameraInfoVC alloc]init];
            cameraInfo.uid=onlineModel.uid;
            cameraInfo.title=onlineModel.uname;
            self.callback(cameraInfo);
        }
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
