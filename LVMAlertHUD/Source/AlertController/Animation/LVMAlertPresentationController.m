//
// LVMAlertAnimator.h
// Secoo-iPhone
//
// Created by WuYikai on 2017/11/21.
// Copyright © 2017年 douking. All rights reserved.
//
	

#import "LVMAlertPresentationController.h"

@implementation LVMBasePresentationController {
    @public
    CGRect _keyboardRect;
}

- (void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_handleDeviceOrientationDidChangeNotification:)
                                                     name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)presentationTransitionWillBegin {
    if (!self.containerView) { return; }
    self.bgView.alpha = 0;
    [self.containerView addSubview:self.bgView];
    self.bgView.frame = self.containerView.bounds;
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.alpha = 1;
        }];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}

- (void)dismissalTransitionWillBegin {
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.alpha = 0;
        }];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.bgView removeFromSuperview];
    }];
}

- (void)_handleDeviceOrientationDidChangeNotification:(NSNotification *)note {
    self.bgView.frame = self.containerView.bounds;
    self.presentedView.frame = self.frameOfPresentedViewInContainerView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _bgView;
}

#pragma mark -

- (void)_keyboardWillShow:(NSNotification *)note {
    if (self.ignoreKeyboardShowing) { return; }
    CGRect keyboardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardRect = keyboardRect;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.presentedView.frame = self.frameOfPresentedViewInContainerView;
    }];
}

- (void)_keyboardWillHide:(NSNotification *)note {
    if (self.ignoreKeyboardShowing) { return; }
    _keyboardRect = CGRectZero;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.presentedView.frame = self.frameOfPresentedViewInContainerView;
    }];
}

@end

@implementation LVMAlertPresentationController

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
    CGFloat height = MIN(contentSize.height, CGRectGetHeight(self.containerView.bounds) - _keyboardRect.size.height);
    return CGRectMake((self.containerView.bounds.size.width - contentSize.width) / 2.0,
                      (self.containerView.bounds.size.height - height - _keyboardRect.size.height) / 2.0,
                      contentSize.width, height);
}

@end

@interface LVMActionSheetPresentationController ()<UIGestureRecognizerDelegate>

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
    if (_keyboardRect.size.height > 0) {
        bottom = 0;
    }
    CGSize contentSize = self.presentedViewController.preferredContentSize;
    CGFloat height = MIN(contentSize.height + bottom, CGRectGetHeight(self.containerView.bounds) - _keyboardRect.size.height);
    return CGRectMake((self.containerView.bounds.size.width - contentSize.width) / 2.0,
                      (self.containerView.bounds.size.height - height - _keyboardRect.size.height),
                      contentSize.width, height);
}

- (UIView *)presentedView {
    UIView *v = self.presentedViewController.view;
    return v;
}

- (void)_dismiss {
    if ([self.presentationDelegate respondsToSelector:@selector(presentedViewControllerShouldDismiss:from:completion:)]) {
        [self.presentationDelegate presentedViewControllerShouldDismiss:self.presentedViewController
                                                                   from:self.presentingViewController
                                                             completion:nil];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismiss)];
        _tapGesture.delegate = self;
    }
    return _tapGesture;
}

- (BOOL)ignoreKeyboardShowing {
    return NO;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UIView *v = touch.view;
    if (v != self.bgView) {
        return NO;
    }
    CGFloat maxY;
    CGFloat contentHeight = self.presentedViewController.preferredContentSize.height;
    CGFloat totalHeight = self.containerView.bounds.size.height;
    if (contentHeight > 0 && totalHeight >= contentHeight) {
        maxY = totalHeight - contentHeight;
    } else {
        maxY = 200;
    }
    CGPoint point = [touch locationInView:v];
    if (point.y > maxY) {
        return NO;
    }
    return YES;
}

@end

