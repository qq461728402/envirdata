//
//  EnvTabBarController.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/11.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvTabBarController.h"
#import "ViewController.h"
@interface EnvTabBarController ()<UITabBarControllerDelegate>

@end

@implementation EnvTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ViewController *v1=[[ViewController alloc]init];
    v1.tabBarItem.title=@"首页";
    v1.tabBarItem.image=PNGIMAGE(@"home");
    [v1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TOP} forState:UIControlStateSelected];
    [v1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TAB_UNSELECT} forState:UIControlStateNormal];
    
    UINavigationController *v1nav=[[UINavigationController alloc]initWithRootViewController:v1];
    
    self.tabBar.tintColor=COLOR_TOP;
    self.viewControllers=@[v1nav];
    // Do any additional setup after loading the view.
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [self.navigationItem setTitle:viewController.title];
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
