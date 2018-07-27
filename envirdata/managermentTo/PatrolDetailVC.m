//
//  PatrolDetailVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/24.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "PatrolDetailVC.h"
#import "PictureView.h"
#import "UITextViewPlaceHolder.h"
@interface PatrolDetailVC ()<PictureViewDelegate>
@property (nonatomic,strong)UIScrollView *mianScr;
@property (nonatomic,strong)PictureView *picture_view1;
@property (nonatomic,strong)UITextViewPlaceHolder *hcontent_tv;
@end

@implementation PatrolDetailVC
@synthesize patrolTasksModel;
@synthesize mianScr,picture_view1,hcontent_tv;
- (void)viewDidLoad {
    [super viewDidLoad];
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
    sublb.text=@"站点：";
    [tempView addSubview:sublb];
    UILabel *titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.textColor=subColor;
    titlelb.numberOfLines=2;
    titlelb.text=patrolTasksModel.uname;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    
    
    //类型
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=titleColor;
    sublb.font=Font(15);
    sublb.text=@"类型：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.textColor=subColor;
    titlelb.text=patrolTasksModel.dval;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
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
   
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.textColor=subColor;
    titlelb.font=Font(15);
    titlelb.text=patrolTasksModel.address;
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom-0.5, tempView.width, 0.5)];
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
    titlelb.text=patrolTasksModel.des;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    CGSize conentSize =[titlelb.text boundingRectWithSize:CGSizeMake(titlelb.width, 500) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:titlelb.font} context:nil].size;
    titlelb.height=titlelb.height>conentSize.height?titlelb.height:conentSize.height;
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom-0.5, tempView.width, 0.5)];
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
    NSMutableArray *pricrAry =[NSMutableArray arrayWithArray:[patrolTasksModel.pics componentsSeparatedByString:@","]];
    
    PictureView *picture_view=[[PictureView alloc]initWithFrame:CGRectMake(sublb.right,5, tempView.width-sublb.right-SCALE(8), 60) pictureAry:pricrAry size:CGSizeMake(60, 60) isUpPic:NO];
    picture_view.vself=self;
    [tempView addSubview:picture_view];
    tempView.height=picture_view.bottom+10;
    
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, tempView.height-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    
    //责任部门
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 85, tempView.height)];
    sublb.textColor=titleColor;
    sublb.font=Font(15);
    sublb.text=@"责任部门：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.textColor=subColor;
    titlelb.text=patrolTasksModel.dname;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    
    //创建时间
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 85, tempView.height)];
    sublb.textColor=titleColor;
    sublb.font=Font(15);
    sublb.text=@"创建时间：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.textColor=subColor;
    titlelb.text=patrolTasksModel.ctime;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    if ([patrolTasksModel.status intValue]==1) {//表示我待办
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
    }else{
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
        titlelb.text=patrolTasksModel.handle_des;
        titlelb.font=Font(15);
        titlelb.textColor=subColor;
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
        if ([patrolTasksModel.handle_pics isNotBlank]) {
            pricrAry1=[NSMutableArray arrayWithArray:[patrolTasksModel.handle_pics componentsSeparatedByString:@","]];
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
        titlelb.text=patrolTasksModel.hname;
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
        titlelb.text=patrolTasksModel.handle_time;
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

-(void)gotoNav{


}
-(void)dealTask{
    if (![hcontent_tv.text isNotBlank]) {
        [self showMsgInfo:@"请输入处理描述"];
        return;
    }
    if (picture_view1.pictureAry.count==0||picture_view1.pictureAry.count>3) {
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
                [weakSelf  handlePatrolTasksWithPics:pics];
            }
        }];
    }
}
-(void)handlePatrolTasksWithPics:(NSString*)pics{
    NSNumber *userId=[SingalObj defaultManager].userInfoModel.userid;
    [self networkPost:API_HANDLEPATROLTASKS parameter:@{@"id":patrolTasksModel.id,@"handle_des":hcontent_tv.text,@"handle_pics":pics,@"handler":userId} progresHudText:nil completionBlock:^(id rep) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        if (self.callback) {
            self.callback(YES);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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
