//
//  LVMAlertController.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/30.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "LVMAlertController.h"
#import "LVMAlertHUDDefinition.h"
#import "UIView+LVMCornerRadius.h"
#import "LVMAlertCell.h"
#import "LVMAlertButtonCell.h"
#import "LVMAlertHeaderView.h"

#define DEFAULT_COLOR   [UIColor colorWithWhite:0 alpha:0.3]
#define HIDDEN_COLOR    [UIColor clearColor]

static CGFloat const kLVMAlertControllerActionHeight = 44.0f;
static CGFloat const kLVMAlertControllerCornerRadius = 5.0f;
static CGFloat const kLVMAlertControllerAnimationDuration = 0.3f;

static CGFloat const kLVMAlertControllerCancelInsert = 2.5f;

static CGFloat const kLVMAlertControllerAlertWidthRatio = 0.8;
static NSInteger const kLVMAlertControllerAlertTiledLimit = 2;//alert水平按钮个数限制

@interface LVMAlertController ()<UITableViewDelegate, UITableViewDataSource, LVMAlertButtonCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray<LVMAlertAction *> *userActions;
@property (nonatomic, strong) LVMAlertAction *cancelAction;

@property (nonatomic, weak) UIView *containerView;

@end

@implementation LVMAlertController

#pragma mark - Life cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(LVMAlertControllerStyle)preferredStyle {
    return [self alertControllerWithTitle:title message:message image:nil preferredStyle:preferredStyle];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image preferredStyle:(LVMAlertControllerStyle)preferredStyle {
    return [[self alloc] initWithTitle:title message:message image:image preferredStyle:preferredStyle];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image preferredStyle:(LVMAlertControllerStyle)preferredStyle {
    self = [super init];
    if (self) {
        if (IOS_8_LATER) {
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        _alertTitle = [title copy];
        _alertMessage = [message copy];
        _alertImage = [image copy];
        _preferredStyle = preferredStyle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
}

#pragma mark - SubViews

- (void)_setupSubViews {
    switch (self.preferredStyle) {
        case LVMAlertControllerStyleActionSheet: {
            [self _setupContainerViewForActionSheet];
            [self _setupCancelButtonForActionSheet];
            [self _setupTableView];
            break;
        }
        case LVMAlertControllerStyleAlert: {
            [self _setupContainerViewForAlert];
            [self _setupTableView];
            [self _addObserver];
            break;
        }
    }
}

- (void)_setupContainerViewForActionSheet {
    CGFloat maxHeight = CGRectGetHeight(self.view.bounds);
    CGFloat maxWidth = CGRectGetWidth(self.view.bounds);
    CGFloat totalHeight = self.userActions.count * kLVMAlertControllerActionHeight;
    totalHeight += [LVMAlertHeaderView heightWithTitle:self.alertTitle message:self.alertMessage image:self.alertImage textFields:self.textFields maxWidth:maxWidth];
    if (self.cancelAction) {
        totalHeight += kLVMAlertControllerActionHeight + kLVMAlertControllerCancelInsert;
    }
    if (totalHeight > maxHeight) {
        totalHeight = maxHeight;
    }
    CGRect frame = CGRectMake(0, maxHeight - totalHeight, maxWidth, totalHeight);
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    containerView.backgroundColor = [UIColor clearColor];
    _containerView = containerView;
    [self.view addSubview:containerView];
    containerView.transform = CGAffineTransformMakeTranslation(0, totalHeight);
}

- (void)_setupContainerViewForAlert {
    CGFloat maxWidth = CGRectGetWidth(self.view.bounds);
    CGFloat maxHeight = CGRectGetHeight(self.view.bounds);
    CGFloat count = self.actions.count;
    if (kLVMAlertControllerAlertTiledLimit == count) { count = 1; }
    CGFloat totalHeight = count * kLVMAlertControllerActionHeight;
    totalHeight += [LVMAlertHeaderView heightWithTitle:self.alertTitle message:self.alertMessage image:self.alertImage textFields:self.textFields maxWidth:maxWidth * kLVMAlertControllerAlertWidthRatio];
    if (totalHeight > maxHeight) {
        totalHeight = maxHeight;
    }
    
    CGRect frame = CGRectMake((1 - kLVMAlertControllerAlertWidthRatio) / 2.0 * maxWidth,
                              0.5 * (maxHeight - totalHeight),
                              maxWidth * kLVMAlertControllerAlertWidthRatio,
                              totalHeight);
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    containerView.backgroundColor = [UIColor clearColor];
    _containerView = containerView;
    [self.view addSubview:containerView];
    
    containerView.alpha = 0;
    containerView.transform = CGAffineTransformMakeScale(0.5, 0.5);
}

- (void)_setupCancelButtonForActionSheet {
    if (!self.cancelAction) { return; }
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.containerView.bounds) - kLVMAlertControllerActionHeight,
                              CGRectGetWidth(self.containerView.bounds), kLVMAlertControllerActionHeight);
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = frame;
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn lvm_setCornerRadii:CGSizeMake(kLVMAlertControllerCornerRadius, kLVMAlertControllerCornerRadius)
               forRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    [cancelBtn setTitle:self.cancelAction.title forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(_handleCancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:cancelBtn];
}

- (void)_setupTableView {
    CGFloat height = CGRectGetHeight(self.containerView.bounds);
    if (self.cancelAction &&
        LVMAlertControllerStyleActionSheet == self.preferredStyle) {
        height -= kLVMAlertControllerActionHeight + kLVMAlertControllerCancelInsert;
    }
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), height);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.96];
    tableView.layer.cornerRadius = kLVMAlertControllerCornerRadius;
    tableView.layer.masksToBounds = YES;
    tableView.separatorColor = kLVMAlertHUDSeparatorColor;
    tableView.bounces = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = [LVMAlertHeaderView heightWithTitle:self.alertTitle message:self.alertMessage image:self.alertImage textFields:self.textFields maxWidth:CGRectGetWidth(self.containerView.bounds)];
    [tableView registerClass:[LVMAlertCell class] forCellReuseIdentifier:kLVMAlertCellId];
    [tableView registerClass:[LVMAlertHeaderView class] forHeaderFooterViewReuseIdentifier:kLVMAlertHeaderViewId];
    if (LVMAlertControllerStyleAlert == self.preferredStyle) {
        [tableView registerClass:[LVMAlertButtonCell class] forCellReuseIdentifier:kLVMAlertButtonCellId];
    }
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.containerView addSubview:tableView];
}

