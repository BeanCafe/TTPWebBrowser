//
//  TTPWebViewProgressView.m
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/12.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "TTPWebViewProgressView.h"

#import "TTPMacros.h"

static CGFloat const TTPWebProgressAutoGrowSpeedHigh = 0.001f;
static CGFloat const TTPWebProgressAutoGrowSpeedMiddle = 0.00002f;
static CGFloat const TTPWebProgressAutoGrowSpeedLow = 0.000002f;

@interface TTPWebViewProgressView ()
@property(strong, nonatomic)NSTimer *progressAutoGrowTimer;
@property(nonatomic, assign)BOOL isAutoProcessing;
@end

@implementation TTPWebViewProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureViews];
}

- (void)configureViews
{
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:self.bounds];
    _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIColor *tintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0]; // iOS7 Safari bar color
    if ([UIApplication.sharedApplication.delegate.window respondsToSelector:@selector(setTintColor:)] && UIApplication.sharedApplication.delegate.window.tintColor) {
        tintColor = UIApplication.sharedApplication.delegate.window.tintColor;
    }
    _progressBarView.backgroundColor = tintColor;
    [self addSubview:_progressBarView];
    
    _barAnimationDuration = 0.27f;
    _fadeAnimationDuration = 0.27f;
    _fadeOutDelay = 0.1f;
}

- (void)viewDidDisappear {
    [self.progressAutoGrowTimer invalidate];
}

#pragma mark - 进度/进度条增长动画

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    //对progress进行赋值
    _progress = (progress>_progress)?progress:_progress;
    
    [self progressAutoGrowTimerStartUp];
    
    BOOL isGrowing = _progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _progressBarView.frame;
        frame.size.width = _progress * self.bounds.size.width;
        _progressBarView.frame = frame;
    } completion:nil];
    
    if (_progress >= 1.0) {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:_fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = _progressBarView.frame;
            frame.size.width = 0;
            _progressBarView.frame = frame;
        }];
    }
    else {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 1.0;
        } completion:nil];
    }
}

#pragma mark - 自动增长进度定时器

/**
 定时器创建
 
 @return 返回定时器
 */
- (NSTimer *)progressAutoGrowTimer {
    if (!_progressAutoGrowTimer) {
        //以60fps的频率刷新进度条
        _progressAutoGrowTimer = [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(progressAutoGrowAction) userInfo:nil repeats:YES];
    }
    return _progressAutoGrowTimer;
}

/**
 定时器自动增长进度循环方法
 */
- (void)progressAutoGrowAction {
    //进度完成时定时器暂停
    if (self.progress>=1.0f) {
        [self progressAutoGrowTimerTurnDown];
        return;
    }
    
    /*
     * 根据情镜分析使用那种速度加载进度条
     * 进度条进度大于0.95时增长速度最慢
     * 进度条进度介于0.8~0.95时增长速度中等
     * 进度条进度介于0~0.8时速度增长最快
     */
    CGFloat growSpeed = 0.f;
    if (self.progress>=0.95f) {
        growSpeed = TTPWebProgressAutoGrowSpeedLow;
    } else if (self.progress>=0.8f && self.progress<0.95f) {
        growSpeed = TTPWebProgressAutoGrowSpeedMiddle;
    } else {
        growSpeed = TTPWebProgressAutoGrowSpeedHigh;
    }
    [self setProgress:self.progress+growSpeed animated:YES];
}

/**
 启动自动增长进度定时器
 */
- (void)progressAutoGrowTimerStartUp {
    if (self.isAutoProcessing) {
        TTPLog(@"定时器已经启动!");
        return;
    }
    
    //打开定时器
    [self.progressAutoGrowTimer setFireDate:[NSDate distantPast]];
    //定时器是否正在进行标志更改为Yes
    self.isAutoProcessing = YES;
}

/**
 关闭定时器
 */
- (void)progressAutoGrowTimerTurnDown {
    if (!self.isAutoProcessing) {
        TTPLog(@"定时器已经关闭");
        return;
    }
    
    //重置进度条进度
    _progress = 0.f;
    //暂时关闭定时器
    [self.progressAutoGrowTimer setFireDate:[NSDate distantFuture]];
    //定时器是否正在进行标志更改为NO
    self.isAutoProcessing = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
