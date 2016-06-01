//
//  LVMAlertAction.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/30.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "LVMAlertAction.h"

@implementation LVMAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(LVMAlertActionStyle)style handler:(LVMAlertActionHandler)handler {
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(LVMAlertActionStyle)style handler:(LVMAlertActionHandler)handler {
    self = [super init];
    if (self) {
        _style = style;
        _title = [title copy];
        _actionHandler = [handler copy];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LVMAlertAction *action = [LVMAlertAction actionWithTitle:self.title style:self.style handler:self.actionHandler];
    return action;
}

@end
