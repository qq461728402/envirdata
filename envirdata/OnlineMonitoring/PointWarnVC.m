//
//  PointWarnVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/21.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "PointWarnVC.h"
#import "CTextField.h"
@interface PointWarnVC ()
@property (nonatomic,strong)CTextField *pointName_tf;
@property (nonatomic,strong)CTextField *pointType_tf;
@end

@implementation PointWarnVC
@synthesize pointName_tf,pointType_tf,pointName;

-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor colorWithRGB:0xf1f1f1]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加站点
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0, 64+10, SCREEN_WIDTH, SCALE(50))];
    UILabel *sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 50, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"站点：";
    [tempView addSubview:sublb];
    pointName_tf =[[CTextField alloc]initWithFrame:CGRectMake(sublb.right, SCALE(7), SCREEN_WIDTH-sublb.right-SCALE(8), SCALE(36))];
    pointName_tf.font=Font(15);
    pointName_tf.text=pointName;
    pointName_tf.enabled=YES;
    [pointName_tf setBackgroundColor:[UIColor whiteColor]];
    ViewRadius(pointName_tf, 4);
    [tempView addSubview:pointName_tf];
    
    UILabel * oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [self.view addSubview:tempView];
    //站点类型
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, SCALE(50))];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 50, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"类型：";
    [tempView addSubview:sublb];
    pointType_tf =[[CTextField alloc]initWithFrame:CGRectMake(sublb.right, SCALE(7), SCREEN_WIDTH-sublb.right-SCALE(8), SCALE(36))];
    pointType_tf.font=Font(15);
    pointType_tf.placeholder=@"请选择类型";
    pointType_tf.enabled=YES;
    [pointType_tf setBackgroundColor:[UIColor whiteColor]];
    ViewRadius(pointType_tf, 4);
    pointType_tf.userInteractionEnabled=YES;
    [pointType_tf bk_whenTapped:^{
        NSLog(@"1111");
    }];
    [tempView addSubview:pointType_tf];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [self.view addSubview:tempView];
    //图片
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, SCALE(200))];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 50, 21)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"图片：";
    [tempView addSubview:sublb];
    UIImageView *pointImageV=[[UIImageView alloc]initWithFrame:CGRectMake(sublb.right, SCALE(7), SCREEN_WIDTH-sublb.right-SCALE(8), SCALE(194))];
    [pointImageV setImage:_pointImage];
    [tempView addSubview:pointImageV];
    [self.view addSubview:tempView];
    
    UIButton *addMonitorBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addMonitorBtn.frame=CGRectMake(SCALE(8), tempView.bottom+20, SCREEN_WIDTH-SCALE(16), SCALE(50));
    [addMonitorBtn bootstrapNoborderStyle:SUBMIT_COLOR titleColor:[UIColor whiteColor] andbtnFont:Font(16)];
    [addMonitorBtn setTitle:@"提 交" forState:UIControlStateNormal];
    ViewRadius(addMonitorBtn, 8);
    [addMonitorBtn bk_addEventHandler:^(id sender) {
        [self submitData];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMonitorBtn];
    [self upImage];
    // Do any additional setup after loading the view.
}
-(void)submitData{
 
    
    

}
-(void)upImage{
    [self networkUpfile:FILE_UPLOADING imageAry:_pointImage parameter:@{} progresHudText:@"加载中..." completionBlock:^(id rep) {
        [SVProgressHUD dismiss];
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
