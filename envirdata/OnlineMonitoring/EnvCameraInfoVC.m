//
//  EnvCameraInfoVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/14.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "EnvCameraInfoVC.h"

@interface EnvCameraInfoVC ()

@end

@implementation EnvCameraInfoVC
@synthesize uid;
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark--------------根据站点获取摄像头信息-----------
-(void)getCameraInfo{
    [self networkPost:API_GETCAMERAINFO parameter:@{@"uid":uid} progresHudText:@"加载中..." completionBlock:^(id rep) {
        
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
