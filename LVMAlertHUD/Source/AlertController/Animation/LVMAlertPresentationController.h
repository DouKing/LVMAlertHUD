//
// LVMAlertAnimator.h
// Secoo-iPhone
//
// Created by WuYikai on 2017/11/21.
// Copyright © 2017年 secoo. All rights reserved.
//
	

#import <UIKit/UIKit.h>

@interface LVMBasePresentationController : UIPresentationController

@property (nonatomic, strong) UIView *bgView;

@end

@interface LVMAlertPresentationController : LVMBasePresentationController

@end

@interface LVMActionSheetPresentationController : LVMAlertPresentationController

@end

