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
    
    LVMAlertController *alertController = [LVMAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    for (NSInteger i = 0; i < argsArray.count; ++i) {
        NSString *actionTitle = argsArray[i];
        LVMAlertAction *action = [LVMAlertAction actionWithTitle:actionTitle style:LVMAlertActionStyleDefault handler:^(LVMAlertAction * _Nonnull action) {
            if (actionHandler) {
                actionHandler(i);
            }
        }];
        [alertController addAction:action];
    }
    
    if (cancelButtonTitle) {
        NSInteger index = argsArray.count;
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
