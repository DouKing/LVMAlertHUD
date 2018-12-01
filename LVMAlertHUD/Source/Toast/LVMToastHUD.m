//
//  LVMToastHUD.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/6/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "LVMToastHUD.h"
#if __has_include(<POP.h>)
    #import <POP.h>
#else
    #import "POP.h"
#endif

static NSInteger const kLVMToastHUDTag = 99999;
static CGFloat const kLVMToastHUDSubViewInsert = 18;

static CGFloat const kLVMToastHUDMessageFontSize = 13.0f;
static CGFloat const kLVMToastHUDHeight = 40.0f;
static CGFloat const kLVMToastHUDTransformY = 40.0f;

static inline CGFloat LVMToastHUDTransformYFrom(UIView *hud) {
    CGFloat maxTransfromY = floorf(CGRectGetHeight(hud.superview.bounds) - CGRectGetMinY(hud.frame));
    return MIN(maxTransfromY, kLVMToastHUDTransformY);
}

@interface LVMToastHUD ()

@property (nonatomic, weak) UILabel *messageLabel;

@end

@implementation LVMToastHUD

+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    if (!view) {
        //如果没有view，用window代替
        view = [UIApplication sharedApplication].keyWindow;
    }
    LVMToastHUD *hud = [view viewWithTag:kLVMToastHUDTag];
    if (hud) { return; }
    hud = [self toastHUDWithMessage:message view:view];
    hud.messageLabel.text = message;
    [hud _show];
}

+ (instancetype)toastHUDWithMessage:(NSString *)message view:(UIView *)view {
    if (!message || ![message isKindOfClass:NSString.class] || !message.length) { return nil; }
    CGFloat maxWidth = CGRectGetWidth(view.bounds);
    CGFloat maxHeight = CGRectGetHeight(view.bounds);
    CGFloat messageWidth = [message boundingRectWithSize:CGSizeMake(maxWidth - kLVMToastHUDSubViewInsert * 2, maxHeight) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kLVMToastHUDMessageFontSize]} context:nil].size.width;
    CGFloat width = ceilf(messageWidth + kLVMToastHUDSubViewInsert * 2);
    LVMToastHUD *hud = [view viewWithTag:kLVMToastHUDTag];
    if (!hud) {
        hud = [[LVMToastHUD alloc] initWithFrame:CGRectMake(ceilf(0.5 * (maxWidth - width)),
                                                            ceilf(0.5 * (maxHeight - kLVMToastHUDHeight)),
                                                            width,
                                                            kLVMToastHUDHeight)];
        hud.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:25 / 255.0 blue:30 / 255.0 alpha:1];
        hud.layer.cornerRadius = 3;
        hud.layer.masksToBounds = YES;
        hud.tag = kLVMToastHUDTag;
        [view addSubview:hud];
        
        hud.alpha = 0;
        hud.center = CGPointMake(hud.center.x, hud.center.y + LVMToastHUDTransformYFrom(hud));
    }
    
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
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:kLVMToastHUDMessageFontSize];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    _messageLabel = label;
    [self addSubview:label];
}

- (void)_show {
    [[self superview] bringSubviewToFront:self];
    __weak typeof(self) weakSelf = self;

    POPSpringAnimation *centerAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    centerAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y - LVMToastHUDTransformYFrom(self))];
    centerAnimation.springSpeed = 15;
    [centerAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finish) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf _dismiss];
        });
    }];
    [self pop_addAnimation:centerAnimation forKey:@"centerAnimation"];
    
    POPSpringAnimation *alphaAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.toValue = @(1);
    [self pop_addAnimation:alphaAnimation forKey:@"alphaAnimation"];
}

- (void)_dismiss {
    POPSpringAnimation *scalAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scalAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.8, 0.8)];
    scalAnimation.springSpeed = 15;
    [self pop_addAnimation:scalAnimation forKey:@"scalAnimation"];
    
    CFTimeInterval beginTime = CACurrentMediaTime() + 0.2;
    
    POPSpringAnimation *centerAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    centerAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y + LVMToastHUDTransformYFrom(self))];
    centerAnimation.beginTime = beginTime;
    [self pop_addAnimation:centerAnimation forKey:@"centerAnimation"];
    
    POPSpringAnimation *alphaAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.toValue = @(0);
    alphaAnimation.beginTime = beginTime;
    [alphaAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finish) {
        [self removeFromSuperview];
    }];
    [self pop_addAnimation:alphaAnimation forKey:@"alphaAnimation"];
}

@end
