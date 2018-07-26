//
//  TTPWKWebViewController.m
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/6.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "TTPWKWebViewController.h"

#import "UIViewController+NavigationBackActionHandler.h"
#import "TTPWebViewProgressView.h"
#import "TTPReloadView.h"

static NSString* const TTPWKWebViewLoadProgressKey = @"estimatedProgress";

@interface TTPWKWebViewController ()<WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate, BackActionHandlerProtocol>
//关闭浏览器barItem
@property(strong, nonatomic)UIBarButtonItem *closeBarItem;
//导航栏进度条
@property(strong, nonatomic)TTPWebViewProgressView *progressView;
//加载失败的重载视图
@property(strong, nonatomic)TTPReloadView *ttpReloadView;
//保存当前正在加载的Action
@property(strong, nonatomic)WKNavigationAction *currentNavigationAction;
@end

@implementation TTPWKWebViewController

#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpViewController];
    
    //添加webview
    [self.view addSubview:self.ttpWebView];
    //添加进度条
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    [self ttp_loadUrl:[NSURL URLWithString:self.url]];
    //界面布局
    [self adjustLayout];
    //调整关闭按钮状态
    [self updateCloseBarButtonItem];
    
    //添加监听进度事件
    [self.ttpWebView addObserver:self forKeyPath:TTPWKWebViewLoadProgressKey options:NSKeyValueObservingOptionNew||NSKeyValueChangeOldKey context:nil];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)setUpViewController {
    self.navigationItem.title = @"浏览器";
    self.navigationItem.backBarButtonItem.title = @"返回";
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction:)];
    self.navigationItem.rightBarButtonItem = moreItem;
}

#pragma mark - PrivateMethod

- (TTPWebViewProgressView *)progressView {
    if (!_progressView) {
        CGFloat progressBarHeight = 3.0f;
        CGRect naviBarBounds = self.navigationController.navigationBar.bounds;
        _progressView = [[TTPWebViewProgressView alloc]initWithFrame:CGRectMake(0, naviBarBounds.size.height, naviBarBounds.size.width, progressBarHeight)];
        _progressView.progressBarView.backgroundColor = [UIColor colorWithRed:83.f/255 green:215.f/255 blue:105.f/255 alpha:1.0];
    }
    return _progressView;
}

- (UIBarButtonItem *)closeBarItem {
    if (!_closeBarItem) {
        _closeBarItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
    }
    return _closeBarItem;
}

/**
 初始化WebView

 @return WKWebView
 */
- (WKWebView *)ttpWebView {
    if (!_ttpWebView) {
        //UserContent控制器
        WKUserContentController *ttpUsrContentContoller = [[WKUserContentController alloc]init];
        //WebView config
        WKWebViewConfiguration *ttpConfig = [[WKWebViewConfiguration alloc]init];
        ttpConfig.userContentController = ttpUsrContentContoller;
        
        _ttpWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:ttpConfig];
        _ttpWebView.UIDelegate = self;
        _ttpWebView.navigationDelegate = self;
        _ttpWebView.allowsBackForwardNavigationGestures = YES;
    }
    return _ttpWebView;
}

- (TTPReloadView *)ttpReloadView {
    if (!_ttpReloadView) {
        __weak __typeof(self) weakSelf = self;
        _ttpReloadView = [[TTPReloadView alloc]initWithFrame:CGRectZero reloadHandler:^(id object) {
            //重新加载网页
            [weakSelf ttp_reload];
        }];
    }
    return _ttpReloadView;
}

/**
 通过Request方式加载链接

 @param url 链接地址
 */
- (void)ttp_loadUrl:(NSURL *)url {
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url];
    [self.ttpWebView loadRequest:req];
}

/**
 重新加载网页
 */
- (void)ttp_reload {
    //如果网页正在加载中则不进行任何操作
    if (self.ttpWebView.isLoading) {
        return;
    }
    
    //由于webView第一次加载失败时会把URL属性值置空, 因此作此处理
    if (!self.ttpWebView.URL) {
        [self ttp_loadUrl:self.currentNavigationAction.request.URL];
    } else {
        [self.ttpWebView reload];
    }
}

/**
 调整UI布局
 */
