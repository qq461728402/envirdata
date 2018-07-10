//
//  LoginVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/3.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC
- (void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [self networkGet:INDEX_CONFIG parameter:@{} progresHudText:@"加载中..." completionBlock:^(id rep) {
        
    }];
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    [lable setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:lable];
    
    UILabel *lables=[[UILabel alloc]initWithFrame:CGRectMake(120, 100, 100, 30)];
    lables.font=[UIFont fontWithName:@"iconfont" size:30];
    lables.text =@"\U0000e609";
    lables.textColor=[UIColor redColor];
    [self.view addSubview:lables];
    // Do any additional setup after loading the view.
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
