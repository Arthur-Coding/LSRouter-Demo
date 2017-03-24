//
//  UIViewController+viewDidLoad.m
//  LSRouterDemo
//
//  Created by ArthurShuai on 2017/3/6.
//  Copyright © 2017年 ArthurShuai. All rights reserved.
//

#import <objc/runtime.h>

#import "UIViewController+viewDidLoad.h"
#import "LSRouter.h"

typedef void (* VIMP)(id, SEL, ...);

@implementation UIViewController (viewDidLoad)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
        VIMP viewDidLoad_VIMP = (VIMP)method_getImplementation(viewDidLoad);
        method_setImplementation(viewDidLoad, imp_implementationWithBlock(^ (id target , SEL action){
            viewDidLoad_VIMP(target , @selector(viewDidLoad));
            [LSRouter cacheModule:self];
        }));
    });
}

@end