- (void)adjustLayout {
    self.ttpWebView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //iPhone X屏幕适配
    id layOutTargetItem = nil;
    if (@available(iOS 11.0, *)) {
        layOutTargetItem = self.view.safeAreaLayoutGuide;
    } else {
        layOutTargetItem = self.view;
    }
    //webView顶部距离safeArea为0
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.ttpWebView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:layOutTargetItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:topConstraint];
    //webView左侧
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.ttpWebView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:leftConstraint];

    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.ttpWebView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.view addConstraint:bottomConstraint];

    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.ttpWebView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.view addConstraint:rightConstraint];
}

#pragma mark - WkWebviewNaviDelegate

/*
 * 载入网页流程第一步 - 是否允许开始下载网页资源
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    TTPLog(@"decidePolicyForNavigationAction");
    TTPLog(@"decidePolicyForNavigationAction: %@", self.ttpWebView.URL);
    self.currentNavigationAction = navigationAction;
    //更新leftBarItems状态
    [self updateCloseBarButtonItem];
    
//    NSURL *url = navigationAction.request.URL;
//    NSString *urlString = (url) ? url.absoluteString : @"";
    
//    // iTunes: App Store link
//    if ([urlString isMatch:RX(@"\\/\\/itunes\\.apple\\.com\\/")]) {
//        [[UIApplication sharedApplication] openURL:url];
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
//    // Protocol/URL-Scheme without http(s)
//    else if (![urlString isMatch:[@"^https?:\\/\\/." toRxIgnoreCase:YES]]) {
//        [[UIApplication sharedApplication] openURL:url];
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
    
    //允许加载网页
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    TTPLog(@"decidePolicyForNavigationResponse");
    //允许加载网页
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/*
 * 载入网页流程第二步 - 网页已经开始下载网页资源回调
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    TTPLog(@"did start load web!");
    TTPLog(@"did start load web!:%@", self.ttpWebView.backForwardList.currentItem.title);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    TTPLog(@"didCommitNavigation");
}

/*
 * 载入网页流程第三步 - 网页已下载完网页资源并加载完毕
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    TTPLog(@"finished load web!");
    TTPLog(@"finished load web!!:%@", self.ttpWebView.backForwardList.currentItem.title);
    TTPLog(@"finished load web!!:%@", self.ttpWebView.backForwardList.backItem.title);
    
    //更新导航按钮状态
    [self updateCloseBarButtonItem];
    //网页加载成功回调
    [self webpageLoadSuccess];
}

/*
 * 载入网页 - 容错处理
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    TTPLog(@"didFailNavigation:%@", error);
    [self webpageLoadFailWithError:error];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    TTPLog(@"didFailProvisionalNavigation:%@", error);
    [self webpageLoadFailWithError:error];
}

/*
 * 载入网页收到挑战应答机制
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    TTPLog(@"didReceiveAuthenticationChallenge");
    //获取网页域名
    NSString *hostStr = webView.URL.host;
    
    //获取挑战所使用方法
    NSString *authenticationMethod = [[challenge protectionSpace]authenticationMethod];
    /*
     * 挑战应答机制 - 需要输入用户权限方可访问资源
     */
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodDefault]
        || [authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic]
        || [authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPDigest]) {
        //构建alert
        NSString *title = @"Authentication Challenge";
        NSString *message = [NSString stringWithFormat:@"%@ 需要用户名和密码", hostStr];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"用户名";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"密码";
            textField.secureTextEntry = YES;
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //回传处理结果
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *userName = ((UITextField *)alert.textFields[0]).text;
            NSString *password = ((UITextField *)alert.textFields[1]).text;
            
            NSURLCredential *credential = [[NSURLCredential alloc]initWithUser:userName password:password persistence:NSURLCredentialPersistenceNone];
            //回传处理结果
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }]];
        
        //弹出输入框
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:^{}];
        });
    }
    /*
     * 挑战应答机制 - 需要验证证书
     */
    else if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        //以系统默认方式处理证书
