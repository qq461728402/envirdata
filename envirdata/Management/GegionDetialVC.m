//
//  GegionDetialVC.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/19.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "GegionDetialVC.h"
#import "PictureView.h"
@interface GegionDetialVC ()
@property (nonatomic,strong)UIScrollView *mianScr;
@end

@implementation GegionDetialVC
@synthesize mianScr,gegionModel;
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
    //标题
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    UILabel *sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"标题：";
    [tempView addSubview:sublb];
    UILabel *titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.text=gegionModel.title;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    //描述
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"描述：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=0;
    titlelb.text=gegionModel.content;
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
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
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
    NSMutableAttributedString *retitle=[[NSMutableAttributedString alloc]initWithString:gegionModel.position];
    [retitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, gegionModel.position.length)];
    [retitle addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, gegionModel.position.length)];
    [titlelb setAttributedText:retitle];
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    //时限
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"时限：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.text=gegionModel.limittime;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    //图片
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 70)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(12), 5, 75, 21)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"图片：";
    [tempView addSubview:sublb];
    NSMutableArray *pricrAry =[NSMutableArray arrayWithArray:[gegionModel.pics componentsSeparatedByString:@","]];
    
    PictureView *picture_view=[[PictureView alloc]initWithFrame:CGRectMake(sublb.right,5, tempView.width-sublb.right-SCALE(8), 60) pictureAry:pricrAry size:CGSizeMake(60, 60) isUpPic:NO];
    picture_view.vself=self;
    [tempView addSubview:picture_view];
    
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, tempView.height-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    //创建人
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"创建人：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.text=gegionModel.receivername;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    
    //创建时间
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.adjustsFontSizeToFitWidth=YES;
    sublb.text=@"创建时间：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.text=gegionModel.ctime;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];

    
    //描述
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.adjustsFontSizeToFitWidth=YES;
    sublb.text=@"处理描述：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=0;
    titlelb.text=gegionModel.hcontent;
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
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.adjustsFontSizeToFitWidth=YES;
    sublb.text=@"描述图片：";
    [tempView addSubview:sublb];
    NSMutableArray *pricrAry1 =[NSMutableArray arrayWithArray:[gegionModel.hpics componentsSeparatedByString:@","]];
    PictureView *picture_view2=[[PictureView alloc]initWithFrame:CGRectMake(sublb.right,5, tempView.width-sublb.right-SCALE(8), 60) pictureAry:pricrAry1 size:CGSizeMake(60, 60) isUpPic:NO];
    picture_view2.vself=self;
    [tempView addSubview:picture_view2];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, tempView.height-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    //创建人
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.text=@"处理人：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.text=gegionModel.sendorname;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    
    //创建时间
    tempView=[[UIView alloc]initWithFrame:CGRectMake(0, tempView.bottom, SCREEN_WIDTH, 40)];
    sublb=[[UILabel alloc]initWithFrame:CGRectMake(SCALE(8), 0, 75, tempView.height)];
    sublb.textColor=[UIColor colorWithRGB:0x2e4057];
    sublb.font=Font(15);
    sublb.adjustsFontSizeToFitWidth=YES;
    sublb.text=@"处理时间：";
    [tempView addSubview:sublb];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(sublb.right, 0, SCREEN_WIDTH-sublb.right-SCALE(8), sublb.height)];
    titlelb.numberOfLines=2;
    titlelb.text=gegionModel.htime;
    titlelb.font=Font(15);
    [tempView addSubview:titlelb];
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, sublb.bottom-0.5, tempView.width, 0.5)];
    [oneline setBackgroundColor:[UIColor colorWithRGB:0xc8c8c8]];
    [tempView addSubview:oneline];
    [mianScr addSubview:tempView];
    [mianScr setContentSize:CGSizeMake(SCREEN_WIDTH, tempView.bottom+30)];
    // Do any additional setup after loading the view.
}
#pragma mark------------进入导航--------
-(void)gotoNav{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [gegionModel.wd doubleValue];
    coordinate.longitude = [gegionModel.jd doubleValue];
    WEAKSELF
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"苹果自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf appleNaiWithCoordinate:coordinate andWithMapTitle:gegionModel.position];
        
    }]];
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
            [weakSelf aNaviWithCoordinate:coordinate andWithMapTitle:gegionModel.position];
            
        }]];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"alertController -- 百度地图");
            [weakSelf baiduNaviWithCoordinate:coordinate andWithMapTitle:gegionModel.position];
            
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
