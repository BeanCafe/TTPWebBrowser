//
//  TTPReloadView.h
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/20.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TTPReloadBlock)(id object);

@interface TTPReloadView : UIView

@property (strong, nonatomic)NSError *error;

/**
 初始化

 @param frame frame
 @param reloadHanlder 点击本视图回调事件处理
 @return 对象实例
 */
- (instancetype)initWithFrame:(CGRect)frame reloadHandler:(TTPReloadBlock)reloadHanlder;

- (void)showInView:(UIView *)view;

- (void)dissmiss;
@end
