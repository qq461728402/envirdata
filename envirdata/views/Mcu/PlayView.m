//
//  PlayView.m
//  Mcu_sdk_demo
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 hikvision. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView {
    UIScrollView                *g_playScrollView;
    
    UIImageView                 *g_ptzDirectionImageView;/**<手势图片*/
    UIImageView                 *g_ptzZoomImageView;/**< 手势图片*/
    
    
//    UIPanGestureRecognizer      *g_panGestureRecognizer;/**< 滑动手势*/
    UIPinchGestureRecognizer    *g_pinchGestureRecognizer;/**< 捏合手势*/
    
    CGPoint _gestureStartPoint;
    NSDate *_touchTime;
    CGPoint _panPreviousPosition;
    float _dragDistance;
    CGPoint _tenPreviousPoint;
    float _ptzDirectionAngle;
    int _ptzDirection;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        g_playScrollView = [[UIScrollView alloc]init];
        g_playScrollView.minimumZoomScale = 1.0;
        g_playScrollView.maximumZoomScale = 1.0;
        g_playScrollView.bounces = NO;
        g_playScrollView.showsHorizontalScrollIndicator = NO;
        g_playScrollView.showsVerticalScrollIndicator = NO;
        g_playScrollView.delegate = self;
        [self addSubview:g_playScrollView];
        _playView= [[UIView alloc]init];
        [_playView setBackgroundColor:[UIColor blackColor]];
        [g_playScrollView addSubview:_playView];
        //播放暂停
       
    
        // 添加捏合手势识别器
        g_pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandle:)];
        g_ptzDirectionImageView = [[UIImageView alloc] init];
        g_ptzDirectionImageView.bounds = CGRectMake(0, 0, 55, 55);
        [self addSubview:g_ptzDirectionImageView];
        
        g_ptzZoomImageView = [[UIImageView alloc] init];
        [self addSubview:g_ptzZoomImageView];
        
        g_playScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _playView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        [g_playScrollView setZoomScale:1.0];
        
        g_playScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame),0);
        

    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
#pragma mark - Custom delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _playView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    g_playScrollView.contentSize = CGSizeMake(_playView.frame.size.width, _playView.frame.size.height);
}

#pragma mark - Event Response
-(void)ptzDirection:(UIButton*)button{
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
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //执行事件    
            [self ptzOperation:ptzDirection stop:YES end:YES];
        });
    }
}
-(void)replayVodio{
    if (self.delegate) {
        [self.delegate playrefreshRealPlay];
    }
}





//滑动手势
- (void)panGestureHandle:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        _gestureStartPoint = [panGesture locationInView:self];
        _panPreviousPosition = _gestureStartPoint;
        _tenPreviousPoint = _gestureStartPoint;
        _touchTime = [NSDate date];
        _ptzDirection = 0;
        //        [self.delegate ptzMaskViewpanGestureBegan];
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        NSTimeInterval timeInterval = - [_touchTime timeIntervalSinceNow];
        if (timeInterval < kMaxSwipeInterval)
        {
            return;
        }
        
        CGPoint currentPosition = [panGesture locationInView:self];
        _dragDistance += [self cgPointDistance:_panPreviousPosition second:currentPosition];
        _panPreviousPosition = currentPosition;
        unsigned int ptzDirection = 0;
        if (_dragDistance >= kMaxVariance)
        {
            _dragDistance = 0.0f;
            _ptzDirectionAngle = [self cgPointAngle:_tenPreviousPoint second:currentPosition];
            _tenPreviousPoint = currentPosition;
        }
        // 云台控制的方向
        ptzDirection = [self directionByAngle:_ptzDirectionAngle];
        
        if (_ptzDirection == ptzDirection)
        {
            return;
        }
        _ptzDirection = ptzDirection;
        //相同方向，direction和ptz command的值一样
        [self ptzOperation:ptzDirection stop:NO end:NO];
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled)
    {
        NSTimeInterval timeInterval = - [_touchTime timeIntervalSinceNow];
        if (timeInterval <= kMaxSwipeInterval)
        {
            CGPoint currentPosition = [panGesture locationInView:self];
            float ptzDirectionAngle = [self cgPointAngle:_gestureStartPoint second:currentPosition];
            // 云台控制的方向
            unsigned int ptzDirection = 0;
            ptzDirection = [self directionByAngle:ptzDirectionAngle];
            [self ptzOperation:ptzDirection stop:NO end:YES];
        }
        else
        {// pan 停止
            CGPoint currentPosition = [panGesture locationInView:self];
            _dragDistance += [self cgPointDistance:_panPreviousPosition second:currentPosition];
            _panPreviousPosition = currentPosition;
            unsigned int ptzDirection = 0;
            if (_dragDistance >= kMaxVariance)
            {
                _dragDistance = 0.0f;
                _ptzDirectionAngle = [self cgPointAngle:_tenPreviousPoint second:currentPosition];
                _tenPreviousPoint = currentPosition;
            }
            // 云台控制的方向
            ptzDirection = [self directionByAngle:_ptzDirectionAngle];
            [self ptzOperation:ptzDirection stop:YES end:YES];
        }
    }
}

