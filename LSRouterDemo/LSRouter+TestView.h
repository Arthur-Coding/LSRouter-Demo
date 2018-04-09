//
//  LSRouter+TestView.h
//  LSRouterDemo
//
//  Created by ArthurShuai on 2017/3/8.
//  Copyright © 2017年 qusu. All rights reserved.
//

/*
 * 1.此类别就是模块对外的声明，其他模块、APP通过LSRouter调用声明的接口
 * 2.模块对外可调用接口，要求必须包含“action_”前缀
 * 3.向LSRouter声明模块名与action时，若action需要传入参数，action中必须包含“:”,如“show:”
 * 4.action名命名，建议按照“action_模块名简写_name”的格式，防止在LSRouter所有类别中造成命名冲突
 * 5.Demo中，LSRouter模块类别.m文件内，是将模块名与模块内方法名进行了字符串常量定义，建议在前面加上static，让其作用域仅限于当前类别文件，避免LSRouter所有类别中有可能引起的定义冲突
 *
 */

#import <LSRouter/LSRouter.h>

@interface LSRouter (TestView)

+ (void)action_TV_showText:(LSRouterHandler)handler text:(NSString *)text;

@end
