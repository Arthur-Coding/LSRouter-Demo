//
//  UIView+RemoveFromSupperView.m
//  LSRouterDemo
//
//  Created by ArthurShuai on 2017/3/8.
//  Copyright © 2017年 ArthurShuai. All rights reserved.
//
#import <objc/runtime.h>
#import "UIView+RemoveFromSupperView.h"

typedef void (* VIMP)(id, SEL, ...);

@implementation UIView (RemoveFromSupperView)

+ (void)release:(void (^)(void))handler
{
    Method removeFromSuperview = class_getInstanceMethod(self, @selector(removeFromSuperview));
    VIMP removeFromSuperview_VIMP = (VIMP)method_getImplementation(removeFromSuperview);
    method_setImplementation(removeFromSuperview, imp_implementationWithBlock(^ (id target , SEL action) {
        removeFromSuperview_VIMP(target, @selector(removeFromSuperview));
        if (handler) {
            handler();
        }
    }));
}

@end