/*  @fn     - (void)pinchGestureHandle:(UIPinchGestureRecognizer *)pinchGestureRecognizer
 *  @brief  通过捏合实现焦距放大缩小操作
 *  @param  pinchGestureRecognizer 捏合手势识别器
 *  @return nil
 */
- (void)pinchGestureHandle:(UIPinchGestureRecognizer *)pinchGesture {
    if (pinchGesture.state == UIGestureRecognizerStateChanged) {
        if (pinchGesture.scale <= 0.8f)
        {// PTZ_COMMAND_ZOOM_OUT
            [self ptzOperation:PTZ_COMMAND_ZOOM_OUT stop:NO end:NO];
        }
        else if (pinchGesture.scale > 1.25f)
        {
            [self ptzOperation:PTZ_COMMAND_ZOOM_IN stop:NO end:NO];
        }
    }else if (pinchGesture.state == UIGestureRecognizerStateEnded || pinchGesture.state == UIGestureRecognizerStateCancelled)
    {
        if (pinchGesture.scale <= 1.0f)
        {// PTZ_COMMAND_ZOOM_OUT
            [self ptzOperation:PTZ_COMMAND_ZOOM_OUT stop:NO end:YES];
        }
        else if (pinchGesture.scale > 1.0f)
        {
            [self ptzOperation:PTZ_COMMAND_ZOOM_IN stop:NO end:YES];
        }
    }
}

#pragma mark - private method
// 计算两点间的距离
- (float)cgPointDistance:(CGPoint)first second:(CGPoint)second
{
    float deltaX = second.x - first.x;
    float deltaY = second.y - first.y;
    return sqrt(deltaX * deltaX + deltaY * deltaY);
}

// 计算两点间的角度
- (float)cgPointAngle:(CGPoint)first second:(CGPoint)second
{
    float angle = atanl((second.y - first.y) / (second.x - first.x));
    if (second.x < first.x)
    {
        angle += M_PI;
    }
    return angle;
}

// 通过CGPointAngle计算的角度获得方向
- (Direction)directionByAngle:(float)angle {
    static const float M_PI_8 = M_PI / 8.0f;
    if ((11 * M_PI_8 < angle && angle <= 3 * M_PI_2) || (- M_PI_2 <= angle && angle <= - 3 * M_PI_8))
    {
        return Up;
    }
    else if (- 3 * M_PI_8 < angle && angle <= - M_PI_8)
    {
        return UpRight;
    }
    else if (- M_PI_8 < angle && angle <= M_PI_8)
    {
        return Right;
    }
    else if (M_PI_8 < angle && angle <= 3 * M_PI_8)
    {
        return DownRight;
    }
    else if (3 * M_PI_8 < angle && angle <= 5 * M_PI_8)
    {
        return Down;
    }
    else if (5 * M_PI_8 < angle && angle <= 7 * M_PI_8)
    {
        return DownLeft;
    }
    else if (7 * M_PI_8 < angle && angle <= 9 * M_PI_8)
    {
        return Left;
    }
    else if (9 * M_PI_8 < angle && angle <= 11 * M_PI_8)
    {
        return UpLeft;
    }
    else
    { // 不应到这里
        return Up;
    }
}

