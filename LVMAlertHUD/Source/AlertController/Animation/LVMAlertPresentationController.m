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

@implementation LVMBasePresentationController {
    @public
    CGRect _keyboardRect;
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        _keyboardRect = CGRectZero;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)presentationTransitionWillBegin {
    if (!self.containerView) { return; }
    [self.containerView addSubview:self.bgView];
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.backgroundColor = LVMAlertShowBackgroundColor();
        }];
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
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.backgroundColor = LVMAlertDismissBackgroundColor();
        }];
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

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

#pragma mark -

- (void)_keyboardWillShow:(NSNotification *)note {
    CGRect keyboardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardRect = keyboardRect;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.presentedView.frame = self.frameOfPresentedViewInContainerView;
    }];
}

- (void)_keyboardWillHide:(NSNotification *)note {
    _keyboardRect = CGRectZero;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.presentedView.frame = self.frameOfPresentedViewInContainerView;
    }];
}

@end

@implementation LVMAlertPresentationController

- (CGRect)frameOfPresentedViewInContainerView {
    if (!self.containerView) {
        return CGRectZero;
    }
    CGSize contentSize = self.presentedViewController.preferredContentSize;
    CGFloat height = MIN(contentSize.height, CGRectGetHeight(self.containerView.bounds) - _keyboardRect.size.height);
    return CGRectMake((self.containerView.bounds.size.width - contentSize.width) / 2.0,
                      (self.containerView.bounds.size.height - height - _keyboardRect.size.height) / 2.0,
                      contentSize.width, height);
}

@end

@interface LVMActionSheetPresentationController ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation LVMActionSheetPresentationController

- (void)presentationTransitionWillBegin {
    [super presentationTransitionWillBegin];
    [self.bgView addGestureRecognizer:self.tapGesture];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [super dismissalTransitionDidEnd:completed];
    [self.bgView removeGestureRecognizer:self.tapGesture];
}

- (CGRect)frameOfPresentedViewInContainerView {
    if (!self.containerView) {
        return CGRectZero;
    }
    CGFloat bottom = 0;
    if (@available (iOS 11.0, *)) {
        bottom = self.presentingViewController.view.safeAreaInsets.bottom;
    }
    CGSize contentSize = self.presentedViewController.preferredContentSize;
    CGFloat height = MIN(contentSize.height, CGRectGetHeight(self.containerView.bounds) - _keyboardRect.size.height);
    return CGRectMake((self.containerView.bounds.size.width - contentSize.width) / 2.0,
                      (self.containerView.bounds.size.height - height - bottom),
                      contentSize.width, height);
}

- (void)_dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismiss)];
    }
    return _tapGesture;
}

@end

