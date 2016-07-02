//
//  LVMAlertController+Convenient.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/6/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "LVMAlertController+Convenient.h"

@implementation LVMAlertController (Convenient)

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(LVMAlertControllerStyle)preferredStyle actionHandler:(void (^)(NSInteger))actionHandler cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    va_list varList;
    id arg;
    NSMutableArray<NSString *> *argsArray = [NSMutableArray array];
    if(otherButtonTitles) {
        [argsArray addObject:otherButtonTitles];
        va_start(varList, otherButtonTitles);
        while((arg = va_arg(varList, id))){
            [argsArray addObject:arg];
        }
        va_end(varList);
    }
    
    LVMAlertController *alertController = [LVMAlertController alertControllerWithTitle:title message:message image:nil preferredStyle:preferredStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:argsArray actionHandler:actionHandler];
    return alertController;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image preferredStyle:(LVMAlertControllerStyle)preferredStyle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles actionHandler:(void (^)(NSInteger))actionHandler {
    
    LVMAlertController *alertController = [LVMAlertController alertControllerWithTitle:title message:message image:image preferredStyle:preferredStyle];
    for (NSInteger i = 0; i < otherButtonTitles.count; ++i) {
        NSString *actionTitle = otherButtonTitles[i];
        LVMAlertActionStyle style = (LVMAlertControllerStyleAlert == preferredStyle) ? LVMAlertActionStyleDefault : LVMAlertActionStyleDestructive;
        LVMAlertAction *action = [LVMAlertAction actionWithTitle:actionTitle style:style handler:^(LVMAlertAction * _Nonnull action) {
            if (actionHandler) {
                actionHandler(i);
            }
        }];
        [alertController addAction:action];
    }
    
    if (cancelButtonTitle) {
        NSInteger index = otherButtonTitles.count;
        LVMAlertAction *action = [LVMAlertAction actionWithTitle:cancelButtonTitle style:LVMAlertActionStyleCancel handler:^(LVMAlertAction * _Nonnull action) {
            if (actionHandler) {
                actionHandler(index);
            }
        }];
        [alertController addAction:action];
    }
    
    return alertController;
}

@end
