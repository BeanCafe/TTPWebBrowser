//
//  ViewController.m
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/6.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ViewController.h"

#import "TTPWebbrowser.h"
#import "TTPReloadView.h"

@interface ViewController ()
@property(strong, nonatomic)TTPReloadView *reloadView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reloadView = [[TTPReloadView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    self.reloadView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.reloadView];

    self.title = @"TTPWebBrowserDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"Refresh" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    btn.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
//    [self.view addConstraint:centerXConstraint];
//
//    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
//    [self.view addConstraint:centerYConstraint];
//
//    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80];
//    [btn addConstraint:widthConstraint];
//
//    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44];
//    [btn addConstraint:heightConstraint];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)refreshAction:(UIButton *)btn {
//    [TTPWebbrowser ttp_gotoUrl:@"https://www.baidu.com" withMainNavigationController:self.navigationController];
//    [TTPWebbrowser ttp_gotoUrl:@"https://www.cnshihui.cn" withMainNavigationController:self.navigationController];

    [TTPWebbrowser ttp_gotoUrl:@"http://localhost:8082/tianmaomofang" withMainNavigationController:self.navigationController];
//    [TTPWebbrowser ttp_gotoUrl:@"http://httpbin.org/digest-auth/auth/user/pass" withMainNavigationController:self.navigationController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
