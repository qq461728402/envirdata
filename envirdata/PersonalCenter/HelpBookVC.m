//
//  HelpBookVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/20.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "HelpBookVC.h"

@interface HelpBookVC ()<UIWebViewDelegate>

@end

@implementation HelpBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *helpweb=[[UIWebView alloc]init];
    helpweb.delegate=self;
     helpweb.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:helpweb];
    NSString *url =[NSString stringWithFormat:@"%@%@",HOST_API,API_HANDBOOK];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [helpweb loadRequest:request];
    WEAKSELF
    [helpweb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    // Do any additional setup after loading the view.
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:@"加载中..."];

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD dismiss];
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
