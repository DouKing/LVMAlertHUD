//
//  LVMAlertController+Convenient.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/6/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "LVMAlertController.h"

@interface LVMAlertController (Convenient)

/**
 *  `LVMAlertController`的便利方法，`cancelButtonTitle`会放在`otherButtonTitles`之后，回调的index也在最后
 *
 *  @param title             标题
 *  @param message           信息
 *  @param preferredStyle    样式
 *  @param actionHandler     回调
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitles 其他按钮标题
 *  @see   `LVMAlertController`
 *
 *  @return                  instancetype
 */
+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                preferredStyle:(LVMAlertControllerStyle)preferredStyle
                 actionHandler:(void (^)(NSInteger index))actionHandler
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSString *)otherButtonTitles, ... ;

@end