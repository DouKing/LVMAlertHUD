//
//  LVMStatusBarHUD.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/27.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "LVMStatusBarHUD.h"

static NSInteger const kLVMStatusBarHUDTag = 999999;
static CGFloat const kLVMStatusBarHeight = 20;
static CGFloat const kLVMStatusBarHUDHeight = 64;
static CGFloat const kLVMStatusBarHUDDismissDelay = 4.0f;
static CGFloat const kLVMStatusBarHUDAnimateDuration = 0.3f;

@interface LVMStatusBarHUD ()

@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL isDismissing;
@property (nonatomic, assign) BOOL shouldShow;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy)   LVMStatusBarHUDAnimationHandler tempCompletion;

@property (nonatomic, weak)   UIImageView *imageView;
@property (nonatomic, weak)   UILabel *textLabel;

@end

@implementation LVMStatusBarHUD

- (void)dealloc {
    [_timer invalidate];
}

+ (instancetype)showWithMessage:(NSString *)message completion:(LVMStatusBarHUDAnimationHandler)completion {
    return [self showWithMessage:message type:LVMStatusBarHUDTypeWarning completion:completion];
}

+ (instancetype)showWithMessage:(NSString *)message type:(LVMStatusBarHUDType)type completion:(LVMStatusBarHUDAnimationHandler)completion {
    LVMStatusBarHUD *hud = [self statusBarHUD];
    hud.textLabel.text = message;
    hud.imageView.image = [hud _imageWithType:type];
    [hud _showWithCompletion:completion];
    return hud;
}

+ (instancetype)statusBarHUD {
    LVMStatusBarHUD *hud = [[[UIApplication sharedApplication] keyWindow] viewWithTag:kLVMStatusBarHUDTag];
    if (!hud) {
        hud = [[self alloc] init];
        hud.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:25 / 255.0 blue:30 / 255.0 alpha:1];
        hud.tag = kLVMStatusBarHUDTag;
        [[[UIApplication sharedApplication] keyWindow] addSubview:hud];
    }
    return hud;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    frame = CGRectMake(0, -kLVMStatusBarHUDHeight, width, kLVMStatusBarHUDHeight);
    self = [super initWithFrame:frame];
    if (self) {
        _count = kLVMStatusBarHUDDismissDelay;
        [self _setupSubViews];
        [self _setupPanGesture];
    }
    return self;
}

#pragma mark - Private Methods -

- (void)_setupSubViews {
    CGFloat height = kLVMStatusBarHUDHeight - kLVMStatusBarHeight;
    CGRect frame = CGRectMake(0, kLVMStatusBarHeight, height, height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeCenter;
    _imageView = imageView;
    [self addSubview:imageView];
    
    CGFloat x = CGRectGetMaxX(imageView.frame);
    frame = CGRectMake(x, kLVMStatusBarHeight, CGRectGetWidth(self.bounds) - x, height);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    _textLabel = label;
    [self addSubview:label];
}

- (void)_setupPanGesture {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePangesture:)];
    [self addGestureRecognizer:gesture];
}

- (void)_showWithCompletion:(LVMStatusBarHUDAnimationHandler)completion {
    [[self superview] bringSubviewToFront:self];
    self.shouldShow = YES;
    if (self.isShowing || self.isDismissing) {
        self.tempCompletion = completion;
        return;
    }
    self.isShowing = YES;
    [self _invalidateTimer];
    [UIView animateWithDuration:kLVMStatusBarHUDAnimateDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.isShowing = NO;
        self.shouldShow = NO;
        self.tempCompletion = nil;
        if (completion) { completion(); }
        [self _startTimer];
    }];
}

- (void)_dismissWithCompletion:(LVMStatusBarHUDAnimationHandler)completion {
    if (self.isShowing || self.isDismissing) {
        return;
    }
    self.isDismissing = YES;
    [UIView animateWithDuration:kLVMStatusBarHUDAnimateDuration / 2.0 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -kLVMStatusBarHUDHeight;
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.isDismissing = NO;
        if (completion) { completion(); }
        if (self.shouldShow) {
            [self _showWithCompletion:self.tempCompletion];
        } else {
            [self removeFromSuperview];
        }
    }];
}

- (void)_invalidateTimer {
    [_timer invalidate];
    _count = kLVMStatusBarHUDDismissDelay;
}

- (void)_startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(_handleTimerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)_handleTimerAction:(NSTimer *)timer {
    self.count--;
    if (self.count > 0) {
        return;
    }
    [self _invalidateTimer];
    [self _dismissWithCompletion:nil];
}

- (void)_handlePangesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    if (translation.y < 0) {
        [self _dismissWithCompletion:nil];
    }
}

#pragma mark - Helper

- (UIImage *)_imageWithType:(LVMStatusBarHUDType)type {
    switch (type) {
        case LVMStatusBarHUDTypeNone: {
            return nil;
            break;
        }
        case LVMStatusBarHUDTypeWarning: {
            return [UIImage imageNamed:@"img_alertHUD_statusBar_warning_icon"];
            break;
        }
        case LVMStatusBarHUDTypeError: {
            return [UIImage imageNamed:@"img_alertHUD_statusBar_warning_icon"];
            break;
        }
        case LVMStatusBarHUDTypeSuccess: {
            return [UIImage imageNamed:@"img_alertHUD_statusBar_warning_icon"];
            break;
        }
    }
}

@end
