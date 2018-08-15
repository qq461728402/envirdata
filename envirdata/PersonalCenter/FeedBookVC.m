//
//  FeedBookVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/20.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "FeedBookVC.h"
#import "FeedBackModel.h"
#import "UITextViewPlaceHolder.h"
#import "FeedBookCell.h"
@interface FeedBookVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *feedbookTb;
@property (nonatomic,strong)NSArray *feedBackAry;
@property (nonatomic,strong)NSMutableArray *slelectAry;
@property (nonatomic,strong)UITextViewPlaceHolder *connent_tv;
@property (nonatomic,strong)NSMutableArray *seletLstAry;
@end

@implementation FeedBookVC
@synthesize connent_tv,feedbookTb,feedBackAry,slelectAry,seletLstAry;

-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    feedbookTb =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400) style:UITableViewStyleGrouped];
    feedbookTb.delegate=self;
    feedbookTb.dataSource=self;
    feedbookTb.translatesAutoresizingMaskIntoConstraints=YES;
    [self.view addSubview:feedbookTb];
    WEAKSELF
    [feedbookTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-200);
    }];
    connent_tv =[[UITextViewPlaceHolder alloc]init];
    connent_tv.placeholder=@"请输入意见";
    connent_tv.translatesAutoresizingMaskIntoConstraints=YES;
    [self.view addSubview:connent_tv];
    [connent_tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedbookTb.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-80);
    }];
    ViewBorderRadius(connent_tv, 4, 1, [UIColor colorWithRGB:0xedeeef]);
    UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ViewRadius(submitBtn, 8);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:SUBMIT_COLOR] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [submitBtn bk_addEventHandler:^(id sender) {
        [self submitBut];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(connent_tv.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-20);
    }];
    [self feedbookList];
    // Do any additional setup after loading the view.
}
-(void)submitBut{
    
    seletLstAry=[[NSMutableArray alloc]init];
    [slelectAry bk_each:^(NSIndexPath *selectIndexPath) {
       [seletLstAry addObject:feedBackAry[selectIndexPath.row]];
    }];
    
    NSArray *sid =[seletLstAry bk_map:^id(FeedBackModel *obj) {
        return obj.dkid;
    }];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSString *listids =[sid componentsJoinedByString:@","];
    
    if (![listids isNotBlank]&&![connent_tv.text isNotBlank]) {
        [self showMsgInfo:@"请输入或选择意见"];
        return;
    }
    NSDictionary *parameter;
    if (![listids isNotBlank]) {
        parameter =@{@"backs":connent_tv.text,@"userid":[SingalObj defaultManager].userInfoModel.userid,@"username":[SingalObj defaultManager].userInfoModel.username,@"versioncode":currentVersion};
    }else{
        parameter =@{@"listids":listids,@"backs":connent_tv.text,@"userid":[SingalObj defaultManager].userInfoModel.userid,@"username":[SingalObj defaultManager].userInfoModel.username,@"versioncode":currentVersion};
    }
    [self networkPost:API_SUBMITFEEDBACK parameter:parameter progresHudText:@"提交中..." completionBlock:^(id rep) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
        [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
    }];
}
-(void)gogo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)feedbookList{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    [self networkPost:API_GETFEEDBACKLIST parameter:@{@"dkey":@"problemType",@"version":currentVersion} progresHudText:@"加载中..." completionBlock:^(id rep) {
        slelectAry=[[NSMutableArray alloc]init];
        feedBackAry =[FeedBackModel mj_objectArrayWithKeyValuesArray:rep];
        [feedbookTb reloadData];
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
    return feedBackAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"cellId";
    FeedBookCell *cell =(FeedBookCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[FeedBookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    FeedBackModel *feenBackModel=feedBackAry[indexPath.row];
    cell.feedBackModel=feenBackModel;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取到点击的cell
    FeedBookCell *cell = (FeedBookCell*)[tableView cellForRowAtIndexPath:indexPath];
    FeedBackModel *feenBackModel=feedBackAry[indexPath.row];
    
    if (feenBackModel.isselect==YES) { //如果为选中状态
        feenBackModel.isselect=NO; //切换为未选中
        [slelectAry removeObject:indexPath]; //数据移除
    }else { //未选中
        feenBackModel.isselect=YES; //切换为选中
        [slelectAry addObject:indexPath]; //添加索引数据到数组
    }
    cell.feedBackModel=feenBackModel;
//    [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
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
