//
//  LVMAlertHeaderView.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/31.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kLVMAlertHeaderViewId;

@interface LVMAlertHeaderView : UITableViewHeaderFooterView

+ (CGFloat)heightWithTitle:(NSString *)title
                   message:(NSString *)message
                     image:(UIImage *)image
                textFields:(NSArray<UITextField *> *)textFields
                  maxWidth:(CGFloat)maxWidth;

- (void)setupWithTitle:(NSString *)title
               message:(NSString *)message
                 image:(UIImage *)image
            textFields:(NSArray<UITextField *> *)textFields;

@end
