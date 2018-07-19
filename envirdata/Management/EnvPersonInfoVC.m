//
//  EnvPersonInfoVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/17.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvPersonInfoVC.h"
#import "ListView.h"
#import "MonitorUserModel.h"
#import "TaskCell.h"
#import "TaskModel.h"
#import "TaskDetailVC.h"
@interface EnvPersonInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)MonitorUserModel *monitorUser;
@property (nonatomic,strong)ListView *nameView;
@property (nonatomic,strong)ListView *xzqView;
@property (nonatomic,strong)ListView *depView;
@property (nonatomic,strong)ListView *linkView;
@property (nonatomic,strong)ListView *rwlistView;
@property (nonatomic,strong)NSArray *taskAry;
@property (nonatomic,strong)UITableView *taskListTb;
@end

@implementation EnvPersonInfoVC
@synthesize receiver,userid;
@synthesize nameView,xzqView,depView,linkView,rwlistView;
@synthesize monitorUser,taskAry,taskListTb;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    nameView=[[ListView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCALE(40)) name:@"姓名：" value:@""];
    [self.view addSubview:nameView];
    xzqView=[[ListView alloc]initWithFrame:CGRectMake(0, nameView.bottom, SCREEN_WIDTH, SCALE(40)) name:@"行政区域：" value:@""];
    [self.view addSubview:xzqView];
    depView=[[ListView alloc]initWithFrame:CGRectMake(0, xzqView.bottom, SCREEN_WIDTH, SCALE(40)) name:@"所属部门：" value:@""];
    [self.view addSubview:depView];
    linkView=[[ListView alloc]initWithFrame:CGRectMake(0, depView.bottom, SCREEN_WIDTH, SCALE(40)) name:@"联系电话：" value:@""];
    [self.view addSubview:linkView];
    rwlistView=[[ListView alloc]initWithFrame:CGRectMake(0, linkView.bottom, SCREEN_WIDTH, SCALE(40)) name:@"任务列表：" value:@""];
    [self.view addSubview:rwlistView];
    float hg =rwlistView.bottom;
    taskListTb =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    taskListTb.translatesAutoresizingMaskIntoConstraints=NO;
    taskListTb.delegate=self;
    taskListTb.dataSource=self;
    [self.view addSubview:taskListTb];
    WEAKSELF
    //先确定view_1的约束
    [taskListTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(hg);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-10);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(10);
    }];
    taskListTb.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self getInfo];
    // Do any additional setup after loading the view.
}
-(void)getInfo{
    [self networkPost:API_GETMONITORUSER parameter:@{@"userid":[userid numberValue]} progresHudText:@"加载中..." completionBlock:^(id rep) {
        monitorUser =[MonitorUserModel mj_objectWithKeyValues:rep];
        nameView.valuelb.text=monitorUser.username;
        xzqView.valuelb.text=monitorUser.areaname;
        depView.valuelb.text=monitorUser.team;
        linkView.valuelb.text=monitorUser.phone;
        linkView.islink=YES;
    }];
    [self networkPost:API_GETMONITORTASKLIST parameter:@{@"receiver":[receiver numberValue]} progresHudText:@"加载中..." completionBlock:^(id rep) {
        taskAry = [TaskModel mj_objectArrayWithKeyValuesArray:rep];
        [taskListTb reloadData];
    }];
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
    return taskAry.count;
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
    TaskCell *cell = (TaskCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.taskModel=taskAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TaskDetailVC *taskDetail =[[TaskDetailVC alloc]init];
    taskDetail.title=@"任务详情";
    taskDetail.isOnlyLook=YES;
    taskDetail.taskModel=taskAry[indexPath.row];
    [self.navigationController pushViewController:taskDetail animated:YES];
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
