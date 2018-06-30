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
static CGFloat const kLVMAlertHeaderViewTitleFontSize = 15;
static CGFloat const kLVMAlertHeaderViewMessageFontSize = 14;
static CGFloat const kLVMAlertHeaderViewParagraphSpace = 8;
static CGFloat const kLVMAlertHeaderViewContentInsert  = 26;

NSAttributedString * LVMAlertTitleAttributedStringFor(NSString *title, BOOL strikethroughHeader) {
    if (!title) { return nil; }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = kLVMAlertHeaderViewParagraphSpace;
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:title];
    [attribute addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kLVMAlertHeaderViewTitleFontSize],
                               NSForegroundColorAttributeName : LVMAlertRGBColor(0x1a191e),
                               NSParagraphStyleAttributeName : style,
                               NSStrikethroughColorAttributeName : LVMAlertRGBColor(0x1a191e)}
                       range:NSMakeRange(0, attribute.length)];

    NSDictionary *strikethrough = @{
                                    NSStrikethroughStyleAttributeName: strikethroughHeader ? @(NSUnderlineStyleSingle) : @(NSUnderlineStyleNone),
                                    };
    if (@available(iOS 10.0, *)) {
        strikethrough = @{
                          NSStrikethroughStyleAttributeName: strikethroughHeader ? @(NSUnderlineStyleThick) : @(NSUnderlineStyleNone),
                          NSBaselineOffsetAttributeName : @(NSUnderlineStyleNone),
                          };
    }
    [attribute addAttributes:strikethrough range:NSMakeRange(0, attribute.length)];

    return attribute;
}

NSAttributedString * LVMAlertMessageAttributedStringFor(NSString *message, NSTextAlignment textAlignment) {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:message];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = kLVMAlertHeaderViewParagraphSpace;
    style.lineSpacing = 4;
    style.alignment = textAlignment;
    [text addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:kLVMAlertHeaderViewMessageFontSize],
                          NSParagraphStyleAttributeName : style,
                          NSForegroundColorAttributeName : LVMAlertRGBColor(0x333333)}
                  range:NSMakeRange(0, text.length)];
    return text;
}

static inline NSAttributedString * LVMAlertHeaderAttributeStringFor(NSAttributedString *title, NSAttributedString *message) {
    if (!title && !message) {
        return nil;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if (title) {
        [attributedString appendAttributedString:title];
    }
    if (message) {
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

static inline NSAttributedString * LVMAlertHeaderViewAttributeStringFor(NSString *title, NSString *message, BOOL strikethroughHeader, NSTextAlignment textAlignment) {
    NSAttributedString *titleAttributed = LVMAlertTitleAttributedStringFor(title, strikethroughHeader);
    NSAttributedString *messageAttributed = LVMAlertMessageAttributedStringFor(message, textAlignment);
    return LVMAlertHeaderAttributeStringFor(titleAttributed, messageAttributed);
}

@interface LVMAlertHeaderView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, strong) NSArray<UITextField *> *textFields;

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
                            maxWidth:(CGFloat)maxWidth {
    CGFloat maxHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGSize maxSize = CGSizeMake(maxWidth -
                                kLVMAlertHeaderViewContentInsert * 2,
                                maxHeight);
    CGFloat totalHeight = 0;
    NSAttributedString *attributeString = LVMAlertHeaderAttributeStringFor(attributedTitle, attributedMessage);
    BOOL has = NO;
    if (image) {
        totalHeight += image.size.height;
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
    if (has) {
        totalHeight += kLVMAlertHeaderViewContentInsert * 2;
    }
    return ceilf(totalHeight);
}

- (void)setupWithAttributedTitle:(NSAttributedString *)attributedTitle
               attributedMessage:(NSAttributedString *)attributedMessage
                           image:(UIImage *)image
                      textFields:(NSArray<UITextField *> *)textFields {
    self.textFields = textFields;
    NSAttributedString *attributeString = LVMAlertHeaderAttributeStringFor(attributedTitle, attributedMessage);
    self.titleLabel.attributedText = attributeString;
    self.imageView.image = image;
    [self _removeTextFields];
    [self _addTextFields:textFields];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxWidth = CGRectGetWidth(self.contentView.bounds);
    CGFloat maxHeight = CGRectGetHeight(self.contentView.bounds);
    CGFloat height = ceilf(self.imageView.image.size.height);
    CGRect frame = CGRectMake(kLVMAlertHeaderViewContentInsert, kLVMAlertHeaderViewContentInsert,
                              maxWidth - kLVMAlertHeaderViewContentInsert * 2, height);
    self.imageView.frame = frame;
    UIView *lastView = self.imageView;
    
    if (CGRectGetHeight(lastView.frame) > 0) {
        frame.origin.y = CGRectGetMaxY(lastView.frame) + kLVMAlertHeaderViewVerticalInsert;
    }
    frame.size.height = LVMAttributeStringHeightFor(self.titleLabel.attributedText,
                                                    CGSizeMake(maxWidth - kLVMAlertHeaderViewContentInsert * 2,
                                                               maxHeight));
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
    
    frame = CGRectMake(0, maxHeight - kLVMSingleLineWidth, maxWidth, kLVMSingleLineWidth);
    self.lineView.frame = frame;
}

- (void)_setupSubViews {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    _titleLabel = label;
    [self.contentView addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.clipsToBounds = YES;
    _imageView = imageView;
    [self.contentView addSubview:imageView];
    
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

@implementation LVMAlertHeaderView (Deprecated)

- (void)setupWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image textFields:(NSArray<UITextField *> *)textFields textAlignment:(NSTextAlignment)textAlignment {
    self.textFields = textFields;
    NSAttributedString *attributeString = LVMAlertHeaderViewAttributeStringFor(title, message, self.strikethroughHeader, textAlignment);
    self.titleLabel.attributedText = attributeString;
    self.imageView.image = image;
    [self _removeTextFields];
    [self _addTextFields:textFields];
}

+ (CGFloat)heightWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image textFields:(NSArray<UITextField *> *)textFields maxWidth:(CGFloat)maxWidth textAlignment:(NSTextAlignment)textAlignment {
    CGFloat maxHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGSize maxSize = CGSizeMake(maxWidth -
                                kLVMAlertHeaderViewContentInsert * 2,
                                maxHeight);
    CGFloat totalHeight = 0;
    NSAttributedString *attributeString = LVMAlertHeaderViewAttributeStringFor(title, message, NO, textAlignment);
    BOOL has = NO;
    if (image) {
        totalHeight += image.size.height;
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
    if (has) {
        totalHeight += kLVMAlertHeaderViewContentInsert * 2;
    }
    return ceilf(totalHeight);
}

@end

