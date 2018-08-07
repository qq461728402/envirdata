//
//  GegionVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/17.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "GegionVC.h"
#import "GegionModel.h"
#import "GegionCell.h"
#import "GegionDetialVC.h"
@interface GegionVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *gegionTb;
@property (nonatomic,strong)NSArray *gegionAry;
@end

@implementation GegionVC
@synthesize gegionTb,gegionAry;
@synthesize regionid;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    gegionTb =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    gegionTb.translatesAutoresizingMaskIntoConstraints=NO;
    gegionTb.delegate=self;
    gegionTb.dataSource=self;
    [self.view addSubview:gegionTb];
    WEAKSELF
    //先确定view_1的约束
    [gegionTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    gegionTb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getREgionTaskList:YES];
    }];
    gegionTb.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self getREgionTaskList:NO];
    
    // Do any additional setup after loading the view.
}
-(void)getREgionTaskList:(BOOL)isrefrsh{
    [self networkPost:API_GETREGIONTASKLIST parameter:@{@"regionid":[regionid numberValue]} progresHudText:isrefrsh==NO?@"加载中...":nil completionBlock:^(id rep) {
        gegionAry=[GegionModel mj_objectArrayWithKeyValuesArray:rep];
        [gegionTb reloadData];
         [gegionTb.mj_header endRefreshing];
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
    return gegionAry.count;
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
    GegionCell *cell = (GegionCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[GegionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.gegionModel=gegionAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isonlylook==NO) {
        GegionDetialVC *gegionDetail=[[GegionDetialVC alloc]init];
        gegionDetail.title=@"任务详情";
        gegionDetail.gegionModel=gegionAry[indexPath.row];
        [self.navigationController pushViewController:gegionDetail animated:YES];
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
