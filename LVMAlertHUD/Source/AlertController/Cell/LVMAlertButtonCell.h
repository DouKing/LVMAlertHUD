//
//  LVMAlertButtonCell.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/31.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LVMAlertAction, LVMAlertButtonCell;

extern NSString * const kLVMAlertButtonCellId;

@protocol LVMAlertButtonCellDelegate  <NSObject>

- (void)alertButtonCell:(LVMAlertButtonCell *)cell didSelectAction:(LVMAlertAction *)action;

@end

@interface LVMAlertButtonCell : UITableViewCell

@property (nonatomic, weak) id<LVMAlertButtonCellDelegate> delegate;

- (void)setupWithAlertActions:(NSArray<LVMAlertAction *> *)actions;

@end


NS_ASSUME_NONNULL_END