//
//  UIViewController+NavigationBackActionHandler.h
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/11.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackActionHandlerProtocol <NSObject>
@optional
- (BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (NavigationBackActionHandler)<BackActionHandlerProtocol>
@end
