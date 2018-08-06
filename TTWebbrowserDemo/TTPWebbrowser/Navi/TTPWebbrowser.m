//
//  TTPWebbrowser.m
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/6.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "TTPWebbrowser.h"
#import "TTPWKWebViewController.h"
#import "TTPBaseNavitionViewController.h"

@implementation TTPWebbrowser

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)ttp_gotoUrl:(NSString *)url withMainNavigationController:(UINavigationController *)navigationController{
    TTPWebbrowser *browser = [[TTPWebbrowser alloc]init];
    
    TTPWKWebViewController *ttpWk = [[TTPWKWebViewController alloc]initWithURL:[NSURL URLWithString:url]];
    [navigationController pushViewController:ttpWk animated:YES];
}

@end
