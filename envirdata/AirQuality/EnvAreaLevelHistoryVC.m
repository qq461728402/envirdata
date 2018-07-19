//
//  EnvAreaLevelHistoryVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/13.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvAreaLevelHistoryVC.h"
#import "QRadioButton.h"
#import "PGDatePickManager.h"
#import "PGDatePicker.h"
#import "AreaLevelModel.h"
#import "AreaLevelCell.h"
@interface EnvAreaLevelHistoryVC ()<PGDatePickerDelegate,QRadioButtonDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSString *timetype;//时间纬度 hour,week,month
@property (nonatomic,strong)NSString *time;//日期 格式：2018-04-03
@property (nonatomic,strong)UILabel *timetf;
@property (nonatomic,strong)UILabel *times;
@property (nonatomic,strong)PGDatePickManager *datePickManager;
@property (nonatomic,strong)PYEchartsView *pyEchartsView;
@property (nonatomic,strong)NSMutableArray *arelevelList;
@property (nonatomic,strong)UITableView *arealevelTb;
@end

@implementation EnvAreaLevelHistoryVC
@synthesize a_id,timetf,time,datePickManager,timetype,type,times,pyEchartsView,arelevelList,arealevelTb;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate * nowDate =[NSDate date];
    time = [nowDate stringWithFormat:@"yyyy-MM-dd"];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCALE(45))];
    [headerView setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    [self.view addSubview:headerView];
    QRadioButton *qradio=[[QRadioButton alloc]initWithDelegate:self groupId:@"js"];
    qradio.tag=1000;
    qradio.checked=YES;
    [qradio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    qradio.frame=CGRectMake(SCALE(10), SCALE(5), 40, SCALE(35));
    [qradio setTitle:@"日" forState:UIControlStateNormal];
    qradio.titleLabel.font=Font(14);
    [headerView addSubview:qradio];
    
    QRadioButton *qradio1=[[QRadioButton alloc]initWithDelegate:self groupId:@"js"];
    qradio1.tag=1001;
    [qradio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    qradio1.frame=CGRectMake(qradio.right+SCALE(10), SCALE(5), 40, SCALE(35));
    [qradio1 setTitle:@"周" forState:UIControlStateNormal];
    qradio1.titleLabel.font=Font(14);
    [headerView addSubview:qradio1];
    
    QRadioButton *qradio2=[[QRadioButton alloc]initWithDelegate:self groupId:@"js"];
    qradio2.tag=1002;
    [qradio2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    qradio2.frame=CGRectMake(qradio1.right+SCALE(10), SCALE(5), 40, SCALE(35));
    [qradio2 setTitle:@"月" forState:UIControlStateNormal];
    qradio2.titleLabel.font=Font(14);
    [headerView addSubview:qradio2];
    
    
    CGSize size =[@"2017-12-12" sizeWithAttributes:@{NSFontAttributeName:Font(14)}];
    
    timetf =[[UILabel alloc]initWithFrame:CGRectMake(0, qradio2.top, size.width+10, qradio2.height)];
    timetf.textAlignment=NSTextAlignmentCenter;
    [timetf setBackgroundColor:[UIColor whiteColor]];
    ViewRadius(timetf, 4);
    timetf.font=Font(14);
    timetf.userInteractionEnabled=YES;
    [timetf bk_whenTapped:^{
        if (!datePickManager) {
            datePickManager = [[PGDatePickManager alloc]init];
            datePickManager.isShadeBackgroud = true;
            datePickManager.style = PGDatePickManagerStyle3;
            PGDatePicker *datePicker = datePickManager.datePicker;
            datePicker.delegate = self;
            [datePicker setDate:[NSDate date]];
            datePicker.datePickerType = PGPickerViewType1;
            datePicker.isHiddenMiddleText = false;
            datePicker.isHiddenWheels = false;
            datePicker.datePickerMode = PGDatePickerModeDate;
        }
        [self presentViewController:datePickManager animated:false completion:nil];
    }];
    timetf.right=SCREEN_WIDTH-SCALE(10);
    [headerView addSubview:timetf];
    timetf.text=time;
    times=[[UILabel alloc]initWithFrame:CGRectMake(0, timetf.top, 60, timetf.height)];
    times.font=Font(14);
    times.text=@"时间：";
    times.textAlignment=NSTextAlignmentRight;
    times.right=timetf.left;
    [headerView addSubview:times];
    pyEchartsView=[[PYEchartsView alloc]initWithFrame:CGRectMake(0,headerView.bottom+10, SCREEN_WIDTH, SCALE(230))];
    [self.view addSubview:pyEchartsView];
   
    UIView *headerView3=[[UIView alloc]initWithFrame:CGRectMake(0, pyEchartsView.bottom, SCREEN_WIDTH, SCALE(30))];
    [headerView3 setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    UILabel *namelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, headerView3.height)];
    namelb.font=Font(14);
    namelb.text=@"时间";
    namelb.textColor=[UIColor colorWithRGB:0x2e4057];
    namelb.textAlignment=NSTextAlignmentCenter;
    [headerView3 addSubview:namelb];
    NSArray *itemAry=@[@"AQI",@"PM2.5",@"PM10",@"SO₂",@"NO₂",@"CO",@"O₃"];
    float offiesW =namelb.right;
    float itemW =(headerView.width-namelb.right)/7.0;
    for (int i=0; i<itemAry.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(offiesW+i*itemW, namelb.top, itemW, namelb.height)];
        label.text=itemAry[i];
        label.font=Font(14);
        label.textColor=[UIColor colorWithRGB:0x2e4057];
        label.textAlignment=NSTextAlignmentCenter;
        [headerView3 addSubview:label];
    }
    [self.view addSubview:headerView3];
    
    arealevelTb=[[UITableView alloc]initWithFrame:CGRectMake(0, headerView3.bottom+SCALE(5), self.view.width, self.view.height) style:UITableViewStyleGrouped];
    arealevelTb.translatesAutoresizingMaskIntoConstraints=NO;
    arealevelTb.delegate=self;
    arealevelTb.dataSource=self;
    [self.view addSubview:arealevelTb];
    __weak __typeof(self) weakSelf = self;//这里用一个弱引用来表示self，用于下面的Block中
    [arealevelTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(SCALE(305)+74);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left); //view_1de左，距离self.view是30px
    }];
     [self.view addSubview:arealevelTb];
    arealevelTb.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // Do any additional setup after loading the view.
}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate * date = [calendar dateFromComponents:dateComponents];
    time = [date stringWithFormat:@"yyyy-MM-dd"];
    timetf.text=time;
    [self getHistoryValueData];
}
-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    if ([groupId isEqualToString:@"js"]) {
        if (radio.tag==1000) {
            timetype=@"hour";
            times.hidden=NO;
            timetf.hidden=NO;
        }else if (radio.tag==1001){
            times.hidden=YES;
            timetf.hidden=YES;
            timetype=@"week";
        }else if (radio.tag==1002){
            times.hidden=YES;
            timetf.hidden=YES;
            timetype=@"month";
        }
        [self getHistoryValueData];
    }
}
#pragma mark-----------请求数据---------
-(void)getHistoryValueData{
    arelevelList=[[NSMutableArray alloc]init];
    NSMutableArray *pm25=[NSMutableArray array];
    NSMutableArray *pm10=[NSMutableArray array];
    NSMutableArray *so=[NSMutableArray array];
    NSMutableArray *no=[NSMutableArray array];
    NSMutableArray *co=[NSMutableArray array];
    NSMutableArray *o3=[NSMutableArray array];
    NSMutableArray *time1=[NSMutableArray array];
    NSDictionary *prarmter=@{@"id":a_id,@"time":time,@"timetype":timetype,@"type":type};
    [self networkPost:API_GETHISTORYVALUEDATA parameter:prarmter progresHudText:@"加载中..." completionBlock:^(id rep) {
        for (NSDictionary *repdic in rep) {
            AreaLevelModel *areaLevel = [AreaLevelModel mj_objectWithKeyValues:repdic];
            areaLevel.pm25=repdic[@"pm2.5"];
            [arelevelList addObject:areaLevel];
            [pm25 addObject:areaLevel.pm25];
            [pm10 addObject:areaLevel.pm10];
            [so addObject:areaLevel.so2];
            [no addObject:areaLevel.no2];
            [co addObject:areaLevel.co];
            [o3 addObject:areaLevel.o3];
            if ([timetype isEqualToString:@"hour"]) {
                areaLevel.showtime=[[NSDate dateWithString:areaLevel.time format:@"yyyy-MM-dd HH"] stringWithFormat:@"MM-dd HH"];
                [time1 addObject:[[NSDate dateWithString:areaLevel.time format:@"yyyy-MM-dd HH"] stringWithFormat:@"HH:mm"]];
            }else{
                areaLevel.showtime=[[NSDate dateWithString:areaLevel.time format:@"yyyy-MM-dd"] stringWithFormat:@"MM-dd HH"];
                [time1 addObject:[[NSDate dateWithString:areaLevel.time format:@"yyyy-MM-dd"] stringWithFormat:@"yyyy-MM-dd"]];
            }
        }
        [pyEchartsView setOption:[self irregularLineOption:pm25 :pm10 :so :no :co :o3 :time1]];
        [pyEchartsView loadEcharts];
        [arealevelTb reloadData];
    }];
}

