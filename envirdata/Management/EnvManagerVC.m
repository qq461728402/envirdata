//
//  EnvManagerVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/11.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvManagerVC.h"

@interface EnvManagerVC ()

@end

@implementation EnvManagerVC
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMonitorTaskTree3];
    // Do any additional setup after loading the view.
}
#pragma mark-----------添加树形结构-------
- (void)getMonitorTaskTree3{
    UserInfoModel *userfin=[SingalObj defaultManager].userInfoModel;
    [self networkPost:API_GETMONITORTASKTREE3 parameter:@{@"userid":userfin.userid} progresHudText:@"加载中..." completionBlock:^(id rep) {
        
    }];
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
