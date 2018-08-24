//
//  TaskListViewController.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/17.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskCell.h"
#import "TaskModel.h"
#import "TaskDetailVC.h"
@interface TaskListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *taskListTb;
@property (nonatomic,strong)NSArray *taskAry;
@end

@implementation TaskListViewController
@synthesize sendor,status,receiver;
@synthesize taskListTb,taskAry;
- (void)viewDidLoad {
    [super viewDidLoad];

    taskListTb =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    taskListTb.translatesAutoresizingMaskIntoConstraints=NO;
    taskListTb.delegate=self;
    taskListTb.dataSource=self;
    [self.view addSubview:taskListTb];
    WEAKSELF
    //先确定view_1的约束
    [taskListTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(64);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    taskListTb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMonitorTaskList:YES];
    }];
    
    if (@available(iOS 11.0, *)) {
        taskListTb.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    taskListTb.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self getMonitorTaskList:NO];
    // Do any additional setup after loading the view.
}
- (void)getMonitorTaskList:(BOOL)isrefrsh{
    NSMutableDictionary *parameter =[[NSMutableDictionary alloc]init];
    if ([sendor isNotBlank]) {
        [parameter setObject:[sendor numberValue] forKey:@"sendor"];
    }
    if ([receiver isNotBlank]) {
        [parameter setObject:[receiver numberValue] forKey:@"receiver"];
    }
    if ([status isNotBlank]) {
        [parameter setObject:[status numberValue] forKey:@"status"];
    }
    [self networkPost:API_GETMONITORTASKLIST parameter:parameter progresHudText:isrefrsh==NO?@"加载中...":nil completionBlock:^(id rep) {
       taskAry = [TaskModel mj_objectArrayWithKeyValuesArray:rep];
        [taskListTb.mj_header endRefreshing];
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
#pragma mark 此方法加上是为了适配iOS 11出现的问题

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
#pragma mark 此方法加上是为了适配iOS 11出现的问题
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
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
    taskDetail.callback =^(BOOL issu){
        if (issu) {
            if (self.callback) {
                self.callback(YES);
                [taskListTb.mj_header beginRefreshing];
            }
        }
    };
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
