//
//
// LVMAlertController+DSL.h
// Secoo-iPhone
//
// Created by WuYikai on 2018/1/12.
// Copyright © 2018年 secoo. All rights reserved.
//
	

#import "LVMAlertController.h"

NS_ASSUME_NONNULL_BEGIN


/**
 DSL for `LVMAlertController`, you can use it like this:

 LVMAlertController.alert.useStyle(LVMAlertControllerStyleAlert)
                   .setupTitle(@"title")
                   .setupMessage(@"message")
                   .addActionsWithTitles(@"ok", @"later", @"know", nil)
                   .addCancelActionWithTitle(@"cancel")
                   .actionsHandler(^(NSInteger index, LVMAlertAction *action) {
                      NSLog(@"click %ld, %@", index, action.title);
                   })
 .show(^{
    NSLog(@"show");
 });

 */
@interface LVMAlertController ()

+ (instancetype)alert;
+ (instancetype)actionSheet;
@property (nonatomic, copy, readonly) LVMAlertController *(^useStyle)(LVMAlertControllerStyle preferredStyle);
@property (nonatomic, copy, readonly) LVMAlertController *(^setupTitle)(NSString * _Nullable title);
@property (nonatomic, copy, readonly) LVMAlertController *(^setupAttributedTitle)(NSAttributedString * _Nullable attributedTitle);
@property (nonatomic, copy, readonly) LVMAlertController *(^setupMessage)(NSString * _Nullable message);
@property (nonatomic, copy, readonly) LVMAlertController *(^setupattributedMessage)(NSAttributedString * _Nullable attributedMessage);
@property (nonatomic, copy, readonly) LVMAlertController *(^setupImage)(UIImage * _Nullable image);
@property (nonatomic, copy, readonly) LVMAlertController *(^setupContentViewController)(UIViewController * _Nullable contentVC);
@property (nonatomic, copy, readonly) LVMAlertController *(^addTextFieldWithCompletion)(void (^ __nullable)(UITextField *textField));
@property (nonatomic, copy, readonly) LVMAlertController *(^addAction)(LVMAlertAction * _Nullable action);
@property (nonatomic, copy, readonly) LVMAlertController *(^show)(void (^ __nullable completion)());
@property (nonatomic, copy, readonly) LVMAlertController *(^showOn)(UIViewController * _Nullable presentingVC,
                                                                    BOOL animated,
                                                                    void (^ __nullable completion)());

@property (nonatomic, copy, readonly) LVMAlertController *(^addActionsWithTitles)(NSString *actionTitles, ...);
@property (nonatomic, copy, readonly) LVMAlertController *(^addCancelActionWithTitle)(NSString *cancelTitle);
@property (nonatomic, copy, readonly) LVMAlertController *(^actionsHandler)(void(^)(NSInteger index, LVMAlertAction *action));

@end


NS_ASSUME_NONNULL_END
