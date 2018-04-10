//
//  LSRouter+TestView.m
//  LSRouterDemo
//
//  Created by ArthurShuai on 2017/3/8.
//  Copyright © 2017年 qusu. All rights reserved.
//

#import "LSRouter+TestView.h"

static NSString * const module_TV = @"TestView";
static NSString * const module_TV_action = @"changeShowText:";

@implementation LSRouter (TestView)

+ (void)action_TV_showText:(LSRouterHandler)handler text:(NSString *)text
{
    [self openModule:module_TV action:module_TV_action params:text perform:handler];
}

@end
