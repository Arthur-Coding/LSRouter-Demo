//
//  MainViewController.m
//  LSRouterDemo
//
//  Created by ArthurShuai on 2017/3/2.
//  Copyright © 2017年 qusu. All rights reserved.
//

#import <TimeCategory/LSRouter+TimeCategory.h>

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self config];
}

// 页面配置
- (void)config
{
    self.title = @"主页";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"视图测试" style:UIBarButtonItemStyleDone target:self action:@selector(testViewAction:)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"控制器测试1" style:UIBarButtonItemStyleDone target:self action:@selector(nextPageAction:)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"控制器测试2" style:UIBarButtonItemStyleDone target:self action:@selector(nextPageAction2:)];
    self.navigationItem.rightBarButtonItems = @[item1,item2];

    // 接收通讯信息
    WeakSelf
    [LSRouter action_SC_receive:^(id information) {
        weakSelf.title = information;
    }];

    // 工具组件-TimeCategory测试
    NSLog(@"%@",[LSRouter time_datestrFromDate:[NSDate date] withDateFormat:@"yyyy-MM-dd HH:mm:ss"]);
}

- (void)nextPageAction:(UIBarButtonItem *)sender {
    WeakSelf
    [LSRouter action_SC_showText:^(id module) {
        if ([module isKindOfClass:[UIViewController class]]) {
            [weakSelf.navigationController pushViewController:module animated:YES];
        }
    } param:@"successful!"];
}
- (void)nextPageAction2:(UIBarButtonItem *)sender {
    WeakSelf
    [LSRouter action_SC_showAlert:^(id module) {
        if ([module isKindOfClass:[UIViewController class]]) {
            [weakSelf.navigationController pushViewController:module animated:YES];
        }
    } param:@"successful again!"];
}
- (void)testViewAction:(UIBarButtonItem *)sender {
    WeakSelf
    [LSRouter action_TV_showText:^(id module) {
        if ([module isKindOfClass:[UIView class]]) {
            [weakSelf.navigationController.view addSubview:module];
        }
    } text:@"I am a view!"];
}

@end