#pragma mark-----------setoption------------------
- (PYOption *)irregularLineOption:(NSMutableArray*)pm25 :(NSMutableArray*)pm10 :(NSMutableArray*)so :(NSMutableArray*)no :(NSMutableArray*)co :(NSMutableArray*)o3 :(NSMutableArray*)time1 {
    PYEventRiverSeries *pm25series = [PYEventRiverSeries initPYEventRiverSeriesWithBlock:^(PYEventRiverSeries *series) {
        series.name = @"PM2.5";
        series.type = PYSeriesTypeLine;
        series.dataEqual(pm25);
    }];
    PYEventRiverSeries *pm10series = [PYEventRiverSeries initPYEventRiverSeriesWithBlock:^(PYEventRiverSeries *series) {
        series.name = @"PM10";
        series.type = PYSeriesTypeLine;
        series.dataEqual(pm10);
    }];
    PYEventRiverSeries *soseries = [PYEventRiverSeries initPYEventRiverSeriesWithBlock:^(PYEventRiverSeries *series) {
        series.name = @"SO₂";
        series.type = PYSeriesTypeLine;
        series.dataEqual(so);
    }];
    
    PYEventRiverSeries *noseries = [PYEventRiverSeries initPYEventRiverSeriesWithBlock:^(PYEventRiverSeries *series) {
        series.name = @"NO₂";
        series.type = PYSeriesTypeLine;
        series.dataEqual(no);
    }];
    PYEventRiverSeries *coseries = [PYEventRiverSeries initPYEventRiverSeriesWithBlock:^(PYEventRiverSeries *series) {
        series.name = @"CO";
        series.type = PYSeriesTypeLine;
        series.dataEqual(co);
    }];
    PYEventRiverSeries *oseries = [PYEventRiverSeries initPYEventRiverSeriesWithBlock:^(PYEventRiverSeries *series) {
        series.name = @"O₃";
        series.type = PYSeriesTypeLine;
        series.dataEqual(o3);
    }];
    
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerAxis);
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.dataEqual(@[@"PM2.5",@"PM10",@"SO₂",@"NO₂",@"CO",@"O₃"]);
            legend.yEqual(PYPositionBottom);
        }])
        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
            toolbox.showEqual(NO);
            toolbox.yEqual(PYPositionBottom);
        }])
        .calculableEqual(YES)
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.y=@(25);
            grid.x=@(30);
            grid.y2=@(50);
            grid.x2=@(30);
        }])
        
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory)
            .boundaryGapEqual(@NO).addDataArr(time1);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue);
        }])
        .seriesEqual([NSMutableArray arrayWithArray:@[pm25series,pm10series,soseries,noseries,coseries,oseries]]);
    }];
    
//    .dataZoomEqual([PYDataZoom initPYDataZoomWithBlock:^(PYDataZoom *dataZoom) {
//        dataZoom.showEqual(o3.count>10)
//        .backgroundColorEqual([PYColor colorWithHexString:@"#ffffff"])
//        .dataBackgroundColorEqual([PYColor colorWithHexString:@"bebebe"])
//        .realtimeEqual(YES)
//        .startEqual(@0)
//        .heightEqual(@20)
//        .endEqual(@20)
//        .yEqual(@0);
//    }])
    
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
    AreaLevelCell *cell = (AreaLevelCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[AreaLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isTime=YES;
    }
    cell.areaLevelModel=arelevelList[indexPath.row];
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
