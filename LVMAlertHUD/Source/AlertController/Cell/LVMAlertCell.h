//
//  LVMAlertCell.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/30.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LVMAlertAction;

extern NSString * const kLVMAlertCellId;

@interface LVMAlertCell : UITableViewCell

- (void)setupWithAlertAction:(LVMAlertAction *)action;

@end

@interface LVMAlertCell (Private)
- (void)_changeTextColorWithAlertAction:(LVMAlertAction *)action;
@end
