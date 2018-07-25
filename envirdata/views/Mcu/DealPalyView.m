//
//  DealPalyView.m
//  envirdata
//
//  Created by 熊佳佳 on 18/7/16.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "DealPalyView.h"

@implementation DealPalyView
{
    UIButton                 *g_nopalyImageView;//表示暂停 和播放按钮
    UIButton                 *g_shopBtn;//停止按钮
    UIButton                 *g_capture;//抓取图片
    UIButton                    *g_leftBtn;//左边
    UIButton                    *g_topBtn;//上边
    UIButton                    *g_rightBtn;//右边
    UIButton                    *g_bottomBtn;//下边
    BOOL isplay;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //播放暂停
        g_nopalyImageView =[UIButton buttonWithType:UIButtonTypeCustom];
        [g_nopalyImageView setImage:PNGIMAGE(@"play") forState:UIControlStateNormal];
        [g_nopalyImageView addTarget:self action:@selector(replayVodio) forControlEvents:UIControlEventTouchUpInside];
        g_nopalyImageView.hidden=YES;
        [self addSubview:g_nopalyImageView];
        
        g_leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        g_leftBtn.frame=CGRectMake(0, 0, 20, 20);
        [g_leftBtn setImage:PNGIMAGE(@"g_left") forState:UIControlStateNormal];
        g_leftBtn.tag=1000;
        g_leftBtn.hidden=YES;
        [g_leftBtn addTarget:self action:@selector(ptzDirection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:g_leftBtn];
        
        g_topBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        g_topBtn.frame=CGRectMake(0, 0, 20, 20);
        [g_topBtn setImage:PNGIMAGE(@"g_top") forState:UIControlStateNormal];
        g_topBtn.tag=1001;
        g_topBtn.hidden=YES;
        [g_topBtn addTarget:self action:@selector(ptzDirection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:g_topBtn];
        
        g_rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        g_rightBtn.frame=CGRectMake(0, 0, 20, 20);
        [g_rightBtn setImage:PNGIMAGE(@"g_right") forState:UIControlStateNormal];
        g_rightBtn.tag=1002;
        g_rightBtn.hidden=YES;
        [g_rightBtn addTarget:self action:@selector(ptzDirection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:g_rightBtn];
        
        g_bottomBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        g_bottomBtn.frame=CGRectMake(0, 0, 20, 20);
        [g_bottomBtn setImage:PNGIMAGE(@"g_bottom") forState:UIControlStateNormal];
        g_bottomBtn.tag=1003;
        g_bottomBtn.hidden=YES;
        [g_bottomBtn addTarget:self action:@selector(ptzDirection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:g_bottomBtn];
        
        g_shopBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
        g_shopBtn.frame=CGRectMake(SCALE(5), SCALE(5), 20, 20);
        [g_shopBtn setImage:PNGIMAGE(@"暂停") forState:UIControlStateNormal];
        g_shopBtn.hidden=YES;
        isplay=YES;
        [g_shopBtn addTarget:self action:@selector(shopbtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:g_shopBtn];
        
        
        g_capture =[UIButton buttonWithType:UIButtonTypeCustom];
        g_capture.frame=CGRectMake(self.width-SCALE(5), SCALE(10), 20, 20);
        g_capture.right=self.width-SCALE(5);
        [g_capture setImage:PNGIMAGE(@"照相") forState:UIControlStateNormal];
        g_capture.hidden=YES;
        [g_capture addTarget:self action:@selector(capture:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:g_capture];
        

        g_nopalyImageView.frame=CGRectMake(0, 0, 20, 20);
        g_nopalyImageView.center=CGPointMake(self.width/2.0, self.height/2.0);
        g_leftBtn.center=CGPointMake(SCALE(5), self.height/2.0);
        g_leftBtn.left=SCALE(5);
        
        g_topBtn.center=CGPointMake(self.width/2.0, SCALE(10));
        g_topBtn.top=SCALE(5);
        
        
        g_rightBtn.center=CGPointMake(self.width-SCALE(5), self.height/2.0);
        g_rightBtn.right=self.width-SCALE(5);
        
        g_bottomBtn.center=CGPointMake(self.width/2.0, self.height-SCALE(10));
        g_bottomBtn.bottom=self.height-SCALE(5);
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
#pragma mark - Event Response
-(void)ptzDirection:(UIButton*)button{
    
    button.selected=NO;
    int ptzDirection=0;
    if (button.tag==1000) {//left
        ptzDirection =PTZ_COMMAND_PAN_LEFT;
    }else if (button.tag==1001){//top
        ptzDirection =PTZ_COMMAND_TILT_UP;
    }else if (button.tag==1002){//right
        ptzDirection =PTZ_COMMAND_PAN_RIGHT;
    }else if (button.tag==1003){//bottom
        ptzDirection =PTZ_COMMAND_TILT_DOWN;
    }
    if (ptzDirection!=0) {
        [self ptzOperation:ptzDirection stop:YES end:NO];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //执行事件
            button.selected=YES;
            [self ptzOperation:ptzDirection stop:YES end:YES];
        });
    }
}
-(void)replayVodio{
    if (self.delegate) {
        [self.delegate deal_playrefreshRealPlay];
    }
}
-(void)shopbtn:(UIButton*)sender{
    isplay=!isplay;
    [self.delegate deal_pausing:isplay];
}
-(void)capture:(UIButton*)sender{
    if (self.delegate) {
        [self.delegate deal_capture];
    }
}

- (void)setIsPausing:(BOOL)isPausing{
    _isPausing=isPausing;
    dispatch_async(dispatch_get_main_queue(), ^{
        g_nopalyImageView.hidden=isPausing;
        g_rightBtn.hidden=!isPausing;
        g_topBtn.hidden=!isPausing;
        g_leftBtn.hidden=!isPausing;
        g_bottomBtn.hidden=!isPausing;
        g_shopBtn.hidden=!isPausing;
        g_capture.hidden=!isPausing;
    });
}
// 根据云台操作命令,设置播放视图上的自定义播放动画状态
- (void)ptzOperation:(int)ptzCommand stop:(BOOL)stop end:(BOOL)end {
    [self.delegate deal_ptzOperationInControl:ptzCommand stop:stop end:end];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
