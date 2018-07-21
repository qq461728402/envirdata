//
//  AboutUsVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/20.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()

@end

@implementation AboutUsVC
-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    WEAKSELF
    
    UIImageView *logoImage=[[UIImageView alloc]init];
    logoImage.translatesAutoresizingMaskIntoConstraints=YES;
    [logoImage setImage:PNGIMAGE(@"grand_logo")];
    [self.view addSubview:logoImage];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(80);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *lbs=[[UILabel alloc]init];
    lbs.translatesAutoresizingMaskIntoConstraints=YES;
    lbs.font=Font(15);
    lbs.text=@"重庆广睿达科技有限公司是一家专注于环保人工智能的高新技术企业，致力于将物联网、大数据及人工智能技术等用于环境监测与治理，实现数据驱动业务，帮助政府职能部门提高管理效率。";
    lbs.textColor=[UIColor colorWithRGB:0x404040];
    lbs.numberOfLines=0;
    [self.view addSubview:lbs];
    
    [lbs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImage.mas_bottom).offset(30);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
    }];

    UILabel *compley_lb=[[UILabel alloc]init];
    compley_lb.translatesAutoresizingMaskIntoConstraints=YES;
    compley_lb.font=Font(14);
    compley_lb.textColor=[UIColor colorWithRGB:0x404040];
    compley_lb.text=@"重庆广睿达科技有限";
    [self.view addSubview:compley_lb];
    
    [compley_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-80);
    }];
    
    UILabel *jszc_lb=[[UILabel alloc]init];
    jszc_lb.translatesAutoresizingMaskIntoConstraints=YES;
    jszc_lb.font=Font(14);
    jszc_lb.userInteractionEnabled=YES;
    [self.view addSubview:jszc_lb];
    [jszc_lb bk_whenTapped:^{
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:023-63118475"];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }];
    
    jszc_lb.textColor=[UIColor colorWithRGB:0x404040];
    NSString *jszcstr=@"技术支持：023-63118475";
    NSMutableAttributedString *valueAttri=[[NSMutableAttributedString alloc]initWithString:jszcstr];
    [valueAttri addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(5, jszcstr.length-5)];
    [valueAttri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGB:0xd41d0f] range:NSMakeRange(5, jszcstr.length-5)];
    [jszc_lb setAttributedText:valueAttri];
    [jszc_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(compley_lb.mas_bottom).offset(10);
    }];
    
    UILabel *email_lb=[[UILabel alloc]init];
    email_lb.translatesAutoresizingMaskIntoConstraints=YES;
    email_lb.font=Font(14);
    email_lb.textColor=[UIColor colorWithRGB:0x404040];
    [self.view addSubview:email_lb];
    email_lb.userInteractionEnabled=YES;
    [email_lb bk_whenTapped:^{
      [[UIApplication sharedApplication]openURL:[NSURL   URLWithString:@"MESSAGE://grand_tech@163.com"]];
    }];
    NSString *emainstr=@"邮箱：grand_tech@163.com";
    NSMutableAttributedString *emailAttri=[[NSMutableAttributedString alloc]initWithString:emainstr];
    [emailAttri addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(3, emainstr.length-3)];
    [emailAttri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGB:0xd41d0f] range:NSMakeRange(3, emainstr.length-3)];
    [email_lb setAttributedText:emailAttri];
    
    [email_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(jszc_lb.mas_bottom).offset(10);
    }];
    
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
