//
//
// LVMAlertAction+Private.h
// Secoo-iPhone
//
// Created by WuYikai on 2018/1/12.
// Copyright © 2018年 douking. All rights reserved.
//
	

#import "LVMAlertAction.h"

NS_ASSUME_NONNULL_BEGIN
@class LVMAlertCell, UIButton;

@interface LVMAlertAction ()
@property (nullable, nonatomic) NSString *title;
@property (nonatomic, nullable) LVMAlertActionHandler actionHandler;
@property (nonatomic) LVMAlertActionStyle style;
@property (nullable, nonatomic, weak) LVMAlertCell *associatedCell;
@property (nullable, nonatomic, weak) UIButton *associatedButton;
@end


NS_ASSUME_NONNULL_END
