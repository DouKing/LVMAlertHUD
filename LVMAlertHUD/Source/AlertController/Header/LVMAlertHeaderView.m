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
static CGFloat const kLVMAlertHeaderViewTitleFontSize = 18;
static CGFloat const kLVMAlertHeaderViewMessageFontSize = 16;
static CGFloat const kLVMAlertHeaderViewParagraphSpace = 5;
static CGFloat const kLVMAlertHeaderViewContentInsert  = 20;

static inline NSAttributedString * LVMAlertHeaderViewAttributeStringFor(NSString *title, NSString *message) {
    title = title ?: @"";
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:title];
    [attribute addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:kLVMAlertHeaderViewTitleFontSize],
                               NSForegroundColorAttributeName : [UIColor blackColor]}
                       range:NSMakeRange(0, attribute.length)];
    
    if (message.length) {
        if (attribute.length) {
            message = [@"\n" stringByAppendingString:message];
        }
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:message];
        [text addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kLVMAlertHeaderViewMessageFontSize],
                              NSForegroundColorAttributeName : [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1]}
                      range:NSMakeRange(0, text.length)];
        [attribute appendAttributedString:text];
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = kLVMAlertHeaderViewParagraphSpace;
    style.alignment = NSTextAlignmentCenter;
    
    [attribute addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attribute.length)];
    return [[NSAttributedString alloc] initWithAttributedString:attribute];
}

static inline CGFloat LVMAttributeStringHeightFor(NSAttributedString *attributeString, CGSize size) {
    CGFloat height = [attributeString boundingRectWithSize:size
                                                   options:NSStringDrawingUsesFontLeading |
                                                           NSStringDrawingUsesLineFragmentOrigin |
                                                           NSStringDrawingTruncatesLastVisibleLine
                                                   context:nil].size.height;
    return height;
}

@interface LVMAlertHeaderView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, strong) NSArray<UITextField *> *textFields;

@end

@implementation LVMAlertHeaderView

+ (CGFloat)heightWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image textFields:(NSArray<UITextField *> *)textFields maxWidth:(CGFloat)maxWidth {
    CGFloat maxHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat totalHeight = 0;
    NSAttributedString *attributeString = LVMAlertHeaderViewAttributeStringFor(title, message);
    BOOL has = NO;
    if (image) {
        totalHeight += image.size.height;
        has = YES;
    }
    if (attributeString.length) {
        if (has) { totalHeight += kLVMAlertHeaderViewVerticalInsert; }
        has = YES;
        totalHeight += LVMAttributeStringHeightFor(attributeString, CGSizeMake(maxWidth -
                                                                               kLVMAlertHeaderViewContentInsert * 2,
                                                                               maxHeight));
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
    return totalHeight;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self _setupSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxWidth = CGRectGetWidth(self.contentView.bounds);
    CGFloat maxHeight = CGRectGetHeight(self.contentView.bounds);
    CGFloat height = self.imageView.image.size.height;
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
            frame.origin.y = CGRectGetMaxY(lastView.frame) + kLVMAlertHeaderViewVerticalInsert;
        }
        frame.size.height = kLVMAlertHeaderViewTextFieldHeight;
        UITextField *textField = self.textFields[i];
        textField.frame = frame;
        lastView = textField;
    }
    
    frame = CGRectMake(0, maxHeight - kLVMSingleLineWidth, maxWidth, kLVMSingleLineWidth);
    self.lineView.frame = frame;
}

- (void)setupWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image textFields:(NSArray<UITextField *> *)textFields {
    self.textFields = textFields;
    NSAttributedString *attributeString = LVMAlertHeaderViewAttributeStringFor(title, message);
    self.titleLabel.attributedText = attributeString;
    self.imageView.image = image;
    [self _removeTextFields];
    [self _addTextFields:textFields];
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
