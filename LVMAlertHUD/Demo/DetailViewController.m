//
//  DetailViewController.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/28.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nullable, nonatomic, strong) UITextView *textView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.textView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.textView.frame = self.view.bounds;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
    }
    return _textView;
}

@end
