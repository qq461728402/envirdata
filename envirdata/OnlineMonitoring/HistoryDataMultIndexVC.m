//
//  HistoryDataMultIndexVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/15.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "HistoryDataMultIndexVC.h"
#import "PGDatePickManager.h"
#import "PGDatePicker.h"
#import "HistoryDataModel.h"
@interface HistoryDataMultIndexVC ()<PGDatePickerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSString *time;//日期 格式：2018-04-03
@property (nonatomic,strong)PGDatePickManager *datePickManager;
@property (nonatomic,strong)UILabel *timetf;
@property (nonatomic,strong)UITableView *historyTb;
@property (nonatomic,strong)NSMutableArray *historyary;
@property (nonatomic,strong)NSArray *xjjary;
@property (nonatomic,strong)UIView *headerTitleView;
@end
@implementation HistoryDataMultIndexVC
@synthesize datePickManager,time,timetf,historyTb,historyary,xjjary,headerTitleView;
@synthesize uid,utype;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate * nowDate =[NSDate date];
    time = [nowDate stringWithFormat:@"yyyy-MM-dd"];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCALE(40))];
    [headerView setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    [self.view addSubview:headerView];
    CGSize size =[@"2017-12-12" sizeWithAttributes:@{NSFontAttributeName:Font(14)}];
    timetf =[[UILabel alloc]initWithFrame:CGRectMake(0, SCALE(5), size.width+10, SCALE(30))];
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
    UILabel *times=[[UILabel alloc]initWithFrame:CGRectMake(0, timetf.top, 60, timetf.height)];
    times.font=Font(14);
    times.text=@"时间：";
    times.textAlignment=NSTextAlignmentRight;
    times.right=timetf.left;
    [headerView addSubview:times];
    
    UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, headerView.bottom+0.5, headerView.width, 0.5)];
    [onelb setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [self.view addSubview:onelb];
    
    headerTitleView =[[UIView alloc]initWithFrame:CGRectMake(0, onelb.bottom, headerView.width, SCALE(20))];
    [headerTitleView setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    [self.view addSubview:headerTitleView];
    
    historyTb=[[UITableView alloc]initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    historyTb.translatesAutoresizingMaskIntoConstraints=NO;
    historyTb.delegate=self;
    historyTb.dataSource=self;
    [self.view addSubview:historyTb];
    __weak __typeof(self) weakSelf = self;//这里用一个弱引用来表示self，用于下面的Block中
    //先确定view_1的约束
    [historyTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(64+SCALE(61));
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left); //view_1de左，距离self.view是30px
    }];
    
    if (@available(iOS 11.0, *)) {
        historyTb.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    historyTb.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self gethistorDataIndex];
    // Do any additional setup after loading the view.
}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate * date = [calendar dateFromComponents:dateComponents];
    time = [date stringWithFormat:@"yyyy-MM-dd"];
    timetf.text=time;
    [self gethistorDataIndex];
}

-(void)gethistorDataIndex{
    [self networkPost:API_GETHISTORDATAMULTIINDEX parameter:@{@"uid":uid,@"utype":[utype numberValue],@"time":time} progresHudText:@"加载中..." completionBlock:^(id rep) {
        if ([rep isKindOfClass:[NSArray class]]) {
            NSMutableArray *key=[[NSMutableArray alloc]init];
            if ([rep count]>0) {
                NSDictionary * obj = [rep objectAtIndex:0];
                NSArray *allkeys=[obj allKeys];
                BOOL ispm25 = [allkeys containsObject:@"pm25"];
                BOOL ispm10 = [allkeys containsObject:@"pm10"];
                BOOL isso2 = [allkeys containsObject:@"so2"];
                BOOL isno2 = [allkeys containsObject:@"no2"];
                BOOL isco = [allkeys containsObject:@"co"];
                BOOL iso3 = [allkeys containsObject:@"o3"];
                if (ispm25==YES) {[key addObject:@"pm25"];}
                if (ispm10==YES) {[key addObject:@"pm10"];}
                if (isso2==YES) {[key addObject:@"so2"];}
                if (isno2==YES) {[key addObject:@"no2"];}
                if (isco==YES) { [key addObject:@"co"];}
                if (iso3==YES) {[key addObject:@"o3"];}
            }
            xjjary=[NSArray arrayWithArray:key];
            historyary = [HistoryDataModel mj_objectArrayWithKeyValuesArray:rep];
            [historyary bk_each:^(HistoryDataModel * obj) {
                obj.key=key;
            }];
            [headerTitleView removeAllSubviews];
            UILabel *namelb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCALE(95)+(6-xjjary.count)*SCALE(19), headerTitleView.height)];
            namelb.font=Font(14);
            namelb.text=@"时间";
            namelb.textAlignment=NSTextAlignmentCenter;
            namelb.adjustsFontSizeToFitWidth=YES;
            [headerTitleView addSubview:namelb];
            float itemW =(SCREEN_WIDTH-namelb.right)/xjjary.count;
            float left=namelb.right;
            for (int i=0; i<xjjary.count; i++) {
                UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(left, 0, itemW, namelb.height)];
                lb.font=Font(14);
                lb.textAlignment=NSTextAlignmentCenter;
                lb.adjustsFontSizeToFitWidth=YES;
                lb.text=[NSString stringWithFormat:@"%@",xjjary[i]];
                [headerTitleView addSubview:lb];
                left =lb.right;
            }
            [historyTb reloadData];
        }
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
    return historyary.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryDataModel *histroyData =[historyary objectAtIndex:indexPath.row];
    NSDictionary * dic =[histroyData mj_JSONObject];
    NSString *identifier = dic.description;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *namelb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCALE(95)+(6-histroyData.key.count)*SCALE(19), SCALE(35))];
        namelb.font=Font(14);
        namelb.text=histroyData.time;
        namelb.textAlignment=NSTextAlignmentCenter;
        namelb.adjustsFontSizeToFitWidth=YES;
        [cell.contentView addSubview:namelb];
        float itemW =(SCREEN_WIDTH-namelb.right)/histroyData.key.count;
        float left=namelb.right;
        for (int i=0; i<histroyData.key.count; i++) {
            NSString *keys =histroyData.key[i];
            UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(left, 0, itemW, namelb.height)];
            lb.font=Font(14);
            lb.textAlignment=NSTextAlignmentCenter;
            lb.adjustsFontSizeToFitWidth=YES;
            lb.text=[NSString stringWithFormat:@"%@",[histroyData valueForKey:keys]];
            [cell.contentView addSubview:lb];
            left =lb.right;
        }
        cell.contentView.height=SCALE(35);
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
