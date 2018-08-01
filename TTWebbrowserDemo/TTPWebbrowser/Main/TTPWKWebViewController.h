//
//  TTPWKWebViewController.h
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/6.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "TTPBaseViewController.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000

//本宏定义主要用于适配iOS 11以下返回标题按钮在导航栏主标题过长时会消失的问题
#ifndef TTPCurrentDeviceSystemVersion
#define TTPCurrentDeviceSystemVersion         [[UIDevice currentDevice]systemVersion]
#endif

#ifndef TTPNeedCustomNavigationTitle
#define TTPNeedCustomNavigationTitle         [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 11, .minorVersion = 0, .patchVersion = 0}]
#endif

#import <WebKit/WebKit.h>

@interface TTPWKWebViewController : TTPBaseViewController
@property (copy, nonatomic)NSString *url;
@property (strong, nonatomic)WKWebView *ttpWebView;
@end

#endif
