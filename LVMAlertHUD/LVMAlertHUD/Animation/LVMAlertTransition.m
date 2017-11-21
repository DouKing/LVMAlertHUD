//
// LVMAlertAnimator.m
// Secoo-iPhone
//
// Created by WuYikai on 2017/11/21.
// Copyright © 2017年 secoo. All rights reserved.
//
	

#import "LVMAlertTransition.h"

@interface LVMAlertBaseTransition ()

@property (nonatomic, assign) LVMAlertTransitionType transitionType;
- (void)_present:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)_dismiss:(id<UIViewControllerContextTransitioning>)transitionContext;

@end

@implementation LVMAlertBaseTransition

- (instancetype)initWithTransitionType:(LVMAlertTransitionType)transitionType {
    self = [super init];
    if (self) {
        self.transitionType = transitionType;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.transitionType) {
        case LVMAlertTransitionTypePresent:
            [self _present:transitionContext];
            break;
        case LVMAlertTransitionTypeDismiss:
            [self _dismiss:transitionContext];
            break;
    }
}

- (void)_present:(id<UIViewControllerContextTransitioning>)transitionContext {
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}

- (void)_dismiss:(id<UIViewControllerContextTransitioning>)transitionContext {
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}

@end

@implementation LVMAlertTransition

- (void)_present:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    toView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    toView.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        toView.alpha = 1;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)_dismiss:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromView];
    [UIView animateWithDuration:0.2 animations:^{
        fromView.alpha = 0;
        fromView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end

@implementation LVMActionSheetTransition

- (void)_present:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    toView.transform = CGAffineTransformMakeTranslation(0, toView.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)_dismiss:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromView];
    [UIView animateWithDuration:0.2 animations:^{
        fromView.transform = CGAffineTransformMakeTranslation(0, fromView.frame.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end

