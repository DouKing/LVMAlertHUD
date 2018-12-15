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

+ (instancetype)alertControllerWithPreferredStyle:(LVMAlertControllerStyle)preferredStyle;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(LVMAlertControllerStyle)preferredStyle;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                                   image:(nullable UIImage *)image
                          preferredStyle:(LVMAlertControllerStyle)preferredStyle;

- (void)addAction:(LVMAlertAction *)action;
@property (nonatomic, readonly) NSArray<LVMAlertAction *> *actions;

@property (nullable, nonatomic, strong) UIViewController *contentViewController;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nullable, nonatomic, copy) NSAttributedString *attributedAlertTitle;
@property (nullable, nonatomic, copy) NSAttributedString *attributedAlertMessage;
@property (nullable, nonatomic, copy, readonly) NSString *alertTitle;
@property (nullable, nonatomic, copy, readonly) NSString *alertMessage;
@property (nullable, nonatomic, copy, readonly) UIImage *alertImage;
@property (nonatomic, readonly) LVMAlertControllerStyle preferredStyle;

@end

@interface LVMAlertController ()

@property (nonatomic, assign) BOOL strikethroughHeader;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) BOOL ignoreKeyboardShowing;

@end

FOUNDATION_EXPORT NSAttributedString * LVMAlertTitleAttributedStringFor(NSString *title);
FOUNDATION_EXPORT NSAttributedString * LVMAlertMessageAttributedStringFor(NSString *message);

@interface NSAttributedString (LVMAlertController)

- (NSAttributedString *)attributedForStrikethrough:(BOOL)strikethrough;
- (NSAttributedString *)attributedForTextAlignment:(NSTextAlignment)textAlignment;

@end

NS_ASSUME_NONNULL_END
