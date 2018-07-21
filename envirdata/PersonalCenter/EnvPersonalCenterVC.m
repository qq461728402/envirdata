//
//  EnvPersonalCenterVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/11.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvPersonalCenterVC.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"
#import "HelpBookVC.h"
#import "FeedBookVC.h"
#import "AboutUsVC.h"
#import <Mcu_sdk/MCUVmsNetSDK.h>
#import "VersionModel.h"
@interface EnvPersonalCenterVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *personary;
@property (nonatomic,strong)UITableView *settingTb;
@property (nonatomic,strong)UserInfoModel *userInfo;
@end

@implementation EnvPersonalCenterVC
@synthesize personary,settingTb,userInfo;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo=[SingalObj defaultManager].userInfoModel;
    personary =@[@[@"当前登录账号",@"所属单位"],@[@"最新通知"],@[@"当前版本"],@[@"意见反馈",@"帮助中心",@"关于我们"],@[@"退出登录"]];
    settingTb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    settingTb.translatesAutoresizingMaskIntoConstraints=NO;
    settingTb.delegate=self;
    settingTb.dataSource=self;
    [self.view addSubview:settingTb];
    WEAKSELF //这里用一个弱引用来表示self，用于下面的Block中
    //先确定view_1的约束
    [settingTb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left); //view_1de左，距离self.view是30px
    }];
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return personary.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [personary[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *itemStr=personary[indexPath.section][indexPath.row];
    static NSString *cellId = @"baseInfo";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    [[cell.contentView subviews] bk_each:^(id sender) {
        [(UIView *)sender removeFromSuperview];
    }];
    cell.backgroundColor = [UIColor whiteColor];
    if ([itemStr isEqualToString:@"退出登录"]){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *leb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        leb.font=Font(16);
        leb.backgroundColor=API_LEVEL3;
        leb.textColor=[UIColor whiteColor];
        leb.text=itemStr;
        leb.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:leb];
    }else if([itemStr isEqualToString:@"当前登录账号"]){
        cell.textLabel.font=Font(16);
        cell.textLabel.text=itemStr;
        UILabel *xxlb=[[UILabel alloc]initWithFrame:CGRectMake(200, 0, 100, 44)];
        xxlb.right=SCREEN_WIDTH-8;
        xxlb.font=Font(16);
        xxlb.textAlignment=NSTextAlignmentRight;
        xxlb.text=userInfo.passport;
         [cell.contentView addSubview:xxlb];
    }else if([itemStr isEqualToString:@"所属单位"]){
        cell.textLabel.font=Font(16);
        cell.textLabel.text=itemStr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *xxlb=[[UILabel alloc]initWithFrame:CGRectMake(200, 0, 100, 44)];
        xxlb.right=SCREEN_WIDTH-8;
        xxlb.font=Font(16);
        xxlb.textAlignment=NSTextAlignmentRight;
        xxlb.text=userInfo.areaname;
        [cell.contentView addSubview:xxlb];
    }else if([itemStr isEqualToString:@"最新通知"]){
        cell.textLabel.font=Font(16);
        cell.textLabel.text=itemStr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchs = [[UISwitch alloc] initWithFrame:CGRectMake(0, 7, 100, 30)];
        switchs.right=SCREEN_WIDTH-8;
        [switchs setOn:YES];
        [switchs bk_addEventHandler:^(UISwitch *sender) {
            
        } forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchs];
    }else{
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font=Font(16);
        cell.textLabel.text=itemStr;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *itemStr=personary[indexPath.section][indexPath.row];
    if ([itemStr isEqualToString:@"退出登录"]) {
        UIAlertView *outlogin=[UIAlertView bk_showAlertViewWithTitle:@"温馨提示" message:@"确定退出登录" cancelButtonTitle:@"确定" otherButtonTitles:@[@"取消"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userInfo"];
                [[AppDelegate Share] gotologin];
                //退出海康威视
                [[MCUVmsNetSDK shareInstance] logoutMsp:^(id object) {
                    NSLog(@"%@,",[object mj_JSONObject]);
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
        [outlogin show];
    }else if ([@"帮助中心" isEqualToString:itemStr]){
        HelpBookVC *helpBook=[[HelpBookVC alloc]init];
        helpBook.title=itemStr;
        UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
        [nav pushViewController:helpBook animated:YES];
    }else if ([@"意见反馈" isEqualToString:itemStr]){
        FeedBookVC *helpBook=[[FeedBookVC alloc]init];
        helpBook.title=itemStr;
        UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
        [nav pushViewController:helpBook animated:YES];
    }else if ([@"关于我们" isEqualToString:itemStr]){
        AboutUsVC *helpBook=[[AboutUsVC alloc]init];
        helpBook.title=itemStr;
        UINavigationController *nav =(UINavigationController*)self.view.window.rootViewController;
        [nav pushViewController:helpBook animated:YES];
    }else if ([@"当前版本" isEqualToString:itemStr]){
        [self networkPost:API_GETVERSION parameter:@{@"apptype":@(1)} progresHudText:@"加载中..." completionBlock:^(id rep) {
            
            VersionModel *versionModel=[[VersionModel alloc]init];
            if ([rep isKindOfClass:[NSArray class]]) {
                NSArray * versonAry=[VersionModel mj_objectArrayWithKeyValuesArray:rep];
                if (versonAry.count>0) {
                    versionModel=versonAry[0];
                }
            }else{
                versionModel = [VersionModel mj_objectWithKeyValues:rep];
            }
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            if (![versionModel.versioncode isEqualToString:currentVersion]) {
                UIAlertView *alert=[UIAlertView bk_showAlertViewWithTitle:@"温馨提示" message:versionModel.descript cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex==1) {
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:versionModel.url]];
                    }
                }];
                [alert show];
            }
        }];
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
