//
//  LVMAlertHUDConfigure.h
//  Secoo-iPhone
//
//  Created by WuYikai on 16/7/8.
//  Copyright © 2016年 douking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LVMAlertAction.h"

FOUNDATION_EXPORT UIColor * LVMAlertActionColorWithActionStytle(LVMAlertActionStyle style);
FOUNDATION_EXPORT UIFont  * LVMAlertActionFontWithActionStytle(LVMAlertActionStyle style);

FOUNDATION_EXPORT UIColor * LVMAlertActionColorWithAction(LVMAlertAction *action);
FOUNDATION_EXPORT UIFont  * LVMAlertActionFontWithAction(LVMAlertAction *action);

@interface LVMAlertHUDConfigure : NSObject
@end
