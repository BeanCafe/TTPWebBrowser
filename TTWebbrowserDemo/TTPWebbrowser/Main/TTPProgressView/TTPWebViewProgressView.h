//
//  TTPWebViewProgressView.h
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/12.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPWebViewProgressView : UIView
@property (nonatomic) float progress;

@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // default 0.1

/**
 更新进度条进度
 内部与外部均调用此方法动态更新进度条的进度
 
 @param progress 新的进度
 @param animated 是否动画增长
 */
- (void)setProgress:(float)progress animated:(BOOL)animated;

/**
 外部Vc view确实不在屏幕时, 需要调用此方法, 此方法会将定时器进行无效化处理
 */
- (void)viewDidDisappear;

@end
