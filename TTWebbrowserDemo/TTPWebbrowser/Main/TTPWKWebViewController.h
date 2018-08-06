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

@interface TTPWKWebViewController : UIViewController
@property (copy, nonatomic)NSURL *URL;
@property (strong, nonatomic)WKWebView *ttpWebView;
@property(assign, nonatomic) NSTimeInterval timeoutInternal;

@property(assign, nonatomic) NSURLRequestCachePolicy cachePolicy;

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithRequest:(NSURLRequest *)request;

- (instancetype)initWithURL:(NSURL *)URL configuration:(WKWebViewConfiguration *)configuration;
- (instancetype)initWithRequest:(NSURLRequest *)request configuration:(WKWebViewConfiguration *)configuration;
- (instancetype)initWithHTMLString:(NSString *)HTMLString baseURL:(NSURL * _Nullable)baseURL;
- (void)loadURL:(NSURL*)URL;
- (void)loadURLRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL;

+ (void)clearWebCacheCompletion:(dispatch_block_t)completion;

@end

#endif
