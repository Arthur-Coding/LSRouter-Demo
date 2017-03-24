//
//  UIViewController+ViewDidDisappear.m
//  LSRouterDemo
//
//  Created by ArthurShuai on 2017/3/8.
//  Copyright © 2017年 ArthurShuai. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+ViewDidDisappear.h"

typedef void (* VIMP)(id, SEL, ...);

@implementation UIViewController (ViewDidDisappear)

+ (void)release:(void (^)(void))handler
{
    Method viewDidDisappear = class_getInstanceMethod(self, @selector(viewDidDisappear:));
    VIMP viewDidDisappear_VIMP = (VIMP)method_getImplementation(viewDidDisappear);
    method_setImplementation(viewDidDisappear, imp_implementationWithBlock(^ (id target , SEL action) {
        viewDidDisappear_VIMP(target, @selector(viewDidDisappear:));
        if (handler) {
            handler();
        }
    }));
}

@end
