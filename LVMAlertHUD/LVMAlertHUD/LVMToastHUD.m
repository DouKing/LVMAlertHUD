//
//  LVMToastHUD.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/6/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "LVMToastHUD.h"

static NSInteger const kLVMToastHUDTag = 99999;
static CGFloat const kLVMToastHUDSubViewInsert = 18;
static CGFloat const kLVMToastHUDDismissDelay = 2.0f;
static CGFloat const kLVMToastHUDScaleDely = 0.5f;

static CGFloat const kLVMToastHUDMessageFontSize = 13.0f;
static CGFloat const kLVMToastHUDHeight = 40.0f;

@interface LVMToastHUD ()

@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL isDismissing;
@property (nonatomic, assign) BOOL shouldShow;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat count;

@end

@implementation LVMToastHUD

- (void)dealloc {
    [_timer invalidate];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    LVMToastHUD *hud = [self toastHUDWithMessage:message view:view];
    hud.messageLabel.text = message;
    [hud _show];
}

+ (instancetype)toastHUDWithMessage:(NSString *)message view:(UIView *)view {
    CGFloat maxWidth = CGRectGetWidth(view.bounds);
    CGFloat maxHeight = CGRectGetHeight(view.bounds);
    CGFloat messageWidth = [message boundingRectWithSize:CGSizeMake(maxWidth - kLVMToastHUDSubViewInsert * 2, maxHeight) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kLVMToastHUDMessageFontSize]} context:nil].size.width;
    CGFloat width = messageWidth + kLVMToastHUDSubViewInsert * 2;
    LVMToastHUD *hud = [view viewWithTag:kLVMToastHUDTag];
    if (hud) {
        CGRect frame = hud.frame;
        frame.size.width = width;
        frame.origin.x = 0.5 * (maxWidth - width);
        [UIView animateWithDuration:0.3f animations:^{
            hud.frame = frame;
        }];
        return hud;
    }
    
    hud = [[LVMToastHUD alloc] initWithFrame:CGRectMake(0.5 * (maxWidth - width),
                                                        0.5 * (maxHeight - kLVMToastHUDHeight),
                                                        width,
                                                        kLVMToastHUDHeight)];
    hud.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:25 / 255.0 blue:30 / 255.0 alpha:1];
    hud.layer.cornerRadius = 3;
    hud.layer.masksToBounds = YES;
    hud.alpha = 0;
    hud.tag = kLVMToastHUDTag;
    [view addSubview:hud];
    
    view.clipsToBounds = YES;
    hud.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(view.bounds) - CGRectGetMinY(hud.frame));
    return hud;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _count = kLVMToastHUDDismissDelay;
        [self _setupSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectMake(kLVMToastHUDSubViewInsert, 0,
                              CGRectGetWidth(self.bounds) -
                              kLVMToastHUDSubViewInsert * 2,
                              CGRectGetHeight(self.bounds));
    self.messageLabel.frame = frame;
}

- (void)_setupSubViews {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    _messageLabel = label;
    [self addSubview:label];
}

- (void)_show {
    [[self superview] bringSubviewToFront:self];
    self.shouldShow = YES;
    if (self.isShowing || self.isDismissing) {
        return;
    }
    self.isShowing = YES;
    [self _invalidateTimer];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.isShowing = NO;
        self.shouldShow = NO;
        [self _startTimer];
    }];
}

- (void)_dismiss {
    if (self.isShowing || self.isDismissing) {
        return;
    }
    self.isDismissing = YES;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
        self.transform =
        CGAffineTransformConcat(CGAffineTransformMakeScale(0.8, 0.8),
                                CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.superview.bounds) -
                                                                 CGRectGetMinY(self.frame)));
    } completion:^(BOOL finished) {
        self.isDismissing = NO;
        if (self.shouldShow) {
            [self _show];
        } else {
            [self removeFromSuperview];
        }
    }];
}

- (void)_scale {
    [UIView animateWithDuration:0.2f animations:^{
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
    }];
}

- (void)_invalidateTimer {
    [_timer invalidate];
    _count = kLVMToastHUDDismissDelay;
}

- (void)_startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(_handleTimerAction:) userInfo:nil repeats:YES];
}

- (void)_handleTimerAction:(NSTimer *)timer {
    self.count -= 0.5;
    if (kLVMToastHUDScaleDely == self.count) {
        [self _scale];
    }
    if (self.count > 0) {
        return;
    }
    [self _invalidateTimer];
    [self _dismiss];
}


@end
