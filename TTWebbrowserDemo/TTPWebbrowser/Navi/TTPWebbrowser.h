//
//  TTPWebbrowser.h
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/6.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTPWKWebViewController.h"

@interface TTPWebbrowser : NSObject

@property (copy, nonatomic)NSString *url;

+ (void)ttp_gotoUrl:(NSString *)url withMainNavigationController:(UINavigationController *)navigationController;
@end
