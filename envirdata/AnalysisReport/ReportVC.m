//
//  ReportVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/19.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "ReportVC.h"
#import "ReportModel.h"
#import "ReportCell.h"
#import <QuickLook/QuickLook.h>
@interface ReportVC ()<LMJDropdownMenuDelegate,QRadioButtonDelegate,UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate,QLPreviewControllerDataSource>
@property (nonatomic,assign)int page;
@property (nonatomic,strong)UITableView *reportTb;
@property (nonatomic,strong)NSMutableArray *reportAry;
@property (nonatomic,strong)QLPreviewController  *documentController;
@property (nonatomic,strong)NSString *openURL;
@property (nonatomic,strong)NSArray *typeAry;

@property (nonatomic,strong)UIView *bgView;
@end

@implementation ReportVC
@synthesize roleid,page,typeId,timeType,sonTypeId,reportTb,reportAry,typeAry,dropdownMenu,bgView,weekQ;
- (void)viewDidLoad {
    [super viewDidLoad];
    roleid =[[SingalObj defaultManager].userInfoModel.roleid stringValue];
    page=1;
    timeType =@"2";//默认
    sonTypeId =@"0";
    typeAry=@[@"全部分类",@"扬尘污染",@"生物质燃烧",@"工业VOCS",@"生活污染"];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALE(40))];
    [headerView setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    [self.view addSubview:headerView];
    //距离left
    float left=SCALE(8);
    if ([typeId intValue]==12) {
        dropdownMenu = [[LMJDropdownMenu alloc] init];
        [dropdownMenu setFrame:CGRectMake(SCALE(8), SCALE(5), 130, SCALE(30))];
        [dropdownMenu setMenuTitles:typeAry rowHeight:35];
        dropdownMenu.delegate = self;
        [self.view addSubview:dropdownMenu];
        left=dropdownMenu.right+SCALE(8);
    }
    weekQ=[[QRadioButton alloc]initWithDelegate:nil groupId:[NSString stringWithFormat:@"js%@",typeId]];
    weekQ.tag=1000;
    [weekQ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    weekQ.frame=CGRectMake(left, SCALE(5), 60, SCALE(30));
    [weekQ setTitle:@"周报" forState:UIControlStateNormal];
    weekQ.titleLabel.font=Font(14);
    [headerView addSubview:weekQ];
    
    QRadioButton *monthQ=[[QRadioButton alloc]initWithDelegate:self groupId:[NSString stringWithFormat:@"js%@",typeId]];
    monthQ.tag=1001;
    [monthQ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    monthQ.frame=CGRectMake(weekQ.right+SCALE(5), SCALE(5), 60, SCALE(30));
    [monthQ setTitle:@"月报" forState:UIControlStateNormal];
    monthQ.titleLabel.font=Font(14);
    [headerView addSubview:monthQ];
    if ([typeId intValue]==11) {
        QRadioButton *yearQ=[[QRadioButton alloc]initWithDelegate:self groupId:[NSString stringWithFormat:@"js%@",typeId]];
        yearQ.tag=1002;
        [yearQ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        yearQ.frame=CGRectMake(monthQ.right+SCALE(5), SCALE(5), 60, SCALE(30));
        [yearQ setTitle:@"年报" forState:UIControlStateNormal];
        yearQ.titleLabel.font=Font(14);
        [headerView addSubview:yearQ];
    }
    weekQ.checked=YES;
    weekQ.delegate=self;
    reportTb=[[UITableView alloc]initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, SCREEN_HEIGHT-headerView.bottom-49) style:UITableViewStyleGrouped];
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
    if (@available(iOS 11.0, *)) {
        reportTb.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    reportTb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [dropdownMenu hideDropDown];
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
    NSString *types= [NSString stringWithFormat:@"js%@",typeId];
    if ([groupId isEqualToString:types]) {
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
    ReportCell *cell = (ReportCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[ReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.reportModel=reportAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReportModel *repotModel = reportAry[indexPath.row];
    [SVProgressHUD showWithStatus:@"文件打开中..."];
    self.openURL=[self saveFile:repotModel.url];
    [SVProgressHUD dismiss];
    _documentController = [[QLPreviewController alloc]init];
    _documentController.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
//    _documentController.navigationController.navigationBar.barTintColor = [UIColor redColor];
    _documentController.dataSource = self;// 遵循代理
    // 直接打开预览文档
    UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
   [nav presentViewController:_documentController animated:YES completion:nil];
}
#pragma mark------------存入文件--------
-(NSString *)saveFile:(NSString*)url{
    NSArray *array = [url componentsSeparatedByString:@"/"]; //从字符/中分隔成多个元素的数组
    NSString *fileName = [array lastObject];
    //文件路劲
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath =[NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //存入文件
    if (![fileManager fileExistsAtPath:filePath]) {
        NSURL *targetURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSError* err = nil;
        NSData* fileData = [[NSData alloc] initWithContentsOfURL:targetURL options:NSDataReadingUncached error:&err];
        [fileData writeToFile:filePath atomically:YES];
    }
    return filePath;
}
#pragma mark QLPreviewControllerDataSource
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:self.openURL];
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
