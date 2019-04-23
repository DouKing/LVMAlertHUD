//
//  LVMAlertCell.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/30.
//  Copyright © 2016年 douking. All rights reserved.
//

#import "LVMAlertCell.h"
#import "LVMAlertAction.h"
#import "LVMAlertHUDDefinition.h"
#import "LVMAlertHUDConfigure.h"
#import "_LVMAlertAction+Private.h"

NSString * const kLVMAlertCellId = @"kLVMAlertCellId";

@implementation LVMAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = kLVMAlertButtonSelectedColor;
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            self.separatorInset = UIEdgeInsetsZero;
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setupWithAlertAction:(LVMAlertAction *)action {
    action.associatedCell = self;
    self.textLabel.text = action.title;
    [self _changeTextColorWithAlertAction:action];
}

- (void)_changeTextColorWithAlertAction:(LVMAlertAction *)action {
    self.textLabel.textColor = LVMAlertActionColorWithAction(action);
    self.textLabel.font = LVMAlertActionFontWithAction(action);
    self.userInteractionEnabled = action.isEnabled;
}

@end
