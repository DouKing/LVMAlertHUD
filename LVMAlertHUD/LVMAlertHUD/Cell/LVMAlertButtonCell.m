//
//  LVMAlertButtonCell.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/31.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "LVMAlertButtonCell.h"
#import "LVMAlertAction.h"
#import "LVMAlertHUDDefinition.h"

NSString * const kLVMAlertButtonCellId = @"kLVMAlertButtonCellId";
static NSInteger const kLVMAlertButtonCellButtonBaseTag = 555555;

@implementation LVMAlertButtonCell {
    NSArray<LVMAlertAction *> *_alertActions;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupWithAlertActions:(NSArray<LVMAlertAction *> *)actions {
    _alertActions = actions;
    [self _removeButtons];
    [self _setupButtonsWithAlertActions:actions];
}

- (void)_removeButtons {
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
}

- (void)_setupButtonsWithAlertActions:(NSArray<LVMAlertAction *> *)actions {
    CGFloat width = CGRectGetWidth(self.bounds) / actions.count;
    CGFloat height = CGRectGetHeight(self.bounds);
    for (NSInteger i = 0; i < actions.count; ++i) {
        LVMAlertAction *action = actions[i];
        CGFloat x = i * width;
        CGRect frame = CGRectMake(x, 0, width, height);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        btn.tag = kLVMAlertButtonCellButtonBaseTag + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[self _textColorWithAlertAction:action] forState:UIControlStateNormal];
        [btn setTitle:action.title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(_handleClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (0 == i) { continue; }
        frame = CGRectMake(0, 0, kLVMSingleLineWidth, height);
        UIView *line = [[UIView alloc] initWithFrame:frame];
        line.backgroundColor = kLVMAlertHUDSeparatorColor;
        [btn addSubview:line];
    }
}

- (UIColor *)_textColorWithAlertAction:(LVMAlertAction *)action {
    switch (action.style) {
        case LVMAlertActionStyleDefault: {
            return [UIColor colorWithRed:26 / 255.0 green:25 / 255.0 blue:30 / 255.0 alpha:1];
            break;
        }
        case LVMAlertActionStyleCancel: {
            return [UIColor blackColor];
            break;
        }
        case LVMAlertActionStyleDestructive: {
            return [UIColor redColor];
            break;
        }
    }
}

- (void)_handleClickButtonAction:(UIButton *)sender {
    NSInteger index = sender.tag - kLVMAlertButtonCellButtonBaseTag;
    LVMAlertAction *action = _alertActions[index];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(alertButtonCell:didSelectAction:)]) {
        [self.delegate alertButtonCell:self didSelectAction:action];
    }
}

@end
