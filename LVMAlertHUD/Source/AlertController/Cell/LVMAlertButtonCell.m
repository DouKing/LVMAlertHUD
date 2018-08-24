//
//  LVMAlertButtonCell.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/31.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "LVMAlertButtonCell.h"
#import "_LVMAlertAction+Private.h"
#import "LVMAlertHUDDefinition.h"
#import "LVMAlertHUDConfigure.h"

NSString * const kLVMAlertButtonCellId = @"kLVMAlertButtonCellId";
static NSInteger const kLVMAlertButtonCellButtonBaseTag = 555555;

@implementation LVMAlertButtonCell {
  NSArray<LVMAlertAction *> *_actions;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGFloat width = CGRectGetWidth(self.contentView.bounds) / _actions.count;
  CGFloat height = CGRectGetHeight(self.contentView.bounds);
  [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    CGFloat x = idx * width;
    CGRect frame = CGRectMake(x, 0, width, height);
    obj.frame = frame;
  }];
}

- (void)setupWithAlertActions:(NSArray<LVMAlertAction *> *)actions {
    _actions = actions;
    [self _removeButtons];
    [self _setupButtonsWithAlertActions:actions];
}

- (void)_removeButtons {
    for (UIView *subView in [self.contentView subviews]) {
        [subView removeFromSuperview];
    }
}

- (void)_setupButtonsWithAlertActions:(NSArray<LVMAlertAction *> *)actions {
    CGFloat width = CGRectGetWidth(self.contentView.bounds) / actions.count;
    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    for (NSInteger i = 0; i < actions.count; ++i) {
        LVMAlertAction *action = actions[i];
        CGFloat x = i * width;
        CGRect frame = CGRectMake(x, 0, width, height);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        btn.backgroundColor = [UIColor whiteColor];
        btn.enabled = action.enabled;
        btn.tag = kLVMAlertButtonCellButtonBaseTag + i;
        btn.titleLabel.font = LVMAlertActionFontWithActionStytle(action.style);
        [btn setTitleColor:[self _textColorWithAlertAction:action] forState:UIControlStateNormal];
        [btn setTitle:action.title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(_handleClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        // cell上加button [btn setBackgroundImage:image forState:UIControlStateSelected]不起作用?！
        [btn addTarget:self action:@selector(_handleTouchSelect:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(_handleTouchSelect:) forControlEvents:UIControlEventTouchDragEnter];
        [btn addTarget:self action:@selector(_handleTouchCancel:) forControlEvents:UIControlEventTouchCancel];
        [btn addTarget:self action:@selector(_handleTouchCancel:) forControlEvents:UIControlEventTouchDragExit];
        [self.contentView addSubview:btn];
        action.associatedButton = btn;
        if (0 == i) { continue; }
        frame = CGRectMake(0, 0, kLVMSingleLineWidth, height);
        UIView *line = [[UIView alloc] initWithFrame:frame];
        line.backgroundColor = kLVMAlertHUDSeparatorColor;
        [btn addSubview:line];
    }
}

- (UIColor *)_textColorWithAlertAction:(LVMAlertAction *)action {
    return LVMAlertActionColorWithAction(action);
}

- (void)_handleTouchSelect:(UIButton *)sender {
    sender.backgroundColor = kLVMAlertButtonSelectedColor;
}

- (void)_handleTouchCancel:(UIButton *)sender {
    sender.backgroundColor = [UIColor whiteColor];
}

- (void)_handleClickButtonAction:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        sender.backgroundColor = [UIColor whiteColor];
    } completion:nil];
    
    NSInteger index = sender.tag - kLVMAlertButtonCellButtonBaseTag;
    LVMAlertAction *action = _actions[index];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegate &&
            [strongSelf.delegate respondsToSelector:@selector(alertButtonCell:didSelectAction:)]) {
            [strongSelf.delegate alertButtonCell:strongSelf didSelectAction:action];
        }
    });
}

@end
