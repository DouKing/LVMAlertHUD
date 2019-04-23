//
//  LVMAlertHeaderView.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/31.
//  Copyright © 2016年 douking. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kLVMAlertHeaderViewId;

@interface LVMAlertHeaderView : UITableViewHeaderFooterView

+ (CGFloat)heightWithAttributedTitle:(NSAttributedString *)attributedTitle
                   attributedMessage:(NSAttributedString *)attributedMessage
                               image:(UIImage *)image
                          textFields:(NSArray<UITextField *> *)textFields
               contentViewController:(UIViewController *)contentVC
                            maxWidth:(CGFloat)maxWidth;

- (void)setupWithAttributedTitle:(NSAttributedString *)attributedTitle
               attributedMessage:(NSAttributedString *)attributedMessage
                           image:(UIImage *)image
                      textFields:(NSArray<UITextField *> *)textFields
           contentViewController:(UIViewController *)contentVC;
@end
