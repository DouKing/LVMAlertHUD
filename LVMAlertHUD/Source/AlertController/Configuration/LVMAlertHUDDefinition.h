//
//  LVMAlertHUDDefinition.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/27.
//  Copyright © 2016年 secoo. All rights reserved.
//

#ifndef LVMAlertHUDDefinition_h
#define LVMAlertHUDDefinition_h

// color
#define LVMAlertRGBColor(rgb)                 LVMAlertRGBColorAndAlpha(rgb, 1.0)
#define LVMAlertRGBColorAndAlpha(rgb, a)      [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16)) / 255.0 \
                                                              green:((float)((rgb & 0xFF00) >> 8)) / 255.0  \
                                                               blue:((float)(rgb & 0xFF)) / 255.0  \
                                                              alpha:a]

#define kLVMSingleLineWidth                          (1.f / [UIScreen mainScreen].scale)
#define kLVMAlertHUDSeparatorColor                   LVMAlertRGBColor(0xE1E1E1)
#define kLVMActionSheetSeparatorColor                LVMAlertRGBColor(0xE1E1E1)
#define kLVMAlertButtonSelectedColor                 LVMAlertRGBColor(0xF5F5F5)

#endif /* LVMAlertHUDDefinition_h */
