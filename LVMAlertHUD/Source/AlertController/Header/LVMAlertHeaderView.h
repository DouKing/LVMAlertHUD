//
//  LVMAlertHeaderView.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/31.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kLVMAlertHeaderViewId;

FOUNDATION_EXPORT NSAttributedString * LVMAlertTitleAttributedStringFor(NSString *title, BOOL strikethroughHeader);
FOUNDATION_EXPORT NSAttributedString * LVMAlertMessageAttributedStringFor(NSString *message, NSTextAlignment textAlignment);

@interface LVMAlertHeaderView : UITableViewHeaderFooterView

+ (CGFloat)heightWithAttributedTitle:(NSAttributedString *)attributedTitle
                   attributedMessage:(NSAttributedString *)attributedMessage
                               image:(UIImage *)image
                          textFields:(NSArray<UITextField *> *)textFields
                            maxWidth:(CGFloat)maxWidth;

- (void)setupWithAttributedTitle:(NSAttributedString *)attributedTitle
               attributedMessage:(NSAttributedString *)attributedMessage
                           image:(UIImage *)image
                      textFields:(NSArray<UITextField *> *)textFields;
@end

///Deprecated
@interface LVMAlertHeaderView()

@property (nonatomic, assign) BOOL strikethroughHeader;

@end

@interface LVMAlertHeaderView (Deprecated)

+ (CGFloat)heightWithTitle:(NSString *)title
                   message:(NSString *)message
                     image:(UIImage *)image
                textFields:(NSArray<UITextField *> *)textFields
                  maxWidth:(CGFloat)maxWidth
             textAlignment:(NSTextAlignment)textAlignment NS_UNAVAILABLE;

- (void)setupWithTitle:(NSString *)title
               message:(NSString *)message
                 image:(UIImage *)image
            textFields:(NSArray<UITextField *> *)textFields
         textAlignment:(NSTextAlignment)textAlignment NS_UNAVAILABLE;

@end

