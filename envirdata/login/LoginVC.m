//
//  LoginVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/3.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "LoginVC.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"
@interface LoginVC ()
@property (nonatomic,strong)UILabel *sutitlelb;
@property (nonatomic,strong)UILabel *titlelb;
@property (nonatomic,strong)UITextField *usertf;
@property (nonatomic,strong)UITextField *passwordtf;
@end

@implementation LoginVC
@synthesize titlelb,sutitlelb,usertf,passwordtf;
- (void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"pushMode"];
    
    UIImageView *bgImage=[[UIImageView alloc]initWithImage:PNGIMAGE(@"login_bg")];
    bgImage.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:bgImage];

    UIImageView *iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, SCALE(70), SCALE(120), SCALE(120))];
    iconImage.image=[ConfigObj getIconImge];
    ViewRadius(iconImage, 20);
    iconImage.centerX=SCREEN_WIDTH/2.0;
    [self.view addSubview:iconImage];
    
    titlelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    titlelb.top=iconImage.bottom+10;
    titlelb.font=BoldFont(30);
    titlelb.textAlignment=NSTextAlignmentCenter;
    titlelb.textColor=COLOR_TOP;
    titlelb.text=@"";
    [self.view addSubview:titlelb];
    
    sutitlelb=[[UILabel alloc]initWithFrame:CGRectMake(30, titlelb.bottom, SCREEN_WIDTH-60, 30)];
    sutitlelb.font=Font(24);
    sutitlelb.textAlignment=NSTextAlignmentCenter;
    sutitlelb.textColor=COLOR_TOP;
    sutitlelb.text=@"";
    [self.view addSubview:sutitlelb];
    
    UIView *loginView=[[UIView alloc]initWithFrame:CGRectMake(SCALE(30), sutitlelb.bottom+15, SCREEN_WIDTH-SCALE(60), 80)];
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
    
    UILabel *passwordicon=[[UILabel alloc]initWithFrame:CGRectMake(usericon.left,onelb.bottom+5,100,30)];
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
    loginbtn.frame=CGRectMake(loginView.left, loginView.bottom+30, loginView.width, SCALE(50));
    [loginbtn setTitle:@"登 录" forState:UIControlStateNormal];
    ViewRadius(loginbtn, 8);
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
    NSDictionary *untiInfo=USER_DEFAULTS(@"unitInfo");
    if (untiInfo) {
        titlelb.text = untiInfo[@"appexpand1"];
        sutitlelb.text = untiInfo[@"appexpand2"];
    }
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
    [self networkPost:API_CHECKUSER parameter:@{@"passport":usertf.text,@"pwd":passwordtf.text} progresHudText:@"加载中..." completionBlock:^(id rep) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        //保存用户信息
        [[NSUserDefaults standardUserDefaults] setObject:rep forKey:@"userInfo"];
        UserInfoModel *userInfo = [UserInfoModel mj_objectWithKeyValues:rep];
        
        //个推绑定
        
        
        //[GeTuiSdk bindAlias:<#(NSString *)#> andSequenceNum:[NSString stringWithUUID]]
        
        
        
        //保存单位信息
        [[NSUserDefaults standardUserDefaults] setObject:@{@"appexpand1":userInfo.appexpand1,@"appexpand2":userInfo.appexpand2}
                                            forKey:@"unitInfo"];
        titlelb.text = userInfo.appexpand1;
        sutitlelb.text = userInfo.appexpand2;
        [SingalObj defaultManager].userInfoModel=userInfo;
        [self getMenu];
    }];
}
-(void)gogo{
    [self bindDeviece];
    [[AppDelegate Share] gotohome];
}
-(void)bindDeviece{
    [self networkPost:API_BINDDEVICE parameter:@{@"userid":[SingalObj defaultManager].userInfoModel.userid,@"clientid":[NSString stringWithUUID]} progresHudText:nil completionBlock:^(id rep) {
    }];
}

-(void)getMenu{
    NSDictionary *parameter = @{@"roleid":[SingalObj defaultManager].userInfoModel.roleid};
    [self networkPost:API_GETMENU parameter:parameter progresHudText:nil completionBlock:^(id rep) {
        //保存菜单信息
        [[NSUserDefaults standardUserDefaults] setObject:rep forKey:@"menuInfo"];//保存菜单信息
        [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
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
