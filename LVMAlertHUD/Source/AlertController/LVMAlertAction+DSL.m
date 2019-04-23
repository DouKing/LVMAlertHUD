//
//
// LVMAlertAction+DSL.m
// Secoo-iPhone
//
// Created by WuYikai on 2018/1/12.
// Copyright © 2018年 douking. All rights reserved.
//
	

#import "LVMAlertAction+DSL.h"
#import "_LVMAlertAction+Private.h"

@implementation LVMAlertAction (DSL)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (instancetype)action {
  return [self actionWithTitle:nil style:LVMAlertActionStyleDefault handler:nil];
}

- (LVMAlertAction *(^)(LVMAlertActionStyle))useStyle {
  return ^LVMAlertAction *(LVMAlertActionStyle style) {
    self.style = style;
    return self;
  };
}

- (LVMAlertAction *(^)(NSString *))setupTitle {
  return ^LVMAlertAction *(NSString *title) {
    self.title = title;
    return self;
  };
}

- (LVMAlertAction *(^)(BOOL))setupEnable {
  return ^LVMAlertAction *(BOOL enabled) {
    self.enabled = enabled;
    return self;
  };
}

- (LVMAlertAction *(^)(LVMAlertActionHandler))setupHandler {
  return ^LVMAlertAction *(LVMAlertActionHandler handler) {
    self.actionHandler = handler;
    return self;
  };
}

#pragma clang diagnostic pop

@end
