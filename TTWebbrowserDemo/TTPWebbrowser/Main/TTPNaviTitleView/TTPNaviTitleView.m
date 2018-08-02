//
//  TTPNaviTitleView.m
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/31.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "TTPNaviTitleView.h"

@interface TTPNaviTitleView()
//弱引用titleView所在控制器, 不进行持有
@property(weak, nonatomic)UIViewController *currentViewController;

@property (strong, nonatomic)UILabel *titleLabel;
@end

@implementation TTPNaviTitleView

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDeviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

#pragma mark - PrivateMethod

/**
 收到屏幕旋转的通知

 @param notification 通知实例
 */
- (void)didReceiveDeviceOrientationDidChangeNotification:(NSNotification *)notification {
    //重新走一遍设置标题的逻辑, 传入当前的viewController
    [self setNewTitle:self.titleLabel.attributedText.string withContainerViewController:self.currentViewController];
}

#pragma mark - PublicMethod

/**
 给titleView设置新的标题, 会自动调整title的宽度, titleLabel的宽度等于导航栏宽度减去返回按钮的宽度, 更多按钮的宽度
 关闭按钮的宽度(如果有), 在减去按钮之间的距离
 
 @param title 标题
 @param viewController titleView所在的viewController
 */
- (void)setNewTitle:(NSString *)title withContainerViewController:(UIViewController *)viewController {
    self.currentViewController = viewController;
    
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
