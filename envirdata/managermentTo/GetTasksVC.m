//
//  GetTasksVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/23.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "GetTasksVC.h"
#import "QRadioButton.h"
#import "ComplaintTasksModel.h"
#import "PatrolTasksModel.h"
#import "PatrolCell.h"
#import "ComplaintCell.h"
#import "AddPatrolTasksVC.h"
#import "AddgetComplaintTasksVC.h"
@interface GetTasksVC ()<QRadioButtonDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)UITableView *getTaskTb;
@property (nonatomic,assign) int page;
@property (nonatomic,strong)NSMutableArray *getTaskAry;
@end

@implementation GetTasksVC
@synthesize type,getTaskAry;
@synthesize status,getTaskTb,page;
- (void)viewDidLoad {
    [super viewDidLoad];
    status=@"1";
    page=1;
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALE(40))];
    [headerView setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    [self.view addSubview:headerView];
    
    QRadioButton *weekQ=[[QRadioButton alloc]initWithDelegate:nil groupId:[NSString stringWithFormat:@"js%@",type]];
    weekQ.tag=1000;
    [weekQ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    weekQ.frame=CGRectMake(SCALE(5), SCALE(5), 75, SCALE(30));
    [weekQ setTitle:@"待处理" forState:UIControlStateNormal];
    weekQ.titleLabel.font=Font(14);
    [headerView addSubview:weekQ];
    
    QRadioButton *monthQ=[[QRadioButton alloc]initWithDelegate:self groupId:[NSString stringWithFormat:@"js%@",type]];
    monthQ.tag=1001;
    [monthQ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    monthQ.frame=CGRectMake(weekQ.right+SCALE(5), SCALE(5), 75, SCALE(30));
    [monthQ setTitle:@"已处理" forState:UIControlStateNormal];
    monthQ.titleLabel.font=Font(14);
    [headerView addSubview:monthQ];
    weekQ.checked=YES;
    weekQ.delegate=self;
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame=CGRectMake(0, SCALE(5), SCALE(40), SCALE(30));
    addBtn.right=headerView.width-SCALE(5);
    addBtn.titleLabel.font=[UIFont fontWithName:@"iconfont" size:20];
    [addBtn setTitle:@"\U0000e622" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithRGB:0x02ddfd] forState:UIControlStateNormal];
    [addBtn bk_addEventHandler:^(id sender) {
        if ([type intValue]==1) {
            AddPatrolTasksVC *addpatrol=[[AddPatrolTasksVC alloc]init];
            addpatrol.title=@"现场巡查";
            addpatrol.callback=^(BOOL issu){
                if (issu==YES) {
                    [getTaskTb.mj_header beginRefreshing];
                }
            };
            if (self.callback) {
                self.callback(addpatrol);
            }
        }else if ([type intValue]==2){
            AddgetComplaintTasksVC *addcomplaint =[[AddgetComplaintTasksVC alloc]init];
            addcomplaint.title=@"新增投诉";
            addcomplaint.callback=^(BOOL issu){
                if (issu==YES) {
                    [getTaskTb.mj_header beginRefreshing];
                }
            };
            if (self.callback) {
                self.callback(addcomplaint);
            }
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addBtn];
    getTaskTb=[[UITableView alloc]initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, SCREEN_HEIGHT-headerView.bottom-49) style:UITableViewStyleGrouped];
    getTaskTb.translatesAutoresizingMaskIntoConstraints=NO;
    getTaskTb.delegate=self;
    getTaskTb.dataSource=self;
    [self.view addSubview:getTaskTb];
    WEAKSELF
    //先确定view_1的约束
    [getTaskTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(SCALE(40));
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    getTaskTb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [weakSelf gettasks:YES];
    }];
    getTaskTb.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf gettasks:YES];
    }];
    getTaskTb.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // Do any additional setup after loading the view.
}
-(void)gettasks:(BOOL)isrefsh{
    
     NSNumber *userId=[SingalObj defaultManager].userInfoModel.userid;
    NSMutableDictionary *paramter;
    NSString *url ;
    if ([type intValue]==1) {
         paramter =[[NSMutableDictionary alloc]initWithDictionary:@{@"status":[NSNumber numberWithString:status],@"num":@(20),@"page":[NSNumber numberWithInt:page],@"cuserid":userId}];
        url=API_GETPATROLTASKS;
    }else if ([type intValue]==2){
        paramter =[[NSMutableDictionary alloc]initWithDictionary:@{@"status":[NSNumber numberWithString:status],@"num":@(20),@"page":[NSNumber numberWithInt:page],@"cuser":userId}];
        url=API_GETCOMPLAINTTAKS;
    }
    [self networkPost:url parameter:paramter progresHudText:(page==1&&isrefsh==NO)?@"加载中...":nil  completionBlock:^(id rep) {
        NSArray *tempAry;
        if ([type intValue]==1) {
           tempAry =[PatrolTasksModel mj_objectArrayWithKeyValuesArray:rep];
        }else if ([type intValue]==2){
           tempAry =[ComplaintTasksModel mj_objectArrayWithKeyValuesArray:rep];
        }
        if (page==1) {
            getTaskAry=[[NSMutableArray alloc]initWithArray:tempAry];
            [getTaskTb.mj_header endRefreshing];
            [getTaskTb.mj_footer resetNoMoreData];
        }else{
            [getTaskAry addObjectsFromArray:tempAry];
            [getTaskTb.mj_footer endRefreshing];
        }
        if (tempAry.count<20) {
            [getTaskTb.mj_footer endRefreshingWithNoMoreData];
        }
        [getTaskTb reloadData];
    }];
}
-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    NSString *types= [NSString stringWithFormat:@"js%@",type];
    if ([groupId isEqualToString:types]) {
        if (radio.tag==1000) {
            status =@"1";
        }else if (radio.tag==1001){
            status =@"2";
        }
        [getTaskTb.mj_header beginRefreshing];
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
    return getTaskAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([type intValue]==1) {
        static NSString *identifier = @"PatrolCell";
        PatrolCell *cell = (PatrolCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[PatrolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.patrolTaskModel=getTaskAry[indexPath.row];
        return cell;
    }else if ([type intValue]==2){
        static NSString *identifier = @"PatrolCell";
        ComplaintCell *cell = (ComplaintCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[ComplaintCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.complaintTasksModel=getTaskAry[indexPath.row];
        return cell;
    }else{
        static NSString *identifier = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
