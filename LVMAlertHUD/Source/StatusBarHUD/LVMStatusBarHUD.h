//
//  LVMStatusBarHUD.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/27.
//  Copyright © 2016年 douking. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LVMStatusBarHUDAnimationHandler)();

/**
 *  提醒类型
 */
typedef NS_ENUM(NSInteger, LVMStatusBarHUDType) {
    /**
     *  无类型，只展示文字
     */
    LVMStatusBarHUDTypeNone,
    /**
     *  警告
     */
    LVMStatusBarHUDTypeWarning,
    /**
     *  错误
     */
    LVMStatusBarHUDTypeError,
    /**
     *  成功
     */
    LVMStatusBarHUDTypeSuccess
};

/// 显示在屏幕最前端，覆盖导航条
@interface LVMStatusBarHUD : UIView

+ (instancetype)showWithMessage:(NSString *)message completion:(__nullable LVMStatusBarHUDAnimationHandler)completion;
+ (instancetype)showWithMessage:(NSString *)message
                           type:(LVMStatusBarHUDType)type
                     completion:(__nullable LVMStatusBarHUDAnimationHandler)completion;

@end


NS_ASSUME_NONNULL_END
