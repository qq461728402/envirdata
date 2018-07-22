//
//  EnvChooseListVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/18.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvChooseListVC.h"
#import "TaskTreeModel.h"
#import "PCell.h"
#import "ACell.h"
@interface EnvChooseListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *assemblyAry;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)NSMutableArray *displayAry;
@property (nonatomic,strong)UITableView *treeTb;
@end

@implementation EnvChooseListVC
@synthesize assemblyAry,dataAry,treeTb,displayAry;
- (void)viewDidLoad {
    [super viewDidLoad];
    treeTb =[[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT)];
    treeTb.delegate=self;
    treeTb.dataSource=self;
    treeTb.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:treeTb];
    WEAKSELF
    //先确定view_1的约束
    [treeTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
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
        [dataAry enumerateObjectsUsingBlock:^(TaskTreeModel *tree, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([tree.pid isEqualToString:@"0"]) {//表示第一层
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
            cell.isChoose=YES;
        }
        cell.taskTreeModel=tree;
        return cell;
    }else{
        static NSString *identifier = @"aCell";
        ACell *cell = (ACell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[ACell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.isChoose=YES;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.taskTreeModel=tree;
        return cell;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TaskTreeModel *tree=[displayAry objectAtIndex:indexPath.row];
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[PCell class]]) {
        if (self.delegate) {
            NSString *userId =  [tree.tid substringFromIndex:1];
            [self.delegate selelctPerson:userId userName:tree.name];
            [self.navigationController popViewControllerAnimated:YES];
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
