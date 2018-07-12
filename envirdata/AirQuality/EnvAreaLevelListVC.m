//
//  EnvAreaLevelListVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/12.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvAreaLevelListVC.h"
#import "AreaLevelModel.h"
@interface EnvAreaLevelListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *arealevelTb;
@property (nonatomic,strong)NSMutableArray *arelevelList;
@end

@implementation EnvAreaLevelListVC
@synthesize api,areaid,arealevelTb,arelevelList;


- (void)viewDidLayoutSubviews{
    if ([arealevelTb respondsToSelector:@selector(setSeparatorInset:)]) {
        [arealevelTb setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([arealevelTb respondsToSelector:@selector(setLayoutMargins:)]) {
        [arealevelTb setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    arelevelList=[[NSMutableArray alloc]init];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, SCALE(30))];
    [headerView setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    UILabel *namelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, headerView.height)];
    namelb.font=Font(14);
    namelb.text=@"名称";
    namelb.textColor=[UIColor colorWithRGB:0x2e4057];
    namelb.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:namelb];
    NSArray *itemAry=@[@"AQI",@"PM2.5",@"PM10",@"SO₂",@"NO₂",@"CO",@"O₃"];
    float offiesW =namelb.right;
    float itemW =(headerView.width-namelb.right)/7.0;
    for (int i=0; i<itemAry.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(offiesW+i*itemW, namelb.top, itemW, namelb.height)];
        label.text=itemAry[i];
        label.font=Font(14);
        label.textColor=[UIColor colorWithRGB:0x2e4057];
        label.textAlignment=NSTextAlignmentCenter;
        [headerView addSubview:label];
    }
    [self.view addSubview:headerView];
    arealevelTb=[[UITableView alloc]initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height-headerView.bottom)   style:UITableViewStyleGrouped];
    arealevelTb.delegate=self;
    arealevelTb.dataSource=self;
    [self.view addSubview:arealevelTb];
    __unsafe_unretained __typeof(self) weakSelf = self;
    arealevelTb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getnetworkInfo];
    }];
     [self getnetworkInfo];
    arealevelTb.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // Do any additional setup after loading the view.
}
-(void)getdataInfo{
    [self getnetworkInfo];
}
#pragma mark------------数据加载------------
-(void)getnetworkInfo{
    arelevelList=[[NSMutableArray alloc]init];
    NSDictionary *parmeter =@{@"areaid":areaid};
    [self networkPost:api parameter:parmeter progresHudText:nil completionBlock:^(id rep) {
        for (NSDictionary *repdic in rep) {
            AreaLevelModel *areaLevel = [AreaLevelModel mj_objectWithKeyValues:repdic];
            areaLevel.pm25=repdic[@"pm2.5"];
            [arelevelList addObject:areaLevel];
        }
        [arealevelTb.mj_header endRefreshing];
        [arealevelTb reloadData];
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
    return arelevelList.count;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
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
