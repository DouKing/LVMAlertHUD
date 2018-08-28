//
//  LVMAlertHeaderView.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/31.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "LVMAlertHeaderView.h"
#import "LVMAlertHUDDefinition.h"

NSString * const kLVMAlertHeaderViewId = @"kLVMAlertHeaderViewId";

static CGFloat const kLVMAlertHeaderViewTextFieldHeight = 35;
static CGFloat const kLVMAlertHeaderViewVerticalInsert = 10;
static CGFloat const kLVMAlertHeaderViewContentInsert  = 26;

static inline NSAttributedString * LVMAlertHeaderAttributeStringFor(NSAttributedString *title, NSAttributedString *message) {
    if (!title && !message) {
        return nil;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if (title) {
        [attributedString appendAttributedString:title];
    }
    if (message.length) {
        if (title.length) {
            NSAttributedString *enter = [[NSAttributedString alloc] initWithString:@"\n" attributes:[message attributesAtIndex:0 effectiveRange:nil]];
            [attributedString appendAttributedString:enter];
        }
        [attributedString appendAttributedString:message];
    }
    return attributedString;
}

static inline CGFloat LVMAttributeStringHeightFor(NSAttributedString *attributeString, CGSize size) {
    CGFloat height = [attributeString boundingRectWithSize:size
                                                   options:NSStringDrawingUsesFontLeading |
                                                           NSStringDrawingUsesLineFragmentOrigin |
                                                           NSStringDrawingTruncatesLastVisibleLine
                                                   context:nil].size.height;
    return ceilf(height);
}

@interface LVMAlertHeaderView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, strong) NSArray<UITextField *> *textFields;
@property (nonatomic, weak) UIView *customView;
@property (nullable, nonatomic, weak) UIViewController *contentVC;

@end

@implementation LVMAlertHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self _setupSubViews];
    }
    return self;
}

+ (CGFloat)heightWithAttributedTitle:(NSAttributedString *)attributedTitle
                   attributedMessage:(NSAttributedString *)attributedMessage
                               image:(UIImage *)image
                          textFields:(NSArray<UITextField *> *)textFields
               contentViewController:(UIViewController *)contentVC
                            maxWidth:(CGFloat)maxWidth {
    CGFloat maxHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    maxWidth = maxWidth - kLVMAlertHeaderViewContentInsert * 2;
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
    CGFloat totalHeight = 0;
    NSAttributedString *attributeString = LVMAlertHeaderAttributeStringFor(attributedTitle, attributedMessage);
    BOOL has = NO;
    if (image) {
        totalHeight += image.size.height / image.size.width * maxWidth;
        has = YES;
    }
    if (attributeString.length) {
        if (has) { totalHeight += kLVMAlertHeaderViewVerticalInsert; }
        has = YES;
        totalHeight += LVMAttributeStringHeightFor(attributeString, maxSize);
    }
    if (textFields.count) {
        if (has) { totalHeight += kLVMAlertHeaderViewVerticalInsert; }
        has = YES;
        totalHeight += textFields.count * kLVMAlertHeaderViewTextFieldHeight;
        totalHeight += (textFields.count - 1) * kLVMAlertHeaderViewVerticalInsert;
    }
    if (contentVC) {
        if (has) { totalHeight += kLVMAlertHeaderViewVerticalInsert; }
        has = YES;
        totalHeight += contentVC.preferredContentSize.height;
    }
    if (has) {
        totalHeight += kLVMAlertHeaderViewContentInsert * 2;
    }
    return ceilf(totalHeight);
}

- (void)setupWithAttributedTitle:(NSAttributedString *)attributedTitle
               attributedMessage:(NSAttributedString *)attributedMessage
                           image:(UIImage *)image
                      textFields:(NSArray<UITextField *> *)textFields
           contentViewController:(UIViewController *)contentVC {
    self.contentVC = contentVC;
    self.textFields = textFields;
    NSAttributedString *attributeString = LVMAlertHeaderAttributeStringFor(attributedTitle, attributedMessage);
    self.titleLabel.attributedText = attributeString;
    self.imageView.image = image;
    [self _removeTextFields];
    [self _addTextFields:textFields];

    [self.customView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (contentVC) {
        [self.customView addSubview:contentVC.view];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxWidth = CGRectGetWidth(self.contentView.bounds);
    CGFloat maxHeight = CGRectGetHeight(self.contentView.bounds);
    CGFloat contentWidth = maxWidth - kLVMAlertHeaderViewContentInsert * 2;
    UIImage *image = self.imageView.image;
    CGFloat height = image ? image.size.height / image.size.width * contentWidth : 0;
    CGRect frame = CGRectMake(kLVMAlertHeaderViewContentInsert, kLVMAlertHeaderViewContentInsert, contentWidth, height);
    self.imageView.frame = frame;
    UIView *lastView = self.imageView;
    
    if (CGRectGetHeight(lastView.frame) > 0) {
        frame.origin.y = CGRectGetMaxY(lastView.frame) + kLVMAlertHeaderViewVerticalInsert;
    }
    frame.size.height = LVMAttributeStringHeightFor(self.titleLabel.attributedText, CGSizeMake(contentWidth, maxHeight));
    self.titleLabel.frame = frame;
    lastView = self.titleLabel;
    
    for (NSInteger i = 0; i < self.textFields.count; ++i) {
        if (CGRectGetHeight(lastView.frame) > 0) {
            frame.origin.y = floorf(CGRectGetMaxY(lastView.frame) + kLVMAlertHeaderViewVerticalInsert);
        }
        frame.size.height = kLVMAlertHeaderViewTextFieldHeight;
        UITextField *textField = self.textFields[i];
        textField.frame = frame;
        lastView = textField;
    }

    if (_contentVC && CGRectGetHeight(lastView.frame) > 0) {
        frame.origin.y = CGRectGetMaxY(lastView.frame) + kLVMAlertHeaderViewVerticalInsert;
    }
    frame.size.height = _contentVC.preferredContentSize.height;
    self.customView.frame = frame;
    self.contentVC.view.frame = self.customView.bounds;

    frame = CGRectMake(0, maxHeight - kLVMSingleLineWidth, maxWidth, kLVMSingleLineWidth);
    self.lineView.frame = frame;
}

- (void)_setupSubViews {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    _titleLabel = label;
    [self.contentView addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    _imageView = imageView;
    [self.contentView addSubview:imageView];

    UIView *customView = [[UIView alloc] init];
    _customView = customView;
    [self.contentView addSubview:customView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLVMAlertHUDSeparatorColor;
    _lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)_removeTextFields {
    for (UIView *subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView removeFromSuperview];
        }
    }
}

- (void)_addTextFields:(NSArray<UITextField *> *)textFields {
    for (UITextField *textField in textFields) {
        [self.contentView addSubview:textField];
    }
}

@end
