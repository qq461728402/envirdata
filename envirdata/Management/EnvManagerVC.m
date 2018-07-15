//
//  EnvManagerVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/11.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvManagerVC.h"
#import "TaskTreeModel.h"
@interface EnvManagerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *assemblyAry;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)NSMutableArray *displayAry;
@property (nonatomic,strong)UITableView *treeTb;
@end

@implementation EnvManagerVC
@synthesize displayAry,dataAry,assemblyAry,treeTb;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [view setBackgroundColor:COLOR_TOP];
    [self.view addSubview:view];
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, view.bottom, SCREEN_WIDTH, 44)];
    [headerView setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    [self.view addSubview:headerView];

    UIButton *wddbbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wddbbtn.frame=CGRectMake(0, 7, 75, 30);
    [wddbbtn bootstrapNoborderStyle:[UIColor clearColor] titleColor:[UIColor colorWithRGB:0x2e4057] andbtnFont:Font(14)];
    ViewBorderRadius(wddbbtn, 4, 1, COLOR_TOP);
    [wddbbtn setTitle:@"我的待办" forState:UIControlStateNormal];
    
    [headerView addSubview:wddbbtn];
    wddbbtn.centerX=SCREEN_WIDTH/8.0;
    
    
    UIButton *wdshbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wdshbtn.frame=CGRectMake(0, 7, 75, 30);
    [wdshbtn bootstrapNoborderStyle:[UIColor clearColor] titleColor:[UIColor colorWithRGB:0x2e4057] andbtnFont:Font(14)];
    ViewBorderRadius(wdshbtn, 4, 1, COLOR_TOP);
    [wdshbtn setTitle:@"我的审核" forState:UIControlStateNormal];
    [headerView addSubview:wdshbtn];
    
    wdshbtn.centerX=SCREEN_WIDTH/8.0*3;
    
    UIButton *wdgjbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wdgjbtn.frame=CGRectMake(0, 7, 75, 30);
    [wdgjbtn bootstrapNoborderStyle:[UIColor clearColor] titleColor:[UIColor colorWithRGB:0x2e4057] andbtnFont:Font(14)];
    ViewBorderRadius(wdgjbtn, 4, 1, COLOR_TOP);
    [wdgjbtn setTitle:@"我的轨迹" forState:UIControlStateNormal];
    [headerView addSubview:wdgjbtn];
    
    wdgjbtn.centerX=SCREEN_WIDTH/8.0*5;
    
    UIButton *xzrwbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    xzrwbtn.frame=CGRectMake(0, 7, 75, 30);
    [xzrwbtn bootstrapNoborderStyle:[UIColor clearColor] titleColor:[UIColor colorWithRGB:0x2e4057] andbtnFont:Font(14)];
    ViewBorderRadius(xzrwbtn, 4, 1, COLOR_TOP);
    [xzrwbtn setTitle:@"新增任务" forState:UIControlStateNormal];
    [headerView addSubview:xzrwbtn];
    xzrwbtn.centerX=SCREEN_WIDTH/8.0*7;
    
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
#pragma mark-----------添加树形结构-------
- (void)getMonitorTaskTree3{
    assemblyAry=[[NSMutableArray alloc]init];
    UserInfoModel *userfin=[SingalObj defaultManager].userInfoModel;
    [self networkPost:API_GETMONITORTASKTREE3 parameter:@{@"userid":userfin.userid} progresHudText:@"加载中..." completionBlock:^(id rep) {
        //数据源
        dataAry =[[NSMutableArray alloc] initWithArray:[TaskTreeModel mj_objectArrayWithKeyValuesArray:rep]];
        [dataAry bk_each:^(TaskTreeModel * obj) {
            obj.isExpanded=YES;
            obj.chlidren=[[NSMutableArray alloc]init];
        }];
        for (TaskTreeModel *tree in dataAry) {
            if ([tree.level isEqualToString:@"city"]) {
                [assemblyAry addObject:tree];
                [self nodeChildernpTree:tree];
            }
        }
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
    for (TaskTreeModel *cTree in dataAry) {
        if ([pTree.tid isEqualToString:cTree.pid]) {
            [pTree.chlidren addObject:cTree];
            [self nodeChildernpTree:cTree];
        }
    }
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
    static NSString *identifier = @"NoticeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    TaskTreeModel *tree=[displayAry objectAtIndex:indexPath.row];
    cell.textLabel.text=tree.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskTreeModel *tree=[displayAry objectAtIndex:indexPath.row];
    tree.isExpanded=!tree.isExpanded;
    [self fillDisplayArray];
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