- (void)_addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(_keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(_keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];

}

#pragma mark - Public Methods

- (void)showWithCompletion:(void (^)())completion {
    if (self.presentingViewController) { return; }
    UIViewController *topVC = [self _stackTopViewController];
    if (!IOS_8_LATER) {
        topVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    __weak typeof(topVC) weakTopVC = topVC;
    [topVC presentViewController:self animated:NO completion:^{
        if (!IOS_8_LATER) {
            __strong typeof(weakTopVC) strongTopVC = weakTopVC;
            strongTopVC.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        [self _showContainerView];
        if (completion) { completion(); }
    }];
}

- (void)dismissWithCompletion:(void (^)())completion {
    [self _dismissContainerViewWithCompletion:^{
        [self dismissViewControllerAnimated:NO completion:^{
            if (completion) { completion(); }
        }];
    }];
}

- (void)addAction:(LVMAlertAction *)action {
    if (!action) { return; }
    if (LVMAlertActionStyleCancel == action.style) {
        self.cancelAction = action;
        return;
    }
    NSMutableArray<LVMAlertAction *> *tempActions = [NSMutableArray arrayWithArray:self.userActions];
    [tempActions addObject:action];
    self.userActions = [NSArray arrayWithArray:tempActions];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler {
    NSAssert(LVMAlertControllerStyleAlert == self.preferredStyle, @"该方法只由于LVMAlertControllerStyleAlert");
    NSMutableArray<UITextField *> *tempTextFields = [NSMutableArray arrayWithArray:self.textFields];
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:14];
    textField.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    textField.delegate = self;
    [tempTextFields addObject:textField];
    _textFields = [NSArray arrayWithArray:tempTextFields];
    if (configurationHandler) {
        configurationHandler(textField);
    }
}

#pragma mark - Private Methods -

- (void)_showContainerView {
    switch (self.preferredStyle) {
        case LVMAlertControllerStyleActionSheet: {
            [self _showContainerViewForActionSheet];
            break;
        }
        case LVMAlertControllerStyleAlert: {
            [self _showContainerViewForAlert];
            break;
        }
    }
}

- (void)_dismissContainerViewWithCompletion:(void (^)())completion {
    switch (self.preferredStyle) {
        case LVMAlertControllerStyleActionSheet: {
            [self _dismissContainerViewForActionSheetWithCompletion:completion];
            break;
        }
        case LVMAlertControllerStyleAlert: {
            [self _dismissContainerViewForAlertWithCompletion:completion];
            break;
        }
    }
}

- (void)_showContainerViewForActionSheet {
    [UIView animateWithDuration:kLVMAlertControllerAnimationDuration animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
        self.view.backgroundColor = DEFAULT_COLOR;
    } completion:nil];
}

- (void)_showContainerViewForAlert {
    [UIView animateWithDuration:kLVMAlertControllerAnimationDuration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
        self.containerView.alpha = 1;
        self.view.backgroundColor = DEFAULT_COLOR;
    } completion:nil];
}

