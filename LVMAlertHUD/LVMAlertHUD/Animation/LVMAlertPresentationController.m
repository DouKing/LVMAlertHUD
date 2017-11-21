//
// LVMAlertAnimator.h
// Secoo-iPhone
//
// Created by WuYikai on 2017/11/21.
// Copyright © 2017年 secoo. All rights reserved.
//
	

#import "LVMAlertPresentationController.h"

static inline UIColor *LVMAlertShowBackgroundColor() {
    return [UIColor colorWithRed:26/255.0 green:25/255.0 blue:30/255.0 alpha:0.4];
}

static inline UIColor *LVMAlertDismissBackgroundColor() {
    return [UIColor clearColor];
}

@interface LVMAlertPresentationController ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation LVMAlertPresentationController

- (void)presentationTransitionWillBegin {
    if (!self.containerView) { return; }
    [self.containerView addSubview:self.bgView];
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.bgView.backgroundColor = LVMAlertShowBackgroundColor();
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    self.bgView.frame = self.containerView.bounds;
    self.presentedView.frame = self.frameOfPresentedViewInContainerView;
}

- (void)dismissalTransitionWillBegin {
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.bgView.backgroundColor = LVMAlertDismissBackgroundColor();
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.bgView removeFromSuperview];
    }];
}

- (UIView *)presentedView {
    UIView *v = self.presentedViewController.view;
    v.layer.cornerRadius = 4;
    v.clipsToBounds = YES;
    return v;
}

- (CGRect)frameOfPresentedViewInContainerView {
    if (!self.containerView) {
        return CGRectZero;
    }
    CGSize contentSize = self.presentedViewController.preferredContentSize;
    return CGRectMake((self.containerView.bounds.size.width - contentSize.width) / 2.0,
                      (self.containerView.bounds.size.height - contentSize.height) / 2.0,
                      contentSize.width, contentSize.height);
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

@end

@implementation LVMActionSheetPresentationController

- (CGRect)frameOfPresentedViewInContainerView {
    if (!self.containerView) {
        return CGRectZero;
    }
    CGSize contentSize = self.presentedViewController.preferredContentSize;
    return CGRectMake((self.containerView.bounds.size.width - contentSize.width) / 2.0,
                      (self.containerView.bounds.size.height - contentSize.height),
                      contentSize.width, contentSize.height);
}

@end

