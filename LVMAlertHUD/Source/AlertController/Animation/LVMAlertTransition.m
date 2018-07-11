//
// LVMAlertAnimator.m
// Secoo-iPhone
//
// Created by WuYikai on 2017/11/21.
// Copyright © 2017年 secoo. All rights reserved.
//
	

#import "LVMAlertTransition.h"
#if __has_include(<POP.h>)
    #import <POP.h>
#else
    #import "POP.h"
#endif

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
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    toView.frame = finalFrame;
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
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    CGFloat after = 0;
    UIView *fromBottomView = [self _fromBottomView];
    if (fromBottomView) {
        CGRect startFrame = [self _fromBottomViewFrame:fromBottomView];
        CGRect finalFrame = CGRectOffset(startFrame, 0, startFrame.size.height);
        POPSpringAnimation *frameAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        frameAnimation.springBounciness = 0;
        frameAnimation.springSpeed = 20;
        frameAnimation.toValue = [NSValue valueWithCGRect:finalFrame];
        [fromBottomView pop_addAnimation:frameAnimation forKey:@"frameAnimation"];
        after = 0.14;
    }

    __weak typeof(self) __weak_self__ = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(__weak_self__) self = __weak_self__;

        CGRect finalFrame1 = [transitionContext finalFrameForViewController:toVC];
        CGRect startFrame1 = CGRectOffset(finalFrame1, 0, finalFrame1.size.height);
        toVC.view.frame = startFrame1;
        [[transitionContext containerView] addSubview:toVC.view];
        POPSpringAnimation *frameAnimation1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        frameAnimation1.springBounciness = 0;
        frameAnimation1.springSpeed = 20;
        frameAnimation1.toValue = [NSValue valueWithCGRect:finalFrame1];
        [toVC.view pop_addAnimation:frameAnimation1 forKey:@"toVC.view"];

        UIView *toBottomView = [self _toBottomView];
        if (toBottomView) {
            CGRect ff = [self _toBottomViewFrame:toBottomView];
            CGRect sf = CGRectOffset(ff, 0, toBottomView.frame.size.height);
            toBottomView.frame = sf;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                POPSpringAnimation *frameAnimation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                frameAnimation2.springBounciness = 0;
                frameAnimation2.springSpeed = 20;
                frameAnimation2.toValue = [NSValue valueWithCGRect:ff];
                [toBottomView pop_addAnimation:frameAnimation2 forKey:@"bottomView"];

                frameAnimation2.completionBlock = ^(POPAnimation *animation, BOOL finish) {
                    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                };
            });
        } else {
            frameAnimation1.completionBlock = ^(POPAnimation *animation, BOOL finish) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            };
        }
    });
}

- (void)_dismiss:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finialFrame = CGRectOffset(initialFrame, 0, initialFrame.size.height);
    POPSpringAnimation *frameAnimation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    frameAnimation2.springBounciness = 0;
    frameAnimation2.springSpeed = 20;
    frameAnimation2.toValue = [NSValue valueWithCGRect:finialFrame];
    [fromVC.view pop_addAnimation:frameAnimation2 forKey:@"fromVC.view"];

    UIView *toBottomView = [self _toBottomView];
    if (toBottomView) {
        __weak typeof(self) __weak_self__ = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.32 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(__weak_self__) self = __weak_self__;
            CGRect finalFrame = [self _toBottomViewFrame:toBottomView];
            finalFrame = CGRectOffset(finalFrame, 0, -[self _safeAreaInsetsOfView:containerView].bottom);
            POPSpringAnimation *frameAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            frameAnimation.springBounciness = 0;
            frameAnimation.springSpeed = 20;
            frameAnimation.toValue = [NSValue valueWithCGRect:finalFrame];
            [toBottomView pop_addAnimation:frameAnimation forKey:@"frameAnimation"];

            fromVC.view.alpha = 0;
            frameAnimation.completionBlock = ^(POPAnimation *animation, BOOL finish) {
                fromVC.view.alpha = 1;
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            };
        });
    } else {
        frameAnimation2.completionBlock = ^(POPAnimation *animation, BOOL finish) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        };
    }
}

- (UIEdgeInsets)_safeAreaInsetsOfView:(UIView *)view {
    if (@available(iOS 11.0, *)) {
        return view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

- (UIView *)_toBottomView {
    UIView *toBottomView = nil;
    if (self.transitionType == LVMAlertTransitionTypePresent) {
        if ([self.delegate respondsToSelector:@selector(presentedViewControllerBottomView:)]) {
            toBottomView = [self.delegate presentedViewControllerBottomView:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(presentingViewControllerBottomView:)]) {
            toBottomView = [self.delegate presentingViewControllerBottomView:self];
        }
    }
    return toBottomView;
}

- (CGRect)_toBottomViewFrame:(UIView *)toBottomView {
    if (self.transitionType == LVMAlertTransitionTypePresent) {
        if ([self.delegate respondsToSelector:@selector(presentedViewControllerBottomViewFinalFrame:)]) {
            return [self.delegate presentedViewControllerBottomViewFinalFrame:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(presentingViewControllerBottomViewFinalFrame:)]) {
            return [self.delegate presentingViewControllerBottomViewFinalFrame:self];
        }
    }
    return toBottomView.frame;
}

- (UIView *)_fromBottomView {
    UIView *fromBottomView = nil;
    if (self.transitionType == LVMAlertTransitionTypeDismiss) {
        if ([self.delegate respondsToSelector:@selector(presentedViewControllerBottomView:)]) {
            fromBottomView = [self.delegate presentedViewControllerBottomView:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(presentingViewControllerBottomView:)]) {
            fromBottomView = [self.delegate presentingViewControllerBottomView:self];
        }
    }
    return fromBottomView;
}

- (CGRect)_fromBottomViewFrame:(UIView *)fromBottomView {
    if (self.transitionType == LVMAlertTransitionTypeDismiss) {
        if ([self.delegate respondsToSelector:@selector(presentedViewControllerBottomViewFinalFrame:)]) {
            return [self.delegate presentedViewControllerBottomViewFinalFrame:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(presentingViewControllerBottomViewFinalFrame:)]) {
            return [self.delegate presentingViewControllerBottomViewFinalFrame:self];
        }
    }
    return fromBottomView.frame;
}

@end