// 根据云台操作命令,设置播放视图上的自定义播放动画状态
- (void)ptzOperation:(int)ptzCommand stop:(BOOL)stop end:(BOOL)end {
     if (ptzCommand == PTZ_COMMAND_ZOOM_IN || ptzCommand == PTZ_COMMAND_ZOOM_OUT)
    {
        if (stop)
        {
            [self stopPtzZoomAnimation];
        }
        else
        {
            [self startPtzZoomAnimation:ptzCommand == PTZ_COMMAND_ZOOM_IN];
        }
    }
    [self.delegate ptzOperationInControl:ptzCommand stop:stop end:end];
    
    if (end && !stop)
    {
        // 先关闭动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kAutoStopInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (ptzCommand == PTZ_COMMAND_ZOOM_IN || ptzCommand == PTZ_COMMAND_ZOOM_OUT)
            {
                [self stopPtzZoomAnimation];
            }
        });
    }
}

// 捏合手势动画
- (void)startPtzZoomAnimation:(BOOL)zoomIn
{
    if (g_ptzZoomImageView.isAnimating)
    {
        [g_ptzZoomImageView stopAnimating];
    }
    UIImage *image1 = [UIImage imageNamed:(zoomIn ? @"focus_amplify_1.png" : @"focus_lessen_1.png")];
    UIImage *image2 = [UIImage imageNamed:(zoomIn ? @"focus_amplify_2.png" : @"focus_lessen_2.png")];
    UIImage *image3 = [UIImage imageNamed:(zoomIn ? @"focus_amplify_3.png" : @"focus_lessen_3.png")];
    g_ptzZoomImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    g_ptzZoomImageView.animationImages = [NSArray arrayWithObjects:image1, image2, image3, image3, nil];
    g_ptzZoomImageView.animationDuration = 1.0f;
    [g_ptzZoomImageView startAnimating];
}

// 停止捏合手势动画
- (void)stopPtzZoomAnimation
{
    if (g_ptzZoomImageView.isAnimating)
    {
        [g_ptzZoomImageView stopAnimating];
    }
}

