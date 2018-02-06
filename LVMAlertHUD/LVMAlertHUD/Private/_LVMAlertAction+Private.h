//
//
// LVMAlertAction+Private.h
// Secoo-iPhone
//
// Created by WuYikai on 2018/1/12.
// Copyright © 2018年 secoo. All rights reserved.
//
	

#import "LVMAlertAction.h"

NS_ASSUME_NONNULL_BEGIN


@interface LVMAlertAction ()
@property (nullable, nonatomic) NSString *title;
@property (nonatomic, nullable) LVMAlertActionHandler actionHandler;
@property (nonatomic) LVMAlertActionStyle style;
@end


NS_ASSUME_NONNULL_END
