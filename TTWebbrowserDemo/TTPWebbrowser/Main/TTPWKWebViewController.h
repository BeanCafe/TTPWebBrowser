//
//  TTPWKWebViewController.h
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/6.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "TTPBaseViewController.h"

#import <WebKit/WebKit.h>

@interface TTPWKWebViewController : TTPBaseViewController
@property (copy, nonatomic)NSString *url;
@property (strong, nonatomic)WKWebView *ttpWebView;
@end
