//
//  TTPReloadView.m
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/20.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "TTPReloadView.h"

@interface TTPReloadView()
@property(strong, nonatomic)UIImageView *reloadIconImageView;
@property(strong, nonatomic)UILabel *errorInfoLabel;
@property(copy, nonatomic)TTPReloadBlock reloadBlock;
@end

@implementation TTPReloadView

- (instancetype)initWithFrame:(CGRect)frame reloadHandler:(TTPReloadBlock)reloadHanlder
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //添加错误icon
        [self addSubview:self.reloadIconImageView];
        //添加错误信息label
        [self addSubview:self.errorInfoLabel];
        //调整布局
        [self adjustLayOut];
        
        self.reloadBlock = reloadHanlder;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        self.error = nil;
    }
    return self;
}

/**
 点击事件会滴啊

 @param tap tap手势
 */
- (void)tapAction:(UITapGestureRecognizer *)tap {
    _reloadBlock(tap);
}

#pragma mark - 外部接口

/**
 提示错误信息

 @param error 错误对象
 */
- (void)setError:(NSError *)error {
    _error = error;
    
    if (!error) {
        error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:-1 userInfo:nil];
    }
    NSString *errorInfo = [NSString stringWithFormat:@"网络加载错误, 轻触重新加载:%ld", error.code];
    self.errorInfoLabel.text = errorInfo;
}

- (void)showInView:(UIView *)view {
    [self removeFromSuperview];
    [view addSubview:self];
    
    //iPhone X屏幕适配
    id layOutTargetItem = nil;
    if (@available(iOS 11.0, *)) {
        layOutTargetItem = view.safeAreaLayoutGuide;
    } else {
        layOutTargetItem = view;
    }
    //错误信息提示视图
    //reloadView顶部距离safeArea为0
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *reloadTopConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:layOutTargetItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [view addConstraint:reloadTopConstraint];
    
    NSLayoutConstraint *reloadLeftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [view addConstraint:reloadLeftConstraint];
    
    NSLayoutConstraint *reloadBottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [view addConstraint:reloadBottomConstraint];
    
    NSLayoutConstraint *reloadRightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [view addConstraint:reloadRightConstraint];
}

- (void)dissmiss {
    [self removeFromSuperview];
}

#pragma mark - Setters

- (UIImageView *)reloadIconImageView {
    if (!_reloadIconImageView) {
        _reloadIconImageView = [[UIImageView alloc]init];
        _reloadIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_reloadIconImageView setImage:[UIImage imageNamed:@"ttpbrowser_update-arrows"]];
    }
    return _reloadIconImageView;
}

- (UILabel *)errorInfoLabel {
    if (!_errorInfoLabel) {
        _errorInfoLabel = [[UILabel alloc]init];
        _errorInfoLabel.textAlignment = NSTextAlignmentCenter;
        _errorInfoLabel.font = [UIFont systemFontOfSize:12];
        _errorInfoLabel.textColor = [UIColor colorWithRed:177./255 green:177./255 blue:177./255 alpha:1.0];
        _errorInfoLabel.numberOfLines = 0;
    }
    return _errorInfoLabel;
}

#pragma mark - 布局

/**
 调整布局
 */
- (void)adjustLayOut {
    self.reloadIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.errorInfoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //reloadIcon
    //reloadIcon x方向居中
    NSLayoutConstraint *reloadIconCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.reloadIconImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:reloadIconCenterXConstraint];
    //reloadIcon Y在根据屏幕比例从父视图顶部向下偏移
    CGFloat screenHeight  = [[UIScreen mainScreen] bounds].size.height;
    CGFloat floatDownScale = 64.f/568;
    NSLayoutConstraint *reloadIconCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.reloadIconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:screenHeight*floatDownScale];
    [self addConstraint:reloadIconCenterYConstraint];
    //reloadIcon 宽度等于父视图宽度的0.23
    NSLayoutConstraint *reloadIconWidthConstraint = [NSLayoutConstraint constraintWithItem:self.reloadIconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.23 constant:0];
    [self addConstraint:reloadIconWidthConstraint];
    //reloadIcon 高度与自身宽度相等
    NSLayoutConstraint *reloadIconHeightConstraint = [NSLayoutConstraint constraintWithItem:self.reloadIconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.reloadIconImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    [self.reloadIconImageView addConstraint:reloadIconHeightConstraint];
    
    //errorInfoLabel
    //errorInfoLabel x方向与relodIcon相同
    NSLayoutConstraint *errorIconCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.errorInfoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.reloadIconImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:errorIconCenterXConstraint];
    //errorInfoLabel Y方向在reloadIcon下方10像素下
    NSLayoutConstraint *errorInfoYConstraint = [NSLayoutConstraint constraintWithItem:self.errorInfoLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.reloadIconImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
    [self addConstraint:errorInfoYConstraint];
    //errorInfoLabel 宽度等于reloadIcon宽度的1.6
    NSLayoutConstraint *errorInfoWidthConstraint = [NSLayoutConstraint constraintWithItem:self.errorInfoLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.reloadIconImageView attribute:NSLayoutAttributeWidth multiplier:1.6 constant:0];
    [self addConstraint:errorInfoWidthConstraint];
    //errorInfoLabel 高度最高不超过60
    NSLayoutConstraint *errorInfoHeightConstraint = [NSLayoutConstraint constraintWithItem:self.errorInfoLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60];
    [self.errorInfoLabel addConstraint:errorInfoHeightConstraint];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
