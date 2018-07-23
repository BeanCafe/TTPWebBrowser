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
@end

@implementation TTPReloadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.reloadIconImageView];
        [self addSubview:self.errorInfoLabel];
        [self adjustLayOut];
        
        self.errorInfoLabel.text = @"这儿额错误是个非常严重的错误!!!!!!!!!!!!!!!!!";
    }
    return self;
}

//- (void)setErrorStr:(NSString *)errorStr {
//    if (!_errorStr) {
//
//    }
//    return _errorStr;
//}

- (UIImageView *)reloadIconImageView {
    if (!_reloadIconImageView) {
        _reloadIconImageView = [[UIImageView alloc]init];
        _reloadIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _reloadIconImageView.backgroundColor = [UIColor blackColor];
    }
    return _reloadIconImageView;
}

- (UILabel *)errorInfoLabel {
    if (!_errorInfoLabel) {
        _errorInfoLabel = [[UILabel alloc]init];
        _errorInfoLabel.textAlignment = NSTextAlignmentCenter;
        _errorInfoLabel.numberOfLines = 0;
    }
    return _errorInfoLabel;
}

- (void)adjustLayOut {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
//    NSLayoutConstraint *reloadIconCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.reloadIconImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
//    [self addConstraint:reloadIconCenterXConstraint];
//    NSLayoutConstraint *reloadIconCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.reloadIconImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-50];
//    [self addConstraint:reloadIconCenterYConstraint];
//
//    NSLayoutConstraint *reloadIconWidthConstraint = [NSLayoutConstraint constraintWithItem:self.reloadIconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.6 constant:0];
//    [self addConstraint:reloadIconWidthConstraint];
//    NSLayoutConstraint *reloadIconHeightConstraint = [NSLayoutConstraint constraintWithItem:self.reloadIconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.reloadIconImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
//    [self.reloadIconImageView addConstraint:reloadIconHeightConstraint];
    
//    NSLayoutConstraint *errorIconCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.errorInfoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.reloadIconImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
//    [self addConstraint:errorIconCenterXConstraint];
//    NSLayoutConstraint *errorInfoCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.errorInfoLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.reloadIconImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:10];
//    [self addConstraint:errorInfoCenterYConstraint];
//    
//    NSLayoutConstraint *errorInfoWidthConstraint = [NSLayoutConstraint constraintWithItem:self.errorInfoLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.reloadIconImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
//    [self.errorInfoLabel addConstraint:errorInfoWidthConstraint];
//    NSLayoutConstraint *errorInfoHeightConstraint = [NSLayoutConstraint constraintWithItem:self.errorInfoLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:nil multiplier:1.0 constant:50];
//    [self.errorInfoLabel addConstraint:errorInfoHeightConstraint];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
