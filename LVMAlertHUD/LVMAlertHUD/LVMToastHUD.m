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

static CGFloat const kLVMToastHUDMessageFontSize = 13.0f;
static CGFloat const kLVMToastHUDHeight = 40.0f;
static CGFloat const kLVMToastHUDTransformY = 40.0f;

static inline CGFloat LVMToastHUDTransformYFrom(UIView *hud) {
    CGFloat maxTransfromY = CGRectGetHeight(hud.superview.bounds) - CGRectGetMinY(hud.frame);
    return MIN(maxTransfromY, kLVMToastHUDTransformY);
}

@interface LVMToastHUD ()

@property (nonatomic, weak) UILabel *messageLabel;

@end

@implementation LVMToastHUD

+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    LVMToastHUD *hud = [view viewWithTag:kLVMToastHUDTag];
    if (hud) {
        return;
    }
    if (!view) { view = [UIApplication sharedApplication].keyWindow; }
    hud = [self toastHUDWithMessage:message view:view];
    hud.messageLabel.text = message;
    [hud _show];
}

+ (instancetype)toastHUDWithMessage:(NSString *)message view:(UIView *)view {
    CGFloat maxWidth = CGRectGetWidth(view.bounds);
    CGFloat maxHeight = CGRectGetHeight(view.bounds);
    CGFloat messageWidth = [message boundingRectWithSize:CGSizeMake(maxWidth - kLVMToastHUDSubViewInsert * 2, maxHeight) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kLVMToastHUDMessageFontSize]} context:nil].size.width;
    CGFloat width = messageWidth + kLVMToastHUDSubViewInsert * 2;
    LVMToastHUD *hud = [[LVMToastHUD alloc] initWithFrame:CGRectMake(0.5 * (maxWidth - width),
                                                                     0.6 * (maxHeight - kLVMToastHUDHeight),
                                                                     width,
                                                                     kLVMToastHUDHeight)];
    hud.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:25 / 255.0 blue:30 / 255.0 alpha:1];
    hud.layer.cornerRadius = 3;
    hud.layer.masksToBounds = YES;
    hud.alpha = 0;
    hud.tag = kLVMToastHUDTag;
    [view addSubview:hud];
    
    hud.transform = CGAffineTransformMakeTranslation(0, LVMToastHUDTransformYFrom(hud));
    return hud;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupSubViews];
    }
    return self;
}

- (void)_setupSubViews {
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.font = [UIFont systemFontOfSize:kLVMToastHUDMessageFontSize];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    _messageLabel = label;
    [self addSubview:label];
}

- (void)_show {
    [[self superview] bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self _dismiss];
    }];
}

- (void)_dismiss {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    self.alpha = 0;
                    self.transform = CGAffineTransformTranslate(self.transform, 0, LVMToastHUDTransformYFrom(self));
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            });
        }];
    });
}

@end
