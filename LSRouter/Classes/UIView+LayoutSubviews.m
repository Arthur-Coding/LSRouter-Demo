//
//  UIView+LayoutSubviews.m
//  LSRouterDemo
//
//  Created by ArthurShuai on 2017/3/8.
//  Copyright © 2017年 ArthurShuai. All rights reserved.
//
#import <objc/runtime.h>

#import "UIView+LayoutSubviews.h"
#import "LSRouter.h"

typedef void (* VIMP)(id, SEL, ...);

@implementation UIView (LayoutSubviews)

+ (void)load
{
    Method layoutSubviews = class_getInstanceMethod(self, @selector(layoutSubviews));
    VIMP layoutSubviews_VIMP = (VIMP)method_getImplementation(layoutSubviews);
    method_setImplementation(layoutSubviews, imp_implementationWithBlock(^ (id target , SEL action) {
        layoutSubviews_VIMP(target, @selector(layoutSubviews));
        [LSRouter cacheModule:self];
    }));
}

@end
