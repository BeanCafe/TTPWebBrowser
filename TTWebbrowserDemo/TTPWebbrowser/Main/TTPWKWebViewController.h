//
//  TTPWKWebViewController.h
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/6.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "TTPBaseViewController.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000

#import <WebKit/WebKit.h>

@interface TTPWKWebViewController : TTPBaseViewController
@property (copy, nonatomic)NSString *url;
@property (strong, nonatomic)WKWebView *ttpWebView;

+ (void)clearWebCacheCompletion:(dispatch_block_t)completion;

@end

#endif
