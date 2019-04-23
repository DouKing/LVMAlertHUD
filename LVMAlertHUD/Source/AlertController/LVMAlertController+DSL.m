//
//
// LVMAlertController+DSL.m
// Secoo-iPhone
//
// Created by WuYikai on 2018/1/12.
// Copyright © 2018年 douking. All rights reserved.
//
	

#import "LVMAlertController+DSL.h"
#import "_LVMAlertController+Private.h"

@implementation LVMAlertController (DSL)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (instancetype)alert {
  return [self alertControllerWithPreferredStyle:LVMAlertControllerStyleAlert];
}

+ (instancetype)actionSheet {
  return [self alertControllerWithPreferredStyle:LVMAlertControllerStyleActionSheet];
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
    return self.setupAttributedTitle(LVMAlertTitleAttributedStringFor(title));
  };
}

- (LVMAlertController * _Nonnull (^)(NSAttributedString * _Nonnull))setupAttributedTitle {
  return ^LVMAlertController *(NSAttributedString *attributedTitle) {
    self.attributedAlertTitle = attributedTitle;
    return self;
  };
}

- (LVMAlertController *(^)(NSString *))setupMessage {
  return ^LVMAlertController *(NSString *message) {
    self.alertMessage = message;
    return self.setupattributedMessage(LVMAlertMessageAttributedStringFor(message));
  };
}

- (LVMAlertController * _Nonnull (^)(NSAttributedString * _Nonnull))setupattributedMessage {
  return ^LVMAlertController *(NSAttributedString *attributedMessage) {
    self.attributedAlertMessage = attributedMessage;
    return self;
  };
}

- (LVMAlertController * _Nonnull (^)(UIImage * _Nonnull))setupImage {
    return ^LVMAlertController *(UIImage *image) {
        self.alertImage = image;
        return self;
    };
}

- (LVMAlertController * _Nonnull (^)(UIViewController * _Nonnull))setupContentViewController {
    return ^LVMAlertController *(UIViewController *contentVC) {
        self.contentViewController = contentVC;
        return self;
    };
}

- (LVMAlertController * _Nonnull (^)(void (^ _Nullable)(UITextField * _Nonnull)))addTextFieldWithCompletion {
    return ^LVMAlertController *(void (^configure)(UITextField *textField)) {
        [self addTextFieldWithConfigurationHandler:configure];
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
    self.showOn(nil, YES, completion);
    return self;
  };
}

- (LVMAlertController *(^)(UIViewController *, BOOL, void(^)()))showOn {
  return ^LVMAlertController *(UIViewController *presentingVC, BOOL animated, void(^completion)()) {
    if (!self.presentingViewController) {
      UIViewController *topVC = presentingVC ?: [self _stackTopViewController];
      [topVC presentViewController:self animated:animated completion:completion];
    }
    return self;
  };
}

- (LVMAlertController * _Nonnull (^)(NSArray<NSString *> * _Nonnull))addActionsWithTitleArray {
  return ^LVMAlertController *(NSArray<NSString *> *actionTitleArray) {
    NSArray<NSString *> *argsArray = [actionTitleArray copy];
    for (NSInteger i = 0; i < argsArray.count; ++i) {
      NSString *actionTitle = argsArray[i];
      NSInteger index = self.userActions.count;
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
    return self.addActionsWithTitleArray(argsArray);
  };
}

- (LVMAlertController *(^)(NSString *))addCancelActionWithTitle {
  return ^LVMAlertController *(NSString *cancelTitle) {
    LVMAlertAction *action = [LVMAlertAction actionWithTitle:cancelTitle style:LVMAlertActionStyleCancel handler:^(LVMAlertAction * _Nonnull action) {
      if (self.actionHandler) {
        self.actionHandler(self.userActions.count, action);
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
