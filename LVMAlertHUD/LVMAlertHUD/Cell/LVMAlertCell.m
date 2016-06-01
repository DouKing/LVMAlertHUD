//
//  LVMAlertCell.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/30.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "LVMAlertCell.h"
#import "LVMAlertAction.h"

NSString * const kLVMAlertCellId = @"kLVMAlertCellId";

@implementation LVMAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            self.separatorInset = UIEdgeInsetsZero;
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setupWithAlertAction:(LVMAlertAction *)action {
    self.textLabel.text = action.title;
    [self _changeTextColorWithAlertAction:action];
}

- (void)_changeTextColorWithAlertAction:(LVMAlertAction *)action {
    switch (action.style) {
        case LVMAlertActionStyleDefault: {
            self.textLabel.textColor = [UIColor colorWithRed:26 / 255.0 green:25 / 255.0 blue:30 / 255.0 alpha:1];
            break;
        }
        case LVMAlertActionStyleCancel: {
            self.textLabel.textColor = [UIColor blackColor];
            break;
        }
        case LVMAlertActionStyleDestructive: {
            self.textLabel.textColor = [UIColor redColor];
            break;
        }
    }
}

@end