//        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
        //自行处理收的证书验证
        SecTrustRef secTrustRef = [[challenge protectionSpace] serverTrust];
        if (secTrustRef != NULL) {
            //评估证书是否可以信任
            SecTrustResultType result;
            OSErr error = SecTrustEvaluate(secTrustRef, &result);
            //如果评估过程中发生错误则直接回传拒绝网络访问
            if (error != noErr) {
                completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
                return;
            }
            
            //如果证书为不可信任证书
            if (result == kSecTrustResultRecoverableTrustFailure) {
                /*
                 * 信任不可信证书, 将决定交给用户
                 */
                //构建证书描述信息
                CFArrayRef secTrustProperties = SecTrustCopyProperties(secTrustRef);
                NSArray *arr = CFBridgingRelease(secTrustProperties);
                NSMutableString *errorStr = [NSMutableString string];
                for (int i=0; i<arr.count; i++) {
                    NSDictionary *dic = [arr objectAtIndex:i];
                    if (i != 0) {
                        [errorStr appendString:@" "];
                    }
                    [errorStr appendString:(NSString *)dic[@"value"]];
                }

                //获取证书summary
                SecCertificateRef certRef = SecTrustGetCertificateAtIndex(secTrustRef, 0);
                CFStringRef cfCertSummaryRef = SecCertificateCopySubjectSummary(certRef);
                NSString *certSummary = (NSString *)CFBridgingRelease(cfCertSummaryRef);
                //构建alert
                NSString *title = @"无法验证服务器身份";
                NSString *message = [NSString stringWithFormat:@"域名为%@的身份无法被本App%@验证, 证书来自%@. \n%@", hostStr, @"TTPBrowser", certSummary, errorStr];
                UIAlertController *serverTrustAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                [serverTrustAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //用户取消网页访问, 回调取消网页访问
                    completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
                }]];
                [serverTrustAlert addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //用户继续用无法验证通过的证书访问
                    NSURLCredential *credential = [NSURLCredential credentialForTrust:secTrustRef];
                    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
                }]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:serverTrustAlert animated:YES completion:nil];
                });
                return;
            }
            /*
             * 证书可信任 - 回调
             */
            NSURLCredential *credential = [NSURLCredential credentialForTrust:secTrustRef];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
            return;
        }
        //传过来的证书为空, 直接拒绝网络访问
        completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
    }
    else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    TTPLog(@"didReceiveServerRedirectForProvisionalNavigation");
}

#pragma mark - WKWebViewUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSString *hostStr = webView.URL.host;
    NSString *senderTitle = [NSString stringWithFormat:@"%@ 提示", hostStr];
    //native alert弹框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:senderTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSString *hostStr = webView.URL.host;
    NSString *senderTitle = [NSString stringWithFormat:@"%@ 提示", hostStr];
    //native confirm弹框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:senderTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    NSString *hostStr = webView.URL.host;
    NSString *senderTitle = [NSString stringWithFormat:@"%@ 提示", hostStr];
    //native prompt弹框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:senderTitle message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(nil);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *input = ((UITextField *)alert.textFields.firstObject).text;
        completionHandler(input);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - NavigationActions

/**
 更新关闭按钮状态
 */
- (void)updateCloseBarButtonItem {
    if (self.ttpWebView.canGoBack || self.ttpWebView.backForwardList.backItem) {
        [self.navigationItem setLeftBarButtonItems:@[self.closeBarItem] animated:NO];
    } else {
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    }
}

/**
 关闭按钮Action

 @param btn 关闭按钮
 */
- (void)closeAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 更多操作

 @param item barButtonItem
 */
- (void)moreAction:(UIBarButtonItem *)item {
    
}

/**
 拦截系统返回按钮事件

 @return 是否允许pop
 */
- (BOOL)navigationShouldPopOnBackButton {
    if (self.ttpWebView.canGoBack) {
        [self.ttpWebView goBack];
        return NO;
    }
    return YES;
}

/**
 网页加载失败统一处理一部分逻辑

 @param error 网页加载报错信息
 */
- (void)webpageLoadFailWithError:(NSError *)error {
    self.ttpReloadView.error = error;
    [self.ttpReloadView showInView:self.view];
}

/**
 网页加载成功
 */
- (void)webpageLoadSuccess {
    [self.ttpReloadView dissmiss];
}

#pragma mark - KVO

/**
 KVO - 监听

 @param keyPath 监听路径
 @param object 监听对象
 @param change 变化map
 @param context 上下文
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGFloat newValue = [[change valueForKey:NSKeyValueChangeNewKey] floatValue];

    if ([object isEqual:self.ttpWebView] && [keyPath isEqualToString:TTPWKWebViewLoadProgressKey]) {
        [self.progressView setProgress:newValue animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
