//
//  EnvTabBarController.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/11.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvTabBarController.h"
#import "EnvAirQualityVC.h"
#import "EnvOnlineMonVC.h"
#import "EnvManagerVC.h"
#import "EnvAnalysisReportVC.h"
#import "EnvPersonalCenterVC.h"
#import "MangerMentToVC.h"
#import "EnvAnalysisReportToVC.h"
#import "ViewController.h"
@interface EnvTabBarController ()<UITabBarControllerDelegate>
@end

@implementation EnvTabBarController

//- (void)viewWillLayoutSubviews{
//    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
//    tabFrame.size.height = 80;
//    tabFrame.origin.y = self.view.frame.size.height - 80;
//    self.tabBar.frame = tabFrame;
//    [self.tabBar bringSubviewToFront:self.bottomToolView];
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.selectedIndex!=4) {
        self.navigationController.navigationBar.hidden = YES;
    }else{
        self.navigationController.navigationBar.hidden = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent=NO;//设置背景颜色
    self.tabBar.barTintColor=COLOR_TAB_UNSELECT;//设置背景颜色
    
    NSArray *menuAry = USER_DEFAULTS(@"menuInfo");
    BOOL isglxt1 = [menuAry bk_match:^BOOL(NSDictionary *itemobj) {
        if ([itemobj[@"mark"] isEqualToString:@"glxt1"]) {
            return YES;
        }else{
            return NO;
        }
    }];
    EnvAirQualityVC *airQuality=[[EnvAirQualityVC alloc]init];
    airQuality.tabBarItem.title=@"空气质量";
    airQuality.tabBarItem.image=[PNGIMAGE(@"tab_kqzl") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [airQuality.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_Withe} forState:UIControlStateNormal];
    
    
    EnvOnlineMonVC *onlineMon=[[EnvOnlineMonVC alloc]init];
    onlineMon.tabBarItem.title=@"在线监控";
    onlineMon.tabBarItem.image=[PNGIMAGE(@"tab_wgjk") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [onlineMon.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_Withe} forState:UIControlStateNormal];
    
    
    
    EnvManagerVC * manager =[[EnvManagerVC alloc]init];
    manager.tabBarItem.title=@"管理协同";
    manager.tabBarItem.image=[PNGIMAGE(@"tab_xtgl") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [manager.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_Withe} forState:UIControlStateNormal];
    
    
    MangerMentToVC *mangermantTo =[[MangerMentToVC alloc]init];
    mangermantTo.tabBarItem.title=@"管理协同";
    mangermantTo.tabBarItem.image=[PNGIMAGE(@"tab_xtgl") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mangermantTo.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_Withe} forState:UIControlStateNormal];
    
    
    
    
    
    EnvAnalysisReportVC *analysisReport =[[EnvAnalysisReportVC alloc]init];
    analysisReport.tabBarItem.title=@"分析报告";
    analysisReport.tabBarItem.image=[PNGIMAGE(@"tab_fxbg") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [analysisReport.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_Withe} forState:UIControlStateNormal];
    
    EnvAnalysisReportToVC *analysisReportTo =[[EnvAnalysisReportToVC alloc]init];
    analysisReportTo.tabBarItem.title=@"分析报告";
    analysisReportTo.tabBarItem.image=[PNGIMAGE(@"tab_fxbg") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [analysisReportTo.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_Withe} forState:UIControlStateNormal];
    
    
    
    EnvPersonalCenterVC *personallCenter=[[EnvPersonalCenterVC alloc]init];
    personallCenter.tabBarItem.title=@"个人中心";
    personallCenter.title=@"个人中心";
    personallCenter.tabBarItem.image=[PNGIMAGE(@"tab_grzx") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [personallCenter.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_Withe} forState:UIControlStateNormal];
    
    self.tabBar.tintColor=COLOR_Withe;
    if (isglxt1==YES) {
         self.viewControllers=@[airQuality,onlineMon,manager,analysisReport,personallCenter];
    }else{
        self.viewControllers=@[airQuality,onlineMon,mangermantTo,analysisReportTo,personallCenter];
    }
    CGSize indicatorImageSize =CGSizeMake(self.tabBar.bounds.size.width/self.tabBar.items.count, self.tabBar.bounds.size.height);
    self.tabBar.selectionIndicatorImage=[UIImage imageWithColor:COLOR_TOP size:indicatorImageSize];
    self.delegate=self;
    // Do any additional setup after loading the view.
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [self.navigationItem setTitle:viewController.title];
    if (self.selectedIndex!=4) {
        self.navigationController.navigationBar.hidden = YES;
    }else{
        self.navigationController.navigationBar.hidden = NO;
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
