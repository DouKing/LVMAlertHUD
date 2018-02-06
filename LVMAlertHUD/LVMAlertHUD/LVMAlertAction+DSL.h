//
//
// LVMAlertAction+DSL.h
// Secoo-iPhone
//
// Created by WuYikai on 2018/1/12.
// Copyright © 2018年 secoo. All rights reserved.
//
	

#import "LVMAlertAction.h"

NS_ASSUME_NONNULL_BEGIN


@interface LVMAlertAction ()

+ (instancetype)action;
@property (nonatomic, copy, readonly) LVMAlertAction *(^useStyle)(LVMAlertActionStyle style);
@property (nonatomic, copy, readonly) LVMAlertAction *(^setupTitle)(NSString *title);
@property (nonatomic, copy, readonly) LVMAlertAction *(^setupEnable)(BOOL enabled);
@property (nonatomic, copy, readonly) LVMAlertAction *(^setupHandler)(LVMAlertActionHandler _Nullable handler);

@end


NS_ASSUME_NONNULL_END
