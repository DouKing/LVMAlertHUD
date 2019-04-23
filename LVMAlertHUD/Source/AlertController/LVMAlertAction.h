//
//  LVMAlertAction.h
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/30.
//  Copyright © 2016年 douking. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LVMAlertAction;

typedef void(^LVMAlertActionHandler)(LVMAlertAction *action);

typedef NS_ENUM(NSInteger, LVMAlertActionStyle) {
    LVMAlertActionStyleDefault = 0,
    LVMAlertActionStyleCancel,
    LVMAlertActionStyleMessage,
    LVMAlertActionStyleDestructive
};

@interface LVMAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(nullable NSString *)title
                          style:(LVMAlertActionStyle)style
                        handler:(nullable LVMAlertActionHandler)handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, nullable, readonly) LVMAlertActionHandler actionHandler;
@property (nonatomic, readonly) LVMAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;
// When a user click an alert action, the alert controller will be closed automatically.
// Set this property to `YES` will present this behavious. The default value is `NO`.
@property (nonatomic, assign) BOOL presentAutoClose;

@end


NS_ASSUME_NONNULL_END
