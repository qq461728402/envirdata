//
//  ReportVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/19.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "ReportVC.h"
#import "LMJDropdownMenu.h"
#import "QRadioButton.h"
#import "ReportModel.h"
@interface ReportVC ()<LMJDropdownMenuDelegate,QRadioButtonDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)int page;
@property (nonatomic,strong)UITableView *reportTb;
@property (nonatomic,strong)NSMutableArray *reportAry;
@end

@implementation ReportVC
@synthesize roleid,page,typeId,timeType,sonTypeId,reportTb,reportAry;
- (void)viewDidLoad {
    [super viewDidLoad];
    roleid =[[SingalObj defaultManager].userInfoModel.roleid stringValue];
    page=1;
    timeType =@"2";//默认
    sonTypeId =@"0";
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALE(40))];
    [headerView setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    [self.view addSubview:headerView];
    //距离left
    float left=SCALE(8);
    if ([typeId intValue]==12) {
        LMJDropdownMenu * dropdownMenu = [[LMJDropdownMenu alloc] init];
        [dropdownMenu setFrame:CGRectMake(SCALE(8), SCALE(5), 130, SCALE(30))];
        [dropdownMenu setMenuTitles:@[@"全部分类",@"废弃物燃烧",@"扬尘污染",@"工业VOCS",@"生活污染"] rowHeight:35];
        dropdownMenu.delegate = self;
        [self.view addSubview:dropdownMenu];
        left=dropdownMenu.right+SCALE(8);
    }
    QRadioButton *weekQ=[[QRadioButton alloc]initWithDelegate:self groupId:@"js"];
    weekQ.tag=1000;
    weekQ.selected=YES;
    [weekQ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    weekQ.frame=CGRectMake(left, SCALE(5), 60, SCALE(30));
    [weekQ setTitle:@"周报" forState:UIControlStateNormal];
    weekQ.titleLabel.font=Font(14);
    [headerView addSubview:weekQ];
    
    QRadioButton *monthQ=[[QRadioButton alloc]initWithDelegate:self groupId:@"js"];
    monthQ.tag=1001;
    [monthQ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    monthQ.frame=CGRectMake(weekQ.right+SCALE(5), SCALE(5), 60, SCALE(30));
    [monthQ setTitle:@"月报" forState:UIControlStateNormal];
    monthQ.titleLabel.font=Font(14);
    [headerView addSubview:monthQ];
    if ([typeId intValue]==11) {
        QRadioButton *yearQ=[[QRadioButton alloc]initWithDelegate:self groupId:@"js"];
        yearQ.tag=1002;
        [yearQ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        yearQ.frame=CGRectMake(monthQ.right+SCALE(5), SCALE(5), 60, SCALE(30));
        [yearQ setTitle:@"年报" forState:UIControlStateNormal];
        yearQ.titleLabel.font=Font(14);
        [headerView addSubview:yearQ];
    }
    reportTb=[[UITableView alloc]initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    reportTb.translatesAutoresizingMaskIntoConstraints=NO;
    reportTb.delegate=self;
    reportTb.dataSource=self;
    [self.view addSubview:reportTb];
    WEAKSELF
    //先确定view_1的约束
    [reportTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(SCALE(40));
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    
    reportTb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [weakSelf getReportList:YES];
    }];
    reportTb.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf getReportList:YES];
    }];
    reportTb.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // Do any additional setup after loading the view.
}
- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"你选择了：%ld",number);
    sonTypeId=[NSString stringWithFormat:@"%ld",number];
    [reportTb.mj_header beginRefreshing];
}
-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    if ([groupId isEqualToString:@"js"]) {
        if (radio.tag==1000) {
            timeType =@"2";
        }else if (radio.tag==1001){
           timeType =@"3";
        }else if (radio.tag==1002){
            timeType =@"4";
        }
        [reportTb.mj_header beginRefreshing];
    }
}
-(void)getReportList:(BOOL)isrefrsh{
    
    NSMutableDictionary *paramter =[[NSMutableDictionary alloc]initWithDictionary:@{@"page":@(page),@"num":@(20),@"roleid":[roleid numberValue],@"typeId":[typeId numberValue],@"timeType":[timeType numberValue]}];
    if ([sonTypeId intValue]!=0) {
        [paramter setObject:[sonTypeId numberValue] forKey:@"sonTypeId"];
    }
    [self networkPost:API_GETREPORTLIST parameter:paramter progresHudText:(page==1&&isrefrsh==NO)?@"加载中...":nil completionBlock:^(id rep) {
        NSArray *reportList=[ReportModel mj_objectArrayWithKeyValuesArray:rep];
        if (page==1) {
            reportAry=[[NSMutableArray alloc]initWithArray:reportList];
            [reportTb.mj_header endRefreshing];
            [reportTb.mj_footer resetNoMoreData];
        }else{
            [reportAry addObjectsFromArray:reportList];
            [reportTb.mj_footer endRefreshing];
        }
        if (reportList.count<20) {
            [reportTb.mj_footer endRefreshingWithNoMoreData];
        }
        [reportTb reloadData];
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
    return reportAry.count;
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
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
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
