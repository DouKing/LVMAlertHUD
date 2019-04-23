//
//  LVMAlertAction.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/30.
//  Copyright © 2016年 douking. All rights reserved.
//

#import "LVMAlertAction.h"
#import "_LVMAlertAction+Private.h"
#import "LVMAlertHUDConfigure.h"
#import "LVMAlertCell.h"
@import UIKit;

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
        _enabled = YES;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LVMAlertAction *action = [LVMAlertAction actionWithTitle:self.title style:self.style handler:self.actionHandler];
    return action;
}

- (void)setEnabled:(BOOL)enabled {
    if (_enabled == enabled) { return; }
    [self willChangeValueForKey:@"enabled"];
    _enabled = enabled;
    self.associatedButton.enabled = enabled;
    [self.associatedButton setTitleColor:LVMAlertActionColorWithAction(self) forState:UIControlStateNormal];
    [self.associatedCell _changeTextColorWithAlertAction:self];
    [self didChangeValueForKey:@"enabled"];
}

@end
