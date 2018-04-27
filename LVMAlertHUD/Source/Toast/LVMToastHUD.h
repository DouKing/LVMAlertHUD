//
//  LVMToastHUD.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/6/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVMToastHUD : UIView

/**
 *  弱提示，一个view最多有一个toast
 *
 *  @param message 提示信息，最多显示一行
 *  @param view    承载该控件的视图
 */
+ (void)showMessage:(NSString *)message toView:(UIView *)view;

@end
