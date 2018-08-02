//
//  TTPNaviTitleView.h
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/31.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPNaviTitleView : UIView

/**
 给titleView设置新的标题, 会自动调整title的宽度, titleLabel的宽度等于导航栏宽度减去返回按钮的宽度, 更多按钮的宽度
 关闭按钮的宽度(如果有), 在减去按钮之间的距离

 @param title 标题
 @param viewController titleView所在的viewController
 */
- (void)setNewTitle:(NSString *)title withContainerViewController:(UIViewController *)viewController;

@end
