//
//  TTPWebViewController.m
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/6.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "TTPWebViewController.h"

@interface TTPWebViewController ()
@property(strong, nonatomic)UIWebView *ttpWebView;
@end

@implementation TTPWebViewController

#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Init

- (UIWebView *)ttpWebView {
    UIWebView *a = [UIWebView new];
    return a;
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
