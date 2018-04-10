//
//  SecondViewController.m
//  LSRouterDemo
//
//  Created by ArthurShuai on 2017/3/7.
//  Copyright © 2017年 qusu. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
}

// 页面配置
- (void)config
{
    self.title = @"SecondPage";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    lab.center = self.view.center;
    lab.textColor = [UIColor redColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 2;
    lab.text = _message;
    [self.view addSubview:lab];

    // 发送通讯信息
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(testNotification)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)testNotification
{
    [LSRouter sendInformation:@"FirstPage" tagName:[NSStringFromClass([self class]) stringByAppendingString:@"_test"]];
}

- (void)alertWith:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Surprised!!!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
