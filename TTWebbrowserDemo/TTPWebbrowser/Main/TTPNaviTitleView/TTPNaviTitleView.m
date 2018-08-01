//
//  TTPNaviTitleView.m
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/31.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "TTPNaviTitleView.h"

@implementation TTPNaviTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)setNewTitle:(NSString *)title withContainerViewController:(UIViewController *)viewController {
    //查阅分析得出各个控件宽度
    //返回按钮, 返回按钮+返回图标宽度
    CGFloat backBarButtonWidth = 65.f;
    //关闭按钮宽度
    CGFloat closeBarButtonWidth = 0.f;
    //更多按钮的宽度
    CGFloat moreButtonButtonWidth = 44.f;
    //各个控件之间的间距
    CGFloat barButtonGap = 10.f;
    
    UINavigationBar *navigationBar = viewController.navigationController.navigationBar;
    CGFloat screenSizeWidth = [navigationBar bounds].size.width;
    
    //间距数量
    NSInteger gapNum = 2;
    
    /*
     * 如果视图控制器有关闭按钮则把关闭按钮宽度算上
     */
    if (viewController.navigationItem.leftBarButtonItems.count) {
        closeBarButtonWidth = 44.f;
        gapNum = 4;
    }
    
    CGFloat titleLabelWidth = screenSizeWidth-backBarButtonWidth-closeBarButtonWidth-moreButtonButtonWidth-barButtonGap*gapNum;
    NSAttributedString *attributedStr = [[NSAttributedString alloc]initWithString:title attributes:navigationBar.titleTextAttributes];
    self.titleLabel.attributedText = attributedStr;
    self.titleLabel.frame = CGRectMake(0, 0, titleLabelWidth, self.frame.size.height);
    self.titleLabel.center = CGPointMake(closeBarButtonWidth?closeBarButtonWidth/2:0, self.titleLabel.center.y);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
