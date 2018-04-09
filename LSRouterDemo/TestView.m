//
//  TestView.m
//  LSRouterDemo
//
//  Created by ArthurShuai on 2017/3/8.
//  Copyright © 2017年 qusu. All rights reserved.
//

#import "TestView.h"

@interface TestView ()

@property (nonatomic, strong) UILabel *lab;

@end

@implementation TestView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor orangeColor];
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        _lab.center = self.center;
        _lab.textColor = [UIColor redColor];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.numberOfLines = 2;
        [self addSubview:_lab];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(50, 50, 60, 40);
        [btn setTitle:@"Back" forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)backAction
{
    [self removeFromSuperview];
}
- (void)changeShowText:(NSString *)text
{
    _lab.text = text;
}

@end
