//
// LVMAlertAnimator.h
// Secoo-iPhone
//
// Created by WuYikai on 2017/11/21.
// Copyright © 2017年 douking. All rights reserved.
//
	

#import <UIKit/UIKit.h>
#import "LVMPresentationProtocol.h"

//the default width of alert
extern CGFloat const kLVMAlertControllerAlertWidth;

@interface LVMBasePresentationController : UIPresentationController

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) BOOL ignoreKeyboardShowing;

@end

@interface LVMAlertPresentationController : LVMBasePresentationController

@end

@interface LVMActionSheetPresentationController : LVMAlertPresentationController

@property (nonatomic, weak) id<LVMPresentationProtocol> presentationDelegate;

@end