// 开始方向动画
- (void)startPtzDirectionAnimation:(int)ptzDirection
{
    if (g_ptzDirectionImageView.isAnimating)
    {
        [g_ptzDirectionImageView stopAnimating];
    }
    
    UIImage *image1;
    UIImage *image2;
    UIImage *image3;
    
    switch (ptzDirection)
    {
        case Up:
            image1 = [UIImage imageNamed:@"up_1.png"];
            image2 = [UIImage imageNamed:@"up_2.png"];
            image3 = [UIImage imageNamed:@"up_3.png"];
            g_ptzDirectionImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(g_ptzDirectionImageView.frame) / 2);
            break;
            
        case Down:
            image1 = [UIImage imageNamed:@"down_1.png"];
            image2 = [UIImage imageNamed:@"down_2.png"];
            image3 = [UIImage imageNamed:@"down_3.png"];
            g_ptzDirectionImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - CGRectGetHeight(g_ptzDirectionImageView.frame) / 2);
            break;
            
        case Left:
            image1 = [UIImage imageNamed:@"left_1.png"];
            image2 = [UIImage imageNamed:@"left_2.png"];
            image3 = [UIImage imageNamed:@"left_3.png"];
            g_ptzDirectionImageView.center = CGPointMake(CGRectGetWidth(g_ptzDirectionImageView.frame) / 2, CGRectGetHeight(self.frame) / 2);
            break;
            
        case Right:
            image1 = [UIImage imageNamed:@"right_1.png"];
            image2 = [UIImage imageNamed:@"right_2.png"];
            image3 = [UIImage imageNamed:@"right_3.png"];
            g_ptzDirectionImageView.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(g_ptzDirectionImageView.frame) / 2, CGRectGetHeight(self.frame) / 2);
            break;
            
        case UpLeft:
            image1 = [UIImage imageNamed:@"left_up_1.png"];
            image2 = [UIImage imageNamed:@"left_up_2.png"];
            image3 = [UIImage imageNamed:@"left_up_3.png"];
            g_ptzDirectionImageView.center = CGPointMake(CGRectGetWidth(g_ptzDirectionImageView.frame) / 2, CGRectGetHeight(g_ptzDirectionImageView.frame) / 2);
            break;
            
        case UpRight:
            image1 = [UIImage imageNamed:@"right_up_1.png"];
            image2 = [UIImage imageNamed:@"right_up_2.png"];
            image3 = [UIImage imageNamed:@"right_up_3.png"];
            g_ptzDirectionImageView.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(g_ptzDirectionImageView.frame) / 2, CGRectGetHeight(g_ptzDirectionImageView.frame) / 2);
            break;
            
        case DownLeft:
            image1 = [UIImage imageNamed:@"left_down_1.png"];
            image2 = [UIImage imageNamed:@"left_down_2.png"];
            image3 = [UIImage imageNamed:@"left_down_3.png"];
            g_ptzDirectionImageView.center = CGPointMake(CGRectGetWidth(g_ptzDirectionImageView.frame) / 2, CGRectGetHeight(self.frame) - CGRectGetHeight(g_ptzDirectionImageView.frame) / 2);
            break;
            
        case DownRight:
            image1 = [UIImage imageNamed:@"right_down_1.png"];
            image2 = [UIImage imageNamed:@"right_down_2.png"];
            image3 = [UIImage imageNamed:@"right_down_3.png"];
            g_ptzDirectionImageView.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(g_ptzDirectionImageView.frame) / 2, CGRectGetHeight(self.frame) - CGRectGetHeight(g_ptzDirectionImageView.frame) / 2);
            break;
            
        default:
            break;
    }
    
    g_ptzDirectionImageView.animationImages = [NSArray arrayWithObjects:image1, image2, image3, nil];
    g_ptzDirectionImageView.animationDuration = 1.0f;
    [g_ptzDirectionImageView startAnimating];
}

// 停止方向动画
- (void)stopPtzDirectionAnimation
{
    if (g_ptzDirectionImageView.isAnimating)
    {
        [g_ptzDirectionImageView stopAnimating];
    }
}


#pragma mark - getter & setter
- (void)setIsEleZooming:(BOOL)isEleZooming {
    if (isEleZooming) {
        g_playScrollView.maximumZoomScale = 3.0f;
    } else {
        g_playScrollView.maximumZoomScale = 1.0f;
        [g_playScrollView setZoomScale:1.0];
        g_playScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,0);
    }
    _isEleZooming = isEleZooming;
}

- (void)setAddGesture:(BOOL)addGesture {
    if (addGesture) {
//        [_playView addGestureRecognizer:g_panGestureRecognizer];
        [_playView addGestureRecognizer:g_pinchGestureRecognizer];
    }else{
//        [_playView removeGestureRecognizer:g_panGestureRecognizer];
        [_playView removeGestureRecognizer:g_pinchGestureRecognizer];
    }
    _addGesture = addGesture;
}







- (void)setIsPtz:(BOOL)isPtz {
    self.addGesture = isPtz;
    _isPtz = isPtz;
}

@end
