//
//  SliderSwitchView.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/21.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SUNSlideSwitchViewDelegate;

@interface SliderSwitchView : UIView<UIScrollViewDelegate>
{
     BOOL _isRootScroll;  //是否主视图滑动
}
@property (nonatomic,strong)UIScrollView *bbScrollView;//顶部页签视图
@property (nonatomic,strong)UIScrollView *rootScrollView;//主视图
@property (nonatomic,assign)BOOL isBuildUI; //是否建立了ui
@property (nonatomic,strong)UIColor *tabItemNormalColor;//正常时tab文字颜色
@property (nonatomic,strong)UIColor *tabItemSelectedColor;//选中时tab文字颜色
@property (nonatomic,strong)UIColor *hdColor;
@property (nonatomic,strong)UIImage *tabItemNormalBackgroundImage;//正常时tab的背景
@property (nonatomic, weak) id<SUNSlideSwitchViewDelegate> slideSwitchViewDelegate;
@property (nonatomic,strong)UIImage *tabItemSelectedBackgroundImage;//选中时tab的背景
@property (nonatomic,strong)NSMutableArray *viewArray;//主视图的子视图数组
@property (nonatomic,assign) BOOL isScroll;//是否需要滑动
@property (nonatomic,assign) BOOL isNoMainScroll;
@property (nonatomic,strong)UIButton *selectBtn;

@property (nonatomic,strong)UIImageView *shadowImageView;

- (void)buildUI;
@end
@protocol SUNSlideSwitchViewDelegate <NSObject>

@optional


- (void)slideSwitchView:(SliderSwitchView *)view panLeftEdge:(UIPanGestureRecognizer*) panParam;


- (void)slideSwitchView:(SliderSwitchView *)view panRightEdge:(UIPanGestureRecognizer*) panParam;


- (void)slideSwitchView:(SliderSwitchView *)view didselectTab:(NSUInteger)number;
@end
