//
//  TaskDetailVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/18.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "TaskDetailVC.h"
#import "PictureView.h"
#import "UITextViewPlaceHolder.h"
#import "AddTaskViewController.h"
@interface TaskDetailVC ()<PictureViewDelegate>
@property (nonatomic,strong)UIScrollView *mianScr;
@property (nonatomic,strong)PictureView *picture_view1;
@property (nonatomic,strong)UITextViewPlaceHolder *hcontent_tv;
@end

@implementation TaskDetailVC
@synthesize taskModel;
@synthesize mianScr,hcontent_tv,picture_view1,isOnlyLook;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (isOnlyLook==NO) {
        if ([taskModel.status intValue]==1) {//表示我待办
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame =CGRectMake(0,0, 60, 44);
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            but.titleLabel.font=Font(16);
            [but addTarget:self action:@selector(turnToOther:) forControlEvents:UIControlEventTouchUpInside];
            [but setTitle:@"转发"forState:UIControlStateNormal];
            UIBarButtonItem  *barBut = [[UIBarButtonItem alloc]initWithCustomView:but];
            self.navigationItem.rightBarButtonItem = barBut;
        }
        else if([taskModel.status intValue]==2&& [taskModel.sendor intValue] == [[SingalObj defaultManager].userInfoModel.userid intValue]){
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame =CGRectMake(0,0, 75, 44);
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            but.titleLabel.font=Font(15);
            [but addTarget:self action:@selector(sureTask:) forControlEvents:UIControlEventTouchUpInside];
            [but setTitle:@"确认任务"forState:UIControlStateNormal];
            UIBarButtonItem  *barBut = [[UIBarButtonItem alloc]initWithCustomView:but];
            self.navigationItem.rightBarButtonItem = barBut;
        }
    }
    [self.view setBackgroundColor:[UIColor colorWithRGB:0xebeced]];
    mianScr =[[UIScrollView alloc]init];
    [self.view addSubview:mianScr];
    WEAKSELF
    //先确定view_1的约束
    [mianScr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    
    UIColor *titleColor =[UIColor colorWithRGB:0x2c2c2c];
    UIColor *subColor =[UIColor colorWithRGB:0x00b5ff];
    
    //标题
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    UILabel *sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=titleColor;
    sublb.font=Font(15);
    sublb.text=@"标题：";
    [tempView addSubview:sublb];
    UILabel *titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.textColor=subColor;
    titlelb.text=taskModel.title;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    //描述
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=titleColor;
    sublb.font=Font(15);
    sublb.text=@"描述：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=0;
    titlelb.textColor=subColor;
    titlelb.text=taskModel.content;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    CGSize conentSize =[titlelb.text boundingRectWithSize:CGSizeMake(titlelb.width, 500) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:titlelb.font} context:nil].size;
    titlelb.height=titlelb.height>conentSize.height?titlelb.height:conentSize.height;
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    //位置
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=titleColor;
    sublb.font=Font(15);
    sublb.text=@"位置：";
    [tempView addSubview:sublb];
    UIButton *navbuton=[UIButton buttonWithType:UIButtonTypeCustom];
    navbuton.frame=CGRectMake(0, 5, 30, 30);
    [navbuton bk_addEventHandler:^(id sender) {
        [self gotoNav];
    } forControlEvents:UIControlEventTouchUpInside];
    navbuton.titleLabel.font=[UIFont fontWithName:@"iconfont" size:20];
    [navbuton setTitle:@"\U0000e614" forState:UIControlStateNormal];
    [navbuton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     navbuton.right=SCREEN_WIDTH-SCALE(8);
    [tempView addSubview:navbuton];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-navbuton.width-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.userInteractionEnabled=YES;
    [titlelb bk_whenTapped:^{
        [self gotoNav];
    }];
    titlelb.font=Font(15);
    NSMutableAttributedString *retitle=[[NSMutableAttributedString alloc]initWithString:taskModel.position];
    [retitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, taskModel.position.length)];
    [retitle addAttribute:NSForegroundColorAttributeName value:subColor range:NSMakeRange(0, taskModel.position.length)];
    [titlelb setAttributedText:retitle];
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    //时限
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=titleColor;
    sublb.font=Font(15);
    sublb.text=@"时限：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.textColor=subColor;
    
    
    titlelb.text=taskModel.limittime;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    //图片
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 70)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 5, 75, 21)];
    sublb.textColor=titleColor;
    sublb.font=Font(15);
    sublb.text=@"图片：";
    [tempView addSubview:sublb];
    NSMutableArray *pricrAry =[NSMutableArray arrayWithArray:[taskModel.pics componentsSeparatedByString:@","]];
    
    PictureView *picture_view=[[PictureView alloc]initWithFrame:CGRectMake(sublb.right,5, tempView.width-sublb.right-SCALE(8), 60) pictureAry:pricrAry size:CGSizeMake(60, 60) isUpPic:NO];
    picture_view.vself=self;
    tempView.height=picture_view.bottom+10;
    [tempView addSubview:picture_view];
    
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, tempView.height-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    //创建人
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=titleColor;
    sublb.font=Font(15);
    sublb.text=@"创建人：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.textColor=subColor;
    titlelb.text=taskModel.sendorname;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    
    //创建时间
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=titleColor;
    sublb.font=Font(15);
    sublb.adjustsFontSizeToFitWidth=YES;
    sublb.text=@"创建时间：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.textColor=subColor;
    titlelb.text=taskModel.ctime;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    if ([taskModel.status intValue]==1&&isOnlyLook==NO) {//表示我待办
        //内容
        tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, SCALE(80))];
        sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, 21)];
        sublb.textColor=titleColor;
        sublb.font=Font(15);
        sublb.adjustsFontSizeToFitWidth=YES;
        sublb.text=@"处理描述：";
        [tempView addSubview:sublb];
        hcontent_tv =[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(sublb.right, SCALE(5), SCREEN_WIDTH-sublb.right-SCALE(8), SCALE(70))];
        hcontent_tv.font=Font(15);
        [hcontent_tv setBackgroundColor:[UIColor whiteColor]];
        ViewRadius(hcontent_tv, 4);
        hcontent_tv.placeholder=@"请输入处理描述";
        [tempView addSubview:hcontent_tv];
        oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, tempView.height-0.5, tempView.width, 0.5)];
        [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
        [tempView addSubview:oneline];
        [mianScr addSubview:tempView];
        
        //图片
        tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 70)];
        sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 5, 75, 21)];
        sublb.textColor=titleColor;
        sublb.font=Font(15);
        sublb.text=@"图片：";
        [tempView addSubview:sublb];
        
        picture_view1=[[PictureView alloc]initWithFrame:CGRectMake(sublb.right,5, tempView.width-sublb.right-SCALE(8), 60) pictureAry:[[NSMutableArray alloc]init] size:CGSizeMake(60, 60) isUpPic:YES];
        picture_view1.delegate = self;
        [tempView addSubview:picture_view1];
        
        oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, tempView.height-0.5, tempView.width, 0.5)];
        [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
        [tempView addSubview:oneline];
        [mianScr addSubview:tempView];
        UIButton *addMonitorBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        addMonitorBtn.frame=CGRectMake(SCALE(8), tempView.bottom+20, SCREEN_WIDTH-SCALE(16), SCALE(50));
        [addMonitorBtn bootstrapNoborderStyle:SUBMIT_COLOR titleColor:[UIColor whiteColor] andbtnFont:Font(16)];
        [addMonitorBtn setTitle:@"提 交" forState:UIControlStateNormal];
        ViewRadius(addMonitorBtn, 8);
        [addMonitorBtn bk_addEventHandler:^(id sender) {
            [self dealTask];
        } forControlEvents:UIControlEventTouchUpInside];
        [mianScr addSubview:addMonitorBtn];
        [mianScr setContentSize:CGSizeMake(SCREEN_WIDTH, addMonitorBtn.bottom+30)];
    
    }else  if ([taskModel.status intValue]!=1||isOnlyLook==YES) {//表示已处理
        //描述
        tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
        sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
        sublb.textColor=titleColor;
        sublb.font=Font(15);
        sublb.adjustsFontSizeToFitWidth=YES;
        sublb.text=@"处理描述：";
        [tempView addSubview:sublb];
        titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
        titlelb.numberOfLines=0;
        titlelb.textColor=subColor;
        titlelb.text=taskModel.hcontent;
        titlelb.font=Font(15);
        [tempView addSubview:titlelb];
        CGSize conentSize1 =[titlelb.text boundingRectWithSize:CGSizeMake(titlelb.width, 500) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:titlelb.font} context:nil].size;
        titlelb.height=titlelb.height>conentSize1.height?titlelb.height:conentSize1.height;
        oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom-0.5, tempView.width, 0.5)];
        [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
        [tempView addSubview:oneline];
        [mianScr addSubview:tempView];
        //图片
        tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 75)];
        sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 5, 75, 21)];
        sublb.textColor=titleColor;
        sublb.font=Font(15);
        sublb.adjustsFontSizeToFitWidth=YES;
        sublb.text=@"描述图片：";
        [tempView addSubview:sublb];
        NSMutableArray *pricrAry1;
        if ([taskModel.hpics isNotBlank]) {
            pricrAry1=[NSMutableArray arrayWithArray:[taskModel.hpics componentsSeparatedByString:@","]];
        }else{
            pricrAry1=[[NSMutableArray alloc]init];
        }
    
        PictureView *picture_view2=[[PictureView alloc]initWithFrame:CGRectMake(sublb.right,5, tempView.width-sublb.right-SCALE(8), 60) pictureAry:pricrAry1 size:CGSizeMake(60, 60) isUpPic:NO];
        picture_view2.vself=self;
        tempView.height=picture_view2.bottom+10;
        [tempView addSubview:picture_view2];
        oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, tempView.height-0.5, tempView.width, 0.5)];
        [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
        [tempView addSubview:oneline];
        [mianScr addSubview:tempView];
        //创建人
        tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
        sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
        sublb.textColor=titleColor;
        sublb.font=Font(15);
        sublb.text=@"处理人：";
        [tempView addSubview:sublb];
        titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
        titlelb.numberOfLines=2;
        titlelb.textColor=subColor;
        titlelb.text=taskModel.receivername;
        titlelb.font=Font(15);
        [tempView addSubview:titlelb];
        oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
        [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
        [tempView addSubview:oneline];
        [mianScr addSubview:tempView];
        
        //创建时间
        tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
        sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
        sublb.textColor=titleColor;
        sublb.font=Font(15);
        sublb.adjustsFontSizeToFitWidth=YES;
        sublb.text=@"处理时间：";
        [tempView addSubview:sublb];
        titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
        titlelb.numberOfLines=2;
        titlelb.textColor=subColor;
        NSDate *hdate = [NSDate dateWithString:taskModel.htime format:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *limtStr= [taskModel.limittime stringByAppendingString:@" 23:59:59"];
        
        NSDate *limtdate=[NSDate dateWithString:limtStr format:@"yyyy-MM-dd HH:mm:ss"];
        NSComparisonResult result  =[hdate compare:limtdate];
        if (result==NSOrderedDescending) {
             titlelb.text=[taskModel.htime  stringByAppendingString:@"（超期）"];
        }
        else{
            titlelb.text=taskModel.htime;
        }
        titlelb.font=Font(15);
        [tempView addSubview:titlelb];
        oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
        [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
        [tempView addSubview:oneline];
        [mianScr addSubview:tempView];
        [mianScr setContentSize:CGSizeMake(SCREEN_WIDTH, tempView.bottom+30)];
    }
    // Do any additional setup after loading the view.
}
#pragma mark----------时间处理_--------
-(void)dealTask{
    if (![hcontent_tv.text isNotBlank]) {
        [self showMsgInfo:@"请输入处理描述"];
        return;
    }
    else if (picture_view1.pictureAry.count==0){
        [self showMsgInfo:@"请上传处理图片"];
        return;
    }else if (picture_view1.pictureAry.count>3) {
        [self showMsgInfo:@"请选择小于4张处理图片"];
        return;
    }
    WEAKSELF
    __block int i=0;
    __block NSMutableArray *imageAry=[[NSMutableArray alloc]init];
    for(UIImage *image in picture_view1.pictureAry){
        [self networkUpfile:FILE_UPLOADING imageAry:image parameter:nil progresHudText:@"提交中..." completionBlock:^(id rep) {
            i++;
            [imageAry addObject:rep[@"url"]];
            if (i>=picture_view1.pictureAry.count) {
                NSString *pics =  [imageAry componentsJoinedByString:@","];
                [weakSelf  updMonitorTask:pics];
            }
        }];
    }
}
-(void)updMonitorTask:(NSString*)pics{
    [self networkPost:API_UPDMONITORTASK parameter:@{@"id":taskModel.id,@"hcontent":hcontent_tv.text,@"hpics":pics} progresHudText:nil completionBlock:^(id rep) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
        [self bk_performBlock:^(id obj) {
            if (self.callback) {
                self.callback(YES);
            }
            [self.navigationController popViewControllerAnimated:YES];

            
        } afterDelay:1.0];
    }];
}
-(void)turnToOther:(UIButton*)sender{
    AddTaskViewController *addtask=[[AddTaskViewController alloc]init];
    addtask.kind=@"2";
    addtask.reldata=taskModel;//关联任务
    addtask.callback =^(BOOL issu){
        if (issu==YES) {
            if (self.callback) {
               self.callback(YES);
            }
        }
    };
    addtask.title=@"发起任务";
    [self.navigationController pushViewController:addtask animated:YES];
}
-(void)sureTask:(UIButton*)sender{
    [self networkPost:API_FINISHTASK parameter:@{@"id":taskModel.id} progresHudText:@"正在处理..." completionBlock:^(id rep) {
        [SVProgressHUD showSuccessWithStatus:@"处理成功!"];
        
        [self bk_performBlock:^(id obj) {
            if (self.callback) {
                self.callback(YES);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } afterDelay:1.0];
    }];

}
#pragma mark------------进入导航--------
-(void)gotoNav{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [taskModel.wd doubleValue];
    coordinate.longitude = [taskModel.jd doubleValue];
    WEAKSELF
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"苹果自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf appleNaiWithCoordinate:coordinate andWithMapTitle:taskModel.position];
        
    }]];
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
            [weakSelf aNaviWithCoordinate:coordinate andWithMapTitle:taskModel.position];
            
        }]];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"alertController -- 百度地图");
            [weakSelf baiduNaviWithCoordinate:coordinate andWithMapTitle:taskModel.position];
            
        }]];
    }
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
//唤醒苹果自带导航
- (void)appleNaiWithCoordinate:(CLLocationCoordinate2D)coordinate andWithMapTitle:(NSString *)map_title{
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *tolocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    tolocation.name = map_title;
    [MKMapItem openMapsWithItems:@[currentLocation,tolocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                               MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
}
/**
 高德导航
 */
- (void)aNaviWithCoordinate:(CLLocationCoordinate2D)coordinate andWithMapTitle:(NSString *)map_title{
    
    NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",coordinate.latitude,coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:urlsting]];
}

- (void)baiduNaviWithCoordinate:(CLLocationCoordinate2D)coordinate andWithMapTitle:(NSString *)map_title{
    NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin=%@&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",map_title,coordinate.latitude,coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
}
#pragma mark-------选取图片--------
-(void)addPicker:(UIImagePickerController *)picker{
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)addUIImagePicker:(UIImagePickerController *)picker
{
    [self presentViewController:picker animated:YES completion:nil];
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
