//
//  LSRouter+SecondViewController.m
//  LSRouterDemo
//
//  Created by ArthurShuai on 2017/3/7.
//  Copyright © 2017年 qusu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LSRouter+SecondViewController.h"

static NSString * const module_SC = @"SecondViewController";
static NSString * const module_SC_action1 = @"setMessage:";
static NSString * const module_SC_action2 = @"alertWith:";

@implementation LSRouter (SecondViewController)

+ (void)action_SC_showText:(LSRouterHandler)handler param:(NSString *)param
{
    [self openModule:module_SC action:module_SC_action1 params:param perform:^(id module) {
        if (handler) {
            handler(module);
        }
    }];
}
+ (void)action_SC_showAlert:(LSRouterHandler)handler param:(NSString *)param
{
    [self openModule:module_SC action:module_SC_action2 params:param perform:^(id module) {
        if (handler) {
            handler(module);
        }
    }];
}

+ (void)action_SC_receive:(LSInformationHandler)resultHandler
{
    [LSRouter receiveInformationWithTagName:@"SecondViewController_test" result:resultHandler];
}

@end
