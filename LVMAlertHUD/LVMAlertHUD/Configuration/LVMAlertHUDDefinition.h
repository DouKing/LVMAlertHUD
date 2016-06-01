//
//  LVMAlertHUDDefinition.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/27.
//  Copyright © 2016年 secoo. All rights reserved.
//

#ifndef LVMAlertHUDDefinition_h
#define LVMAlertHUDDefinition_h

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define IOS_8_LATER                                  SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#define kLVMSingleLineWidth                          (1.f / [UIScreen mainScreen].scale)
#define kLVMAlertHUDSeparatorColor                   [UIColor lightGrayColor]

#endif /* LVMAlertHUDDefinition_h */
