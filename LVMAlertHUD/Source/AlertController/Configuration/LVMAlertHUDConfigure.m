//
//  LVMAlertHUDConfigure.m
//  Secoo-iPhone
//
//  Created by WuYikai on 16/7/8.
//  Copyright © 2016年 douking. All rights reserved.
//

#import "LVMAlertHUDConfigure.h"
#import "LVMAlertHUDDefinition.h"

UIColor * LVMAlertActionColorWithActionStytle(LVMAlertActionStyle style) {
    switch (style) {
        case LVMAlertActionStyleDefault: {
            return LVMAlertRGBColor(0x1a191e);
            break;
        }
        case LVMAlertActionStyleCancel: {
            return LVMAlertRGBColor(0x1a191e);
            break;
        }
        case LVMAlertActionStyleMessage: {
            return LVMAlertRGBColor(0x333333);
            break;
        }
        case LVMAlertActionStyleDestructive: {
            return LVMAlertRGBColor(0xe93b39);
            break;
        }
    }
}

UIFont  * LVMAlertActionFontWithActionStytle(LVMAlertActionStyle style) {
    switch (style) {
        case LVMAlertActionStyleMessage: {
            return [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            break;
        }
        case LVMAlertActionStyleCancel: {
            return [UIFont boldSystemFontOfSize:15];
            break;
        }
        default: {
            return [UIFont systemFontOfSize:15];
            break;
        }
    }
}

UIColor * LVMAlertActionColorWithAction(LVMAlertAction *action) {
    if (!action.isEnabled) {
        return LVMAlertRGBColor(0xBBBBBB);
    }
    return LVMAlertActionColorWithActionStytle(action.style);
}

UIFont  * LVMAlertActionFontWithAction(LVMAlertAction *action) {
    return LVMAlertActionFontWithActionStytle(action.style);
}

@implementation LVMAlertHUDConfigure

@end
