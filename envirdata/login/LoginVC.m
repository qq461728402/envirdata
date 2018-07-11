//
//  LoginVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/3.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()
@property (nonatomic,strong)UILabel *sutitlelb;
@property (nonatomic,strong)UITextField *usertf;
@property (nonatomic,strong)UITextField *passwordtf;
@end

@implementation LoginVC
@synthesize sutitlelb,usertf,passwordtf;
- (void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgImage=[[UIImageView alloc]initWithImage:PNGIMAGE(@"login_bg")];
    bgImage.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:bgImage];

    UIImageView *iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, SCALE(70), SCALE(120), SCALE(120))];
    iconImage.image=[ConfigObj getIconImge];
    iconImage.centerX=SCREEN_WIDTH/2.0;
    [self.view addSubview:iconImage];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    title.top=iconImage.bottom+10;
    title.font=BoldFont(30);
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=COLOR_TOP;
    title.text=@"重庆市四北地区";
    [self.view addSubview:title];
    
    sutitlelb=[[UILabel alloc]initWithFrame:CGRectMake(30, title.bottom, SCREEN_WIDTH-60, 30)];
    sutitlelb.font=Font(24);
    sutitlelb.textAlignment=NSTextAlignmentCenter;
    sutitlelb.textColor=COLOR_TOP;
    sutitlelb.text=@"大气污染防治协同平台";
    [self.view addSubview:sutitlelb];
    
    UIView *loginView=[[UIView alloc]initWithFrame:CGRectMake(SCALE(30), sutitlelb.bottom+10, SCREEN_WIDTH-SCALE(60), 80)];
    [loginView setBackgroundColor:[UIColor whiteColor]];
    ViewRadius(loginView, 2);
    [self.view addSubview:loginView];
    
    
    UILabel *usericon=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), SCALE(8), 30, 30)];
    usericon.font=[UIFont fontWithName:@"iconfont" size:24];
    usericon.text =@"\U0000e609";
    usericon.textColor=[UIColor grayColor];
    [loginView addSubview:usericon];
    usertf =[[UITextField alloc]initWithFrame:CGRectMake(usericon.right+SCALE(8), usericon.top, loginView.width-(usericon.right+SCALE(8)), usericon.height)];
    usertf.placeholder=@"请输入用户名";
    usertf.font=Font(15);
    usertf.returnKeyType = UIReturnKeyDone;
    usertf.autocorrectionType = UITextAutocorrectionTypeNo;//取消联想
    usertf.autocapitalizationType=UITextAutocapitalizationTypeNone;//取消大小写
    usertf.clearButtonMode=UITextFieldViewModeWhileEditing;
    [loginView addSubview:usertf];

    UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(usericon.left, usertf.bottom+5, loginView.width-SCALE(16), 0.5)];
    [onelb setBackgroundColor:LINE_COLOR];
    [loginView addSubview:onelb];
    
    UILabel *passwordicon=[[UILabel alloc]initWithFrame:CGRectMake(usericon.left,onelb.bottom+5,30,30)];
    passwordicon.font=[UIFont fontWithName:@"iconfont" size:24];
    passwordicon.text =@"\U0000e64d";
    passwordicon.textColor=[UIColor grayColor];
    [loginView addSubview:passwordicon];
    passwordtf=[[UITextField alloc]initWithFrame:CGRectMake(usertf.left, passwordicon.top, usertf.width, usertf.height)];
    passwordtf.placeholder=@"请输入密码";
    passwordtf.font=Font(15);
    [passwordtf setBk_shouldReturnBlock:^BOOL(UITextField * textField) {
        [textField resignFirstResponder];
        return YES;
    }];
    passwordtf.returnKeyType = UIReturnKeyDone;
    [passwordtf setSecureTextEntry:YES];
    passwordtf.clearButtonMode=UITextFieldViewModeWhileEditing;
    [loginView addSubview:passwordtf];
    loginView.height=passwordtf.bottom+SCALE(8);
    
    
    UIButton *loginbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginbtn.frame=CGRectMake(loginView.left, loginView.bottom+20, loginView.width, SCALE(50));
    [loginbtn setTitle:@"登 录" forState:UIControlStateNormal];
    ViewRadius(loginbtn, 4);
    [loginbtn bk_addEventHandler:^(id sender) {
        [self loginP];
    } forControlEvents:UIControlEventTouchUpInside];
    [loginbtn bootstrapNoborderStyle:COLOR_TAB_UNSELECT titleColor:[UIColor colorWithRGB:0xffffff] andbtnFont:Font(18)];
    [self.view addSubview:loginbtn];

    UILabel *zclb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 21)];
    zclb.font=Font(14);
    zclb.bottom=SCREEN_HEIGHT-10;
    zclb.textAlignment=NSTextAlignmentCenter;
    zclb.textColor=[UIColor colorWithRGB:0xc6c6c6];
    zclb.text=@"技术支持：重庆广睿达科技有限公司";
    [self.view addSubview:zclb];
    

    // Do any additional setup after loading the view.
}
#pragma mark----------登录--------
-(void)loginP{
    if (![usertf.text isNotBlank]) {
        [self showMsgInfo:@"请输入用户名"];
        return;
    }else if (![passwordtf.text isNotBlank]){
         [self showMsgInfo:@"请输入密码"];
        return;
    }
    [self networkPost:API_CHECKUSER parameter:@{@"passport":usertf.text,@"pwd":[passwordtf.text md5String]} progresHudText:@"加载中..." completionBlock:^(id rep) {
    
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
