//
//  HistoryViolationPictureVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/15.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "HistoryViolationPictureVC.h"
#import "HistoryViolationCell.h"
#import "HistoryViolationPictureModel.h"
@interface HistoryViolationPictureVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *historyviltb;
@property (nonatomic,strong)NSArray *historyvilary;
@end

@implementation HistoryViolationPictureVC
@synthesize historyviltb,historyvilary;
@synthesize uid;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    historyviltb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    historyviltb.translatesAutoresizingMaskIntoConstraints=NO;
    historyviltb.delegate=self;
    historyviltb.dataSource=self;
    [self.view addSubview:historyviltb];
    __weak __typeof(self) weakSelf = self;//这里用一个弱引用来表示self，用于下面的Block中
    //先确定view_1的约束
    [historyviltb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left); //view_1de左，距离self.view是30px
    }];
    __unsafe_unretained __typeof(self) weakSelf1 = self;
    historyviltb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf1 gethistoryInfo:YES];
    }];
    historyviltb.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self gethistoryInfo:NO];
    // Do any additional setup after loading the view.
}
-(void)gethistoryInfo:(BOOL)isrefrsh{
    [self networkPost:API_GETHISTORYVIOLATIONPICTURE parameter:@{@"uid":uid} progresHudText:isrefrsh==NO?@"加载中...":nil completionBlock:^(id rep) {
        historyvilary = [HistoryViolationPictureModel mj_objectArrayWithKeyValuesArray:rep];
        [historyviltb reloadData];
        [historyviltb.mj_header endRefreshing];
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
    return historyvilary.count;
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
    HistoryViolationCell *cell = (HistoryViolationCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[HistoryViolationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.histroyViolation=historyvilary[indexPath.row];
    return cell;
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
