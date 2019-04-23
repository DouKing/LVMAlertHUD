//
// LVMAlertAnimator.h
// Secoo-iPhone
//
// Created by WuYikai on 2017/11/21.
// Copyright © 2017年 douking. All rights reserved.
//
	

@import UIKit;
#import "LVMTransitionProtocol.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, LVMAlertTransitionType) {
    LVMAlertTransitionTypePresent,
    LVMAlertTransitionTypeDismiss
};

@interface LVMAlertBaseTransition : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionType:(LVMAlertTransitionType)transitionType;
@property (nonatomic, assign, readonly) LVMAlertTransitionType transitionType;

@end


@interface LVMAlertTransition : LVMAlertBaseTransition

@end

@interface LVMActionSheetTransition : LVMAlertBaseTransition

@property (nonatomic, weak) id<LVMActionSheetTransitionProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
