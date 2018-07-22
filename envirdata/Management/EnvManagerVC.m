//
//  EnvManagerVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/11.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvManagerVC.h"
#import "TaskTreeModel.h"
#import "ACell.h"
#import "PCell.h"
#import "TaskListViewController.h"
#import "GegionVC.h"
#import "EnvPersonInfoVC.h"
#import "AddTaskViewController.h"
#import "RailLineMapVC.h"
@interface EnvManagerVC ()<UITableViewDelegate,UITableViewDataSource,ACellDelegate,PCellDelegate>
@property (nonatomic,strong)NSMutableArray *assemblyAry;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)NSMutableArray *displayAry;
@property (nonatomic,strong)UITableView *treeTb;
@property (nonatomic,assign)BOOL isAreaExpanded;
@property (nonatomic,strong)TaskTreeModel *my_selfTree;//表示自己
@property (nonatomic,strong)UILabel *todonum_lb;
@property (nonatomic,strong)UILabel *checknum_lb;
@end

@implementation EnvManagerVC
@synthesize displayAry,dataAry,assemblyAry,treeTb,my_selfTree,todonum_lb,checknum_lb;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [view setBackgroundColor:COLOR_TOP];
    [self.view addSubview:view];
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, view.bottom, SCREEN_WIDTH, 50)];
    [headerView setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    [self.view addSubview:headerView];

    UIButton *wddbbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wddbbtn.frame=CGRectMake(0, 10, 75, 30);
    [wddbbtn bootstrapNoborderStyle:[UIColor clearColor] titleColor:[UIColor colorWithRGB:0x2e4057] andbtnFont:Font(14)];
    ViewBorderRadius(wddbbtn, 4, 1, COLOR_TOP);
    [wddbbtn setTitle:@"我的待办" forState:UIControlStateNormal];
    [wddbbtn bk_addEventHandler:^(id sender) {
        TaskListViewController *taskList =[[TaskListViewController alloc]init];
        NSString *pstr = my_selfTree.tid;
        NSString *uid = [pstr substringFromIndex:1];
        taskList.receiver=uid;
        taskList.status=@"1";
        taskList.title=@"我的待办";
        taskList.callback =^(BOOL issu){
            if (issu==YES) {
                [treeTb.mj_header beginRefreshing];
            }
        };
        UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
        [nav pushViewController:taskList animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:wddbbtn];
    
    todonum_lb =[[UILabel alloc]initWithFrame:CGRectMake(0, SCALE(12), SCALE(16), SCALE(16))];
    todonum_lb.textColor=[UIColor whiteColor];
    todonum_lb.backgroundColor=[UIColor redColor];
    todonum_lb.font=Font(12);
    todonum_lb.hidden=YES;
    todonum_lb.textAlignment=NSTextAlignmentCenter;
    ViewRadius(todonum_lb, todonum_lb.height/2.0);
    [headerView addSubview:todonum_lb];
    wddbbtn.centerX=SCREEN_WIDTH/8.0;
    todonum_lb.center=CGPointMake(wddbbtn.right, wddbbtn.top);
    
    
    
    UIButton *wdshbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wdshbtn.frame=CGRectMake(0, 10, 75, 30);
    [wdshbtn bootstrapNoborderStyle:[UIColor clearColor] titleColor:[UIColor colorWithRGB:0x2e4057] andbtnFont:Font(14)];
    ViewBorderRadius(wdshbtn, 4, 1, COLOR_TOP);
    [wdshbtn setTitle:@"我的审核" forState:UIControlStateNormal];
    [wdshbtn bk_addEventHandler:^(id sender) {
        TaskListViewController *taskList =[[TaskListViewController alloc]init];
        NSString *pstr = my_selfTree.tid;
        NSString *uid = [pstr substringFromIndex:1];
        taskList.receiver=uid;
        taskList.status=@"2";
        taskList.title=@"我的审核";
        taskList.callback =^(BOOL issu){
            if (issu==YES) {
                [treeTb.mj_header beginRefreshing];
            }
        };
        UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
        [nav pushViewController:taskList animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:wdshbtn];
    wdshbtn.centerX=SCREEN_WIDTH/8.0*3;
    
    checknum_lb =[[UILabel alloc]initWithFrame:CGRectMake(0, SCALE(12), SCALE(16), SCALE(16))];
    checknum_lb.textColor=[UIColor whiteColor];
    checknum_lb.hidden=YES;
    checknum_lb.backgroundColor=[UIColor redColor];
    checknum_lb.font=Font(12);
    checknum_lb.textAlignment=NSTextAlignmentCenter;
    ViewRadius(checknum_lb, checknum_lb.height/2.0);
    [headerView addSubview:checknum_lb];
    wddbbtn.centerX=SCREEN_WIDTH/8.0;
    checknum_lb.center=CGPointMake(wdshbtn.right, wdshbtn.top);
    
    
    
    UIButton *wdgjbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wdgjbtn.frame=CGRectMake(0, 10, 75, 30);
    [wdgjbtn bootstrapNoborderStyle:[UIColor clearColor] titleColor:[UIColor colorWithRGB:0x2e4057] andbtnFont:Font(14)];
    ViewBorderRadius(wdgjbtn, 4, 1, COLOR_TOP);
    [wdgjbtn setTitle:@"我的轨迹" forState:UIControlStateNormal];
    [wdgjbtn bk_addEventHandler:^(id sender) {
        RailLineMapVC *railLineMap =[[RailLineMapVC alloc]init];
        railLineMap.title=@"我的轨迹";
        railLineMap.userId=[[SingalObj defaultManager].userInfoModel.userid stringValue];
        UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
        [nav pushViewController:railLineMap animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:wdgjbtn];
    wdgjbtn.centerX=SCREEN_WIDTH/8.0*5;
    UIButton *xzrwbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    xzrwbtn.frame=CGRectMake(0, 10, 75, 30);
    [xzrwbtn bootstrapNoborderStyle:[UIColor clearColor] titleColor:[UIColor colorWithRGB:0x2e4057] andbtnFont:Font(14)];
    ViewBorderRadius(xzrwbtn, 4, 1, COLOR_TOP);
    [xzrwbtn setTitle:@"新增任务" forState:UIControlStateNormal];
    [headerView addSubview:xzrwbtn];
    xzrwbtn.centerX=SCREEN_WIDTH/8.0*7;
    [xzrwbtn bk_addEventHandler:^(id sender) {
        AddTaskViewController *addTask =[[AddTaskViewController alloc]init];
        addTask.title=@"新增任务";
        addTask.kind=@"1";
        addTask.callback=^(BOOL issu){
            if (issu==YES) {
                [self getMonitorTaskTree3];
            }
        };
        UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
        [nav pushViewController:addTask animated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *groupView=[[UIView alloc]initWithFrame:CGRectMake(0, headerView.bottom, headerView.width, 40)];
    [groupView setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    [self.view addSubview:groupView];
    
    UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.5, groupView.width, 0.5)];
    [onelb setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [groupView addSubview:onelb];
    
    UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, groupView.height)];
    lb.font=BoldFont(17);
    lb.text=@"组织结构";
    lb.textColor=[UIColor blackColor];
    [groupView addSubview:lb];
    
    UIButton *ssbut=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, groupView.height)];
    ssbut.right=SCREEN_WIDTH-SCALE(10);
    [ssbut setTitle:@"收缩" forState:UIControlStateNormal];
    [ssbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ssbut.titleLabel.font=Font(14);
    [ssbut bk_addEventHandler:^(id sender) {
        self.isAreaExpanded=!self.isAreaExpanded;
        if ([ssbut.titleLabel.text isEqualToString:@"收缩"]) {
            [ssbut setTitle:@"展开" forState:UIControlStateNormal];
        }else{
            [ssbut setTitle:@"收缩" forState:UIControlStateNormal];
        }
        for (TaskTreeModel *tree in assemblyAry) {
             [self nodeChreliden:tree.chlidren];
        };
        [self fillDisplayArray];
        [treeTb reloadData];
    } forControlEvents:UIControlEventTouchUpInside];
    [groupView addSubview:ssbut];
    
    treeTb =[[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT)];
    treeTb.delegate=self;
    treeTb.dataSource=self;
    treeTb.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:treeTb];
    WEAKSELF
    //先确定view_1的约束
    [treeTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(SCALE(104));
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    treeTb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMonitorTaskTree3];
    }];
    [self getMonitorTaskTree3];
    // Do any additional setup after loading the view.
}

#pragma mark--------展开------
-(void)nodeChreliden:(NSArray*)chrend{
    for (TaskTreeModel *tree in chrend) {
        if ([tree.level isEqualToString:@"area"]) {
            tree.isExpanded=!self.isAreaExpanded;
        }
        if (tree.chlidren.count>0) {
            [self nodeChreliden:tree.chlidren];
        }
    }
}
#pragma mark-----------添加树形结构-------
- (void)getMonitorTaskTree3{
    assemblyAry=[[NSMutableArray alloc]init];
    UserInfoModel *userfin=[SingalObj defaultManager].userInfoModel;
    [self networkPost:API_GETMONITORTASKTREE3 parameter:@{@"userid":userfin.userid} progresHudText:@"加载中..." completionBlock:^(id rep) {
        //数据源
        dataAry =[[NSMutableArray alloc] initWithArray:[TaskTreeModel mj_objectArrayWithKeyValuesArray:rep]];
        [dataAry bk_each:^(TaskTreeModel * obj) {
             NSString *pstr =obj.tid;
             NSString *ptype = [pstr substringToIndex:1];
            if ([ptype isEqualToString:@"p"]) {
                NSString *uid = [pstr substringFromIndex:1];
                if ([uid isEqualToString:[[SingalObj defaultManager].userInfoModel.userid stringValue]]){
                    my_selfTree =obj;
                    if ([my_selfTree.checknum intValue]>0) {
                        checknum_lb.hidden=NO;
                        checknum_lb.text=[my_selfTree.checknum stringValue];
                    }else{
                        checknum_lb.hidden=YES;
                    }
                    if ([my_selfTree.todonum intValue]>0) {
                        todonum_lb.hidden=NO;
                        todonum_lb.text=[my_selfTree.todonum stringValue];
                    }else{
                        todonum_lb.hidden=YES;
                    }
                }
            }
            obj.isExpanded=YES;
            obj.chlidren=[[NSMutableArray alloc]init];
        }];
        [dataAry enumerateObjectsUsingBlock:^(TaskTreeModel *tree, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([tree.pid isEqualToString:@"0"]) {
                TaskTreeModel *tempTree =tree;
                tempTree.creatLevle=0;
                tempTree.chlidren=[NSMutableArray array];
                [assemblyAry addObject:tempTree];
//                [dataAry removeObject:tree];
                [self nodeChildernpTree:tempTree];
            }
        }];
        
        [self fillDisplayArray];
        [treeTb reloadData];
        [treeTb.mj_header endRefreshing];
    }];
}
#pragma mark-----------获取展示数据-------
-(void)fillDisplayArray{
    displayAry=[[NSMutableArray alloc]init];
    for (TaskTreeModel *tree in assemblyAry) {
        [displayAry addObject:tree];
        if (tree.isExpanded==YES) {
            [self fillNodeWithChildrenArray:tree.chlidren];
        }
    }
    NSLog(@"%li",displayAry.count);
}
- (void)fillNodeWithChildrenArray:(NSMutableArray *)childrenArray{
    for (TaskTreeModel *tree in childrenArray) {
        [displayAry addObject:tree];
        if (tree.isExpanded==YES) {
            [self fillNodeWithChildrenArray:tree.chlidren];
        }
    }
}
#pragma mark-----------组装数据---------
-(void)nodeChildernpTree:(TaskTreeModel*)pTree
{
    [dataAry enumerateObjectsUsingBlock:^(TaskTreeModel *cTree, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([pTree.tid isEqualToString:cTree.pid]) {
            cTree.creatLevle=pTree.creatLevle+1;
            TaskTreeModel *tempTree =cTree;
            tempTree.chlidren=[[NSMutableArray alloc]init];
            [pTree.chlidren addObject:tempTree];
//            [dataAry removeObject:cTree];
            [self nodeChildernpTree:tempTree];
        }
    }];
}

#pragma mark -----------UITableViewDelegate---------------
//显示有多少个段
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//每个段有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayAry.count;
    
}
//设置行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskTreeModel *tree=[displayAry objectAtIndex:indexPath.row];
    NSString *pora =  [tree.tid substringToIndex:1];
    if ([pora isEqualToString:@"p"]) {
        static NSString *identifier = @"pCell";
        PCell *cell = (PCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[PCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate=self;
        }
        cell.taskTreeModel=tree;
        return cell;
    }else{
        static NSString *identifier = @"aCell";
        ACell *cell = (ACell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[ACell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate=self;
        }
        cell.taskTreeModel=tree;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     TaskTreeModel *tree=[displayAry objectAtIndex:indexPath.row];
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[PCell class]]) {//选择人员  进入人员列表
        NSString *pstr = tree.tid;
        NSString *uid = [pstr substringFromIndex:1];
        EnvPersonInfoVC *personInfo=[[EnvPersonInfoVC alloc]init];
        personInfo.userid=uid;
        personInfo.receiver=uid;
        personInfo.title=@"人员信息";
        UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
        [nav pushViewController:personInfo animated:YES];
    }else{
        //选择区域 进入任务列表
        NSString *pstr = tree.tid;
        NSString *uid = [pstr substringFromIndex:1];
        GegionVC *gegionvc=[[GegionVC alloc]init];
        gegionvc.regionid=uid;
        gegionvc.title=@"任务列表";
        UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
        [nav pushViewController:gegionvc animated:YES];
    }
}
#pragma mark-----------ACellDelegate------
-(void)selectUpOrDown:(TaskTreeModel *)taskTreeModel
{
    NSLog(@"%@",taskTreeModel.name);
    taskTreeModel.isExpanded=!taskTreeModel.isExpanded;
    [self fillDisplayArray];
    [treeTb reloadData];
}
#pragma mark----------PCellDelegate----------
-(void)pselectUpOrDown:(TaskTreeModel *)taskTreeModel
{
    NSLog(@"%@",taskTreeModel.name);
    taskTreeModel.isExpanded=!taskTreeModel.isExpanded;
    [self fillDisplayArray];
    [treeTb reloadData];
}
//进入任务列表
-(void)pselectrw:(TaskTreeModel *)taskTreeModel{
    TaskListViewController *taskList =[[TaskListViewController alloc]init];
    NSString *pstr = my_selfTree.tid;
    NSString *uid = [pstr substringFromIndex:1];
    taskList.receiver=uid;
    taskList.sendor=[taskTreeModel.tid substringFromIndex:1];
    taskList.status=@"2";
    taskList.title=@"任务列表";
    UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
    [nav pushViewController:taskList animated:YES];
}
//添加任务
-(void)pselectaddrw:(TaskTreeModel *)taskTreeModel{
    AddTaskViewController *addTask =[[AddTaskViewController alloc]init];
    addTask.title=@"新增任务";
    addTask.kind=@"1";
    addTask.callback=^(BOOL issu){
        if (issu==YES) {
            [self getMonitorTaskTree3];
        }
    };
    addTask.uid=[taskTreeModel.tid substringFromIndex:1];
    addTask.uname=taskTreeModel.name;
    UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
    [nav pushViewController:addTask animated:YES];

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
