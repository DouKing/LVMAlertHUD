//
//  LVMAlertController.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/30.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVMAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LVMAlertControllerStyle) {
    LVMAlertControllerStyleActionSheet = 0,
    LVMAlertControllerStyleAlert
};

@interface LVMAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(LVMAlertControllerStyle)preferredStyle;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                                   image:(nullable UIImage *)image
                          preferredStyle:(LVMAlertControllerStyle)preferredStyle;

- (void)addAction:(LVMAlertAction *)action;
@property (nonatomic, readonly) NSArray<LVMAlertAction *> *actions;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nullable, nonatomic, copy, readonly) NSString *alertTitle;
@property (nullable, nonatomic, copy, readonly) NSString *alertMessage;
@property (nullable, nonatomic, copy, readonly) UIImage *alertImage;
@property (nonatomic, readonly) LVMAlertControllerStyle preferredStyle;

/// if presenting vc is nil, use the top vc
- (void)presentOn:(nullable UIViewController *)presentingVC withCompletion:(void (^ __nullable)())completion;
- (void)showWithCompletion:(void (^ __nullable)())completion;
- (void)dismissWithCompletion:(void (^ __nullable)())completion;

@end


NS_ASSUME_NONNULL_END
