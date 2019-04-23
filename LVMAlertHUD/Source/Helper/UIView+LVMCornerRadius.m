//
//  UIView+LVMCornerRadius.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/30.
//  Copyright © 2016年 douking. All rights reserved.
//

#import "UIView+LVMCornerRadius.h"

@implementation UIView (LVMCornerRadius)

- (void)lvm_setCornerRadii:(CGSize)cornerRadii forRoundingCorners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
