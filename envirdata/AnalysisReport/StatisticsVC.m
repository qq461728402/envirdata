//
//  StatisticsVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/19.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "StatisticsVC.h"

@interface StatisticsVC ()

@end

@implementation StatisticsVC
@synthesize areaid;
- (void)viewDidLoad {
    [super viewDidLoad];
    areaid=[[SingalObj defaultManager].userInfoModel.areaid stringValue];
    // Do any additional setup after loading the view.
}
-(void)getYesterDay{
    [self networkPost:API_GETYESTERDAYCOUNT2 parameter:@{@"areaid":[areaid numberValue]} progresHudText:@"加载中..." completionBlock:^(id rep) {
        
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
