//
//  LSRouter.m
//  LSRouterDemo
//
//  Created by ArthurShuai on 2017/3/6.
//  Copyright © 2017年 ArthurShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LSRouter.h"
#import "UIViewController+ViewDidDisappear.h"
#import "UIView+RemoveFromSupperView.h"

@interface LSRouter ()

/**
 * 组件缓存字典，格式：{“moduleName1”:module,"moduleName2":module}
 */
@property (nonatomic, strong) NSMutableDictionary *modules;

/**
 组件间通讯缓存字典， 格式：{“通讯标记名1”:接收方处理回调1,“通讯标记名2”:接收方处理回调2}
 */
@property (nonatomic, strong) NSMutableDictionary *receiveBlks;

@end

@implementation LSRouter

+ (instancetype)sharedInstance
{
    static LSRouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[LSRouter alloc] init];
        router.modules = [NSMutableDictionary dictionary];
        router.receiveBlks = [NSMutableDictionary dictionary];
    });
    return router;
}

+ (void)performActionWithUrl:(NSURL *)url completion:(LSRouterHandler)completion
{
    // 解析url中传递的参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *param in [url.query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:elts.lastObject forKey:elts.firstObject];
    }

    // 考虑到安全性，防止黑客通过远程方式调用本地模块
    // 当前要求本地组件的actionName必须包含前缀"action_",所以远程调用的action就不能包含action_前缀
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"action_"]) {
        return;
    }

    // 如果需要拓展更复杂的url，可以在这个方法调用之前加入完整的路由逻辑
    [self openModule:url.host action:[NSString stringWithFormat:@"action_%@:", actionName] params:params perform:^(id module) {
        if (completion) {
            completion(module);
        }
    }];
}
+ (void)openModule:(NSString *)objectClass action:(NSString *)actionName params:(id)params perform:(LSRouterHandler)handler
{
    SEL action = NSSelectorFromString(actionName);
    NSObject *object = [[self sharedInstance] modules][objectClass];
    Class module = nil;
    if (object == nil) {
        module = NSClassFromString(objectClass);
        if (module == nil) { // 未发现组件
            [self alertWithMessage:@"未发现组件"];
            return;
        }else {
            object = [[module alloc] init];
            [[self sharedInstance] modules][objectClass] = object;
        }
    }
    if (handler) {
        handler(object);
    }

    if (action != nil) {
        if ([object respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [object performSelector:action withObject:params];
#pragma clang diagnostic pop
            if ([object isKindOfClass:[UIViewController class]] || [object isKindOfClass:[UIView class]]) {
                [module release:^{
                    [LSRouter releaseModule:objectClass];
                }];
            }
        }else {
            [self alertWithMessage:@"未发现组件Action"];
            [self releaseModule:objectClass];
        }
    }
}

+ (BOOL)cacheModule:(id)object
{
    if (![[[self sharedInstance] modules].allKeys containsObject:NSStringFromClass([object class])]) {
        [[[self sharedInstance] modules] setObject:object forKey:NSStringFromClass([object class])];
        return YES;
    }else {
        return NO;
    }
}

/**
 释放组件
 * 实际使用时，开发人员不必调用，架构设计中已将所有组件动态释放
 * 在LSRouter.h中不再声明

 @param objectClass 组件类名
 @return YES or NO
 */
+ (BOOL)releaseModule:(NSString *)objectClass
{
    if ([[[self sharedInstance] modules].allKeys containsObject:objectClass]) {
        [[[self sharedInstance] modules] removeObjectForKey:objectClass];
        return YES;
    }else {
        return NO;
    }
}

+ (void)alertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)sendInformation:(id)information tagName:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:information != nil ? @{@"info":information} : nil];
}

+ (void)receiveInformationWithTagName:(NSString *)name result:(LSInformationHandler)resultHandler
{
    [[NSNotificationCenter defaultCenter] addObserver:[self sharedInstance] selector:@selector(receiveInformationFrom:) name:name object:nil];

    if (resultHandler) {
        [[self sharedInstance] receiveBlks][name] = resultHandler;
    }
}
- (void)receiveInformationFrom:(NSNotification *)noti
{
    NSString *name = noti.name;
    id information = noti.userInfo[@"info"];

    LSInformationHandler receiveBlk = _receiveBlks[name];
    if (receiveBlk) {
        receiveBlk(information);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
