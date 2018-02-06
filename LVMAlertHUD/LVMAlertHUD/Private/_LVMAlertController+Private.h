//
//
// LVMAlertController+Private.h
// Secoo-iPhone
//
// Created by WuYikai on 2018/1/12.
// Copyright © 2018年 secoo. All rights reserved.
//
	

#import "LVMAlertController.h"

@interface LVMAlertController ()
@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertMessage;
@property (nonatomic, copy) UIImage *alertImage;
@property (nonatomic) LVMAlertControllerStyle preferredStyle;
@property (nonatomic, copy) void(^actionHandler)(NSInteger index, LVMAlertAction *action);
@end
