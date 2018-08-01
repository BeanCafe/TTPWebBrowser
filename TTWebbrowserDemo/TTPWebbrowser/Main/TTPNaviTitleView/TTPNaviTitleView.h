//
//  TTPNaviTitleView.h
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/31.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPNaviTitleView : UIView
@property (strong, nonatomic)UILabel *titleLabel;

- (void)setNewTitle:(NSString *)title withContainerViewController:(UIViewController *)viewController;
@end