- (void)_dismissContainerViewForActionSheetWithCompletion:(void (^)())completion {
    [UIView animateWithDuration:kLVMAlertControllerAnimationDuration animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.containerView.bounds));
        self.view.backgroundColor = HIDDEN_COLOR;
    } completion:^(BOOL finished) {
        if (completion) { completion(); }
    }];
}

- (void)_dismissContainerViewForAlertWithCompletion:(void (^)())completion {
    [UIView animateWithDuration:kLVMAlertControllerAnimationDuration animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.containerView.alpha = 0;
        self.view.backgroundColor = HIDDEN_COLOR;
    } completion:^(BOOL finished) {
        if (completion) { completion(); }
    }];
}

#pragma mark - Actions

- (void)_cancelAction {
    if (self.cancelAction.actionHandler) {
        self.cancelAction.actionHandler(self.cancelAction);
    }
    [self dismissWithCompletion:nil];
}

- (void)_handleCancelButtonAction:(UIButton *)sender {
    [self _cancelAction];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (LVMAlertControllerStyleAlert == self.preferredStyle) {
        return;
    }
    [self _cancelAction];
}

#pragma mark - Helper
- (UIViewController *)_stackTopViewController {
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIViewController *topVC = rootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

#pragma mark - setter & getter

- (NSArray<LVMAlertAction *> *)actions {
    NSMutableArray *tempActions = [NSMutableArray arrayWithArray:self.userActions];
    if (self.cancelAction) {
        [tempActions addObject:self.cancelAction];
    }
    return [NSArray arrayWithArray:tempActions];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (LVMAlertControllerStyleAlert == self.preferredStyle) {
        NSInteger count = [self.actions count];
        if (kLVMAlertControllerAlertTiledLimit == count) {
            return 1;
        }
        return count;
    }
    return [self.userActions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (LVMAlertControllerStyleActionSheet == self.preferredStyle) {
        LVMAlertAction *action = self.userActions[indexPath.row];
        LVMAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:kLVMAlertCellId forIndexPath:indexPath];
        [cell setupWithAlertAction:action];
        return cell;
    }
    
    if (kLVMAlertControllerAlertTiledLimit == self.actions.count) {
        LVMAlertButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kLVMAlertButtonCellId forIndexPath:indexPath];
        cell.delegate = self;
        [cell setupWithAlertActions:self.actions];
        return cell;
    }
    LVMAlertAction *action = self.actions[indexPath.row];
    LVMAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:kLVMAlertCellId forIndexPath:indexPath];
    [cell setupWithAlertAction:action];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LVMAlertHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kLVMAlertHeaderViewId];
    [headerView setupWithTitle:self.alertTitle message:self.alertMessage image:self.alertImage textFields:self.textFields];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LVMAlertAction *action = nil;
    if (LVMAlertControllerStyleAlert == self.preferredStyle) {
        if (kLVMAlertControllerAlertTiledLimit != self.actions.count) {
            action = self.actions[indexPath.row];
        }
    } else {
        action = self.userActions[indexPath.row];
    }
    
    if (action.actionHandler) {
        action.actionHandler(action);
    }
    [self dismissWithCompletion:nil];
}

#pragma mark - LVMAlertButtonCellDelegate

- (void)alertButtonCell:(LVMAlertButtonCell *)cell didSelectAction:(LVMAlertAction *)action {
    if (action.actionHandler) {
        action.actionHandler(action);
    }
    [self dismissWithCompletion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 

- (void)_keyboardWillShow:(NSNotification *)note {
    CGRect keyboardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    CGFloat blankHeight = CGRectGetHeight(self.view.bounds) - keyboardHeight;
    CGFloat translationY = 0.5 * blankHeight - self.containerView.center.y;
    if (translationY > 0) { translationY = 0; }
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, translationY);
    }];
}

- (void)_keyboardWillHide:(NSNotification *)note {
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

@end
