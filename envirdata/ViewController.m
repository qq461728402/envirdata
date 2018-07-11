//
//  ViewController.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/3.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *addbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [addbtn setTitle:@"导航" forState:UIControlStateNormal];
    [addbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    addbtn.frame=CGRectMake(100, 100, 100, 100);
    [self.view addSubview:addbtn];
    [addbtn bk_addEventHandler:^(id sender) {
        ViewController *view=[[ViewController alloc]init];
        [self.navigationController pushViewController:view animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
