//
//  SliderSwitchView.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/21.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "SliderSwitchView.h"

@implementation SliderSwitchView
@synthesize bbScrollView,rootScrollView,isBuildUI,tabItemNormalColor,tabItemSelectedColor,tabItemNormalBackgroundImage,tabItemSelectedBackgroundImage,viewArray,shadowImageView,isScroll,hdColor,isNoMainScroll;
static UIButton *selectBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *oneline1=[[UIImageView alloc]initWithFrame:CGRectMake(0,2, kScreenWidth, 1)];
        [self addSubview:oneline1];//防止与MJScroll冲突
        //创建顶部可滑动的tab
        bbScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
        bbScrollView.backgroundColor = [UIColor clearColor];
        bbScrollView.pagingEnabled = NO;
        bbScrollView.bounces = NO;
        bbScrollView.showsHorizontalScrollIndicator = NO;
        bbScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:bbScrollView];
        //横线
        UIImageView *oneline=[[UIImageView alloc]initWithFrame:CGRectMake(0,bbScrollView.bottom, kScreenWidth, 0.5)];
        [oneline setBackgroundColor:RGBCOLOR(220, 220, 220)];
        [self addSubview:oneline];
    
        //创建主滚动视图
        rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, oneline.bottom, self.bounds.size.width, frame.size.height - oneline.bottom)];
        rootScrollView.delegate = self;
        rootScrollView.pagingEnabled = YES;
        rootScrollView.userInteractionEnabled = YES;
        rootScrollView.bounces = NO;
        rootScrollView.showsHorizontalScrollIndicator = NO;
        rootScrollView.showsVerticalScrollIndicator = NO;
        [rootScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];//当列表滑出左右时传递手势去打开抽屉
        [self addSubview:rootScrollView];
    }
    return self;
}
- (void)buildUI
{
    shadowImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, bbScrollView.bottom-1, 100, 1)];
    shadowImageView.backgroundColor=hdColor;
    //更新主视图各个子视图的宽度
    for (int i = 0; i < [viewArray count]; i++) {
        UIViewController *listVC = viewArray[i];
        listVC.view.frame = CGRectMake(self.width*i, 0,rootScrollView.width,rootScrollView.height);
        [rootScrollView addSubview:listVC.view];
    }
    if (isNoMainScroll==YES) {
        [rootScrollView setContentSize:CGSizeMake(0, 0)];
    }else{
        [rootScrollView setContentSize:CGSizeMake([viewArray count]*rootScrollView.width, 0)];
    }
    
    //创建按钮
    CGFloat xOffset = 10;
    float buttonK=self.width/viewArray.count;
    if (isScroll==YES) {
        xOffset=0;
    }
    for (int i=0; i<viewArray.count; i++) {
        UIViewController *vc = viewArray[i];
        CGSize textSize =[vc.title sizeWithAttributes:@{NSFontAttributeName:Font(16)}];
        UIButton *tabarbtn=[[UIButton alloc]initWithFrame:CGRectMake(xOffset, 0, isScroll==YES?buttonK:textSize.width+12, bbScrollView.height)];
        tabarbtn.titleLabel.font=Font(16);
        [tabarbtn setTitle:vc.title forState:UIControlStateNormal];
        [tabarbtn setTitleColor:tabItemNormalColor?:[UIColor grayColor] forState:UIControlStateNormal];
         [tabarbtn setTitleColor:tabItemSelectedColor?:[UIColor blueColor] forState:UIControlStateSelected];
        tabarbtn.tag=i+100;
        [tabarbtn addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [bbScrollView addSubview:tabarbtn];
        xOffset=tabarbtn.right;
        if (i==0) {
            tabarbtn.selected=YES;
            selectBtn=tabarbtn;
            shadowImageView.centerX=selectBtn.centerX;
            shadowImageView.width=textSize.width;
        }
    }
    [bbScrollView addSubview:shadowImageView];
    //设置顶部滚动视图的内容总尺寸
    if (isScroll==NO) {
        bbScrollView.contentSize = CGSizeMake(xOffset, 0);
    }
}
#pragma mark - 顶部滚动视图逻辑方法

- (void)selectNameButton:(UIButton *)sender
{
    //如果点击的tab文字显示不全，调整滚动视图x坐标使用使tab文字显示全
    [self adjustScrollViewContentX:sender];
    
    //如果更换按钮
    if (sender!=selectBtn) {
        selectBtn.selected=NO;
        selectBtn=sender;
    }
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            shadowImageView.centerX=sender.centerX;
            if (isScroll==NO) {
               shadowImageView.width=sender.width;
            }
        } completion:^(BOOL finished) {
            //设置新页出现
            if (!_isRootScroll) {
                [rootScrollView setContentOffset:CGPointMake((sender.tag - 100)*self.bounds.size.width, 0) animated:YES];
            }
            _isRootScroll = NO;
            if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
                [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:sender.tag - 100];
            }
        }];
    }
}


- (void)adjustScrollViewContentX:(UIButton *)sender
{
    if (isScroll==YES) {
        return;
    }
    //如果 当前显示的最后一个tab文字超出右边界
    if (sender.mj_x - bbScrollView.contentOffset.x > self.bounds.size.width - (10+sender.bounds.size.width)) {
        //向左滚动视图，显示完整tab文字
        [bbScrollView setContentOffset:CGPointMake(sender.frame.origin.x - (bbScrollView.bounds.size.width- (10+sender.bounds.size.width)), 0)  animated:YES];
    }
    //如果 （tab的文字坐标 - 当前滚动视图左边界所在整个视图的x坐标） < 按钮的隔间 ，代表tab文字已超出边界
    if (sender.frame.origin.x - bbScrollView.contentOffset.x < 10) {
        //向右滚动视图（tab文字的x坐标 - 按钮间隔 = 新的滚动视图左边界在整个视图的x坐标），使文字显示完整
        [bbScrollView setContentOffset:CGPointMake(sender.frame.origin.x - 10, 0)  animated:YES];
    }
}

//减速停止了时执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == rootScrollView) {
        _isRootScroll = YES;
        //调整顶部滑条按钮状态
        int tag = (int)scrollView.contentOffset.x/self.bounds.size.width +100;
        UIButton *button = (UIButton *)[bbScrollView viewWithTag:tag];
        [self selectNameButton:button];
    }
}
//传递滑动事件给下一层来判断左右手势
-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    //当滑道左边界时，传递滑动事件给代理
    if(rootScrollView.contentOffset.x <= 0) {
        if (self.slideSwitchViewDelegate
            && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panLeftEdge:)]) {
            [self.slideSwitchViewDelegate slideSwitchView:self panLeftEdge:panParam];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
