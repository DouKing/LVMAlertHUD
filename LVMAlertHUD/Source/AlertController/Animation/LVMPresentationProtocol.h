
//
//  LVMPresentationProtocol.h
//  Secoo-iPhone
//
//  Created by WuYikai on 2017/1/20.
//  Copyright © 2017年 douking. All rights reserved.
//

#ifndef LVMPresentationProtocol_h
#define LVMPresentationProtocol_h

@protocol LVMPresentationProtocol <NSObject>

- (void)presentedViewControllerShouldDismiss:(__kindof UIViewController *)presentedVC
                                        from:(__kindof UIViewController *)presentingVC
                                  completion:(void (^)())completion;

@end

#endif /* LVMPresentationProtocol_h */
