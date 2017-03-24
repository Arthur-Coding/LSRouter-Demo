//
//  UIView+RemoveFromSupperView.h
//  LSRouterDemo
//
//  Created by ArthurShuai on 2017/3/8.
//  Copyright © 2017年 ArthurShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RemoveFromSupperView)

+ (void)release:(void(^)(void))handler;

@end
