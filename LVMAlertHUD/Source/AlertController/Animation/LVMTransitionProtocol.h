////
// LVMTransitionProtocol.h
// Secoo-iPhone
//
// Created by WuYikai on 2018/7/6.
// Copyright © 2018 douking. All rights reserved.
//
	

#ifndef LVMTransitionProtocol_h
#define LVMTransitionProtocol_h

@class LVMActionSheetTransition;

@protocol LVMActionSheetTransitionProtocol <NSObject>

@optional
- (UIView *)presentingViewControllerBottomView:(__kindof LVMActionSheetTransition *)transition;
- (CGRect)presentingViewControllerBottomViewFinalFrame:(__kindof LVMActionSheetTransition *)transition;
- (UIView *)presentedViewControllerBottomView:(__kindof LVMActionSheetTransition *)transition;
- (CGRect)presentedViewControllerBottomViewFinalFrame:(__kindof LVMActionSheetTransition *)transition;

@end

#endif /* LVMTransitionProtocol_h */
