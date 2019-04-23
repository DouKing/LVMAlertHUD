//
//  UIView+LVMCornerRadius.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/30.
//  Copyright © 2016年 douking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LVMCornerRadius)

/**
 *  设置圆角
 *
 *  @param cornerRadii radius for corner
 *  @param corners     corners
 */
- (void)lvm_setCornerRadii:(CGSize)cornerRadii forRoundingCorners:(UIRectCorner)corners;

@end
