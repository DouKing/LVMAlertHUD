//
//
// LVMAlertController+DSL.m
// Secoo-iPhone
//
// Created by WuYikai on 2018/1/12.
// Copyright © 2018年 secoo. All rights reserved.
//
	

#import "LVMAlertController+DSL.h"
#import "_LVMAlertController+Private.h"

@implementation LVMAlertController (DSL)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (instancetype)alert {
  return [self alertControllerWithTitle:nil message:nil preferredStyle:LVMAlertControllerStyleAlert];
}

+ (instancetype)actionSheet {
  return [self alertControllerWithTitle:nil message:nil preferredStyle:LVMAlertControllerStyleActionSheet];
}

- (LVMAlertController *(^)(LVMAlertControllerStyle))useStyle {
  return ^LVMAlertController *(LVMAlertControllerStyle preferredStyle) {
    self.preferredStyle = preferredStyle;
    return self;
  };
}

- (LVMAlertController *(^)(NSString *))setupTitle {
  return ^LVMAlertController *(NSString *title) {
    self.alertTitle = title;
    return self;
  };
}

- (LVMAlertController *(^)(NSString *))setupMessage {
  return ^LVMAlertController *(NSString *message) {
    self.alertMessage = message;
    return self;
  };
}

- (LVMAlertController *(^)(LVMAlertAction *))addAction {
  return ^LVMAlertController *(LVMAlertAction *action) {
    [self addAction:action];
    return self;
  };
}

- (LVMAlertController *(^)(void(^)()))show {
  return ^LVMAlertController *(void(^completion)()) {
    [self showWithCompletion:completion];
    return self;
  };
}

- (LVMAlertController *(^)(UIViewController *, void(^)()))showOn {
  return ^LVMAlertController *(UIViewController *presentingVC, void(^completion)()) {
    [self presentOn:presentingVC withCompletion:completion];
    return self;
  };
}

- (LVMAlertController *(^)(NSString *, ...))addActionsWithTitles {
  return ^LVMAlertController *(NSString *actionTitles, ...) {
    va_list varList;
    id arg;
    NSMutableArray<NSString *> *argsArray = [NSMutableArray array];
    if(actionTitles) {
      [argsArray addObject:actionTitles];
      va_start(varList, actionTitles);
      while((arg = va_arg(varList, id))){
        [argsArray addObject:arg];
      }
      va_end(varList);
    }

    for (NSInteger i = 0; i < argsArray.count; ++i) {
      NSString *actionTitle = argsArray[i];
      NSInteger index = self.actions.count;
      LVMAlertActionStyle style = (LVMAlertControllerStyleAlert == self.preferredStyle) ? LVMAlertActionStyleDefault : LVMAlertActionStyleMessage;
      LVMAlertAction *action = [LVMAlertAction actionWithTitle:actionTitle style:style handler:^(LVMAlertAction * _Nonnull action) {
        if (self.actionHandler) {
          self.actionHandler(index, action);
        }
      }];
      [self addAction:action];
    }

    return self;
  };
}

- (LVMAlertController *(^)(NSString *))addCancelActionWithTitle {
  return ^LVMAlertController *(NSString *cancelTitle) {
    NSInteger index = self.actions.count;
    LVMAlertAction *action = [LVMAlertAction actionWithTitle:cancelTitle style:LVMAlertActionStyleCancel handler:^(LVMAlertAction * _Nonnull action) {
      if (self.actionHandler) {
        self.actionHandler(index, action);
      }
    }];
    [self addAction:action];
    return self;
  };
}

- (LVMAlertController *(^)(void(^)(NSInteger, LVMAlertAction *)))actionsHandler {
  return ^LVMAlertController *(void(^handler)(NSInteger index, LVMAlertAction *action)) {
    self.actionHandler = handler;
    return self;
  };
}

#pragma clang diagnostic pop

@end