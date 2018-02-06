//
//  LVMAlertController.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/30.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "LVMAlertController.h"
#import "_LVMAlertController+Private.h"
#import "LVMAlertHUDDefinition.h"
#import "UIView+LVMCornerRadius.h"
#import "LVMAlertCell.h"
#import "LVMAlertButtonCell.h"
#import "LVMAlertHeaderView.h"
#import "LVMAlertPresentationController.h"
#import "LVMAlertTransition.h"

#define DEFAULT_COLOR   [UIColor colorWithWhite:0 alpha:0.3]
#define HIDDEN_COLOR    [UIColor clearColor]

static CGFloat const kLVMAlertControllerActionHeight = 50.0f;
static CGFloat const kLVMAlertControllerCornerRadius = 5.0f;
static CGFloat const kLVMAlertControllerAnimationDuration = 0.3f;
static CGFloat const kLVMAlertControllerFastAnimationDuration = 0.2f;

static CGFloat const kLVMAlertControllerCancelInsert = 2.5f;

static CGFloat const kLVMAlertControllerAlertWidthRatio = 0.7;
static CGFloat const kLVMAlertControllerAlertContrainerRatio = 0.8;
static NSInteger const kLVMAlertControllerAlertTiledLimit = 2;//alert水平按钮个数限制

@interface LVMAlertController ()<UITableViewDelegate, UITableViewDataSource, LVMAlertButtonCellDelegate, UITextFieldDelegate, UIViewControllerTransitioningDelegate>

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
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
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
    CGRect frame = CGRectMake(0, 0, maxWidth, totalHeight);
    self.preferredContentSize = frame.size;
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    containerView.backgroundColor = [UIColor clearColor];
    _containerView = containerView;
    [self.view addSubview:containerView];
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
    
    CGRect frame = CGRectMake(0, 0,
                              maxWidth * kLVMAlertControllerAlertWidthRatio,
                              totalHeight);
    self.preferredContentSize = frame.size;
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    containerView.backgroundColor = [UIColor clearColor];
    _containerView = containerView;
    [self.view addSubview:containerView];
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
    tableView.layer.cornerRadius = kLVMAlertControllerCornerRadius;
    tableView.layer.masksToBounds = YES;
    tableView.separatorColor = kLVMAlertHUDSeparatorColor;
    tableView.bounces = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = kLVMAlertControllerActionHeight;
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

- (void)presentOn:(UIViewController *)presentingVC withCompletion:(void (^)())completion {
  if (self.presentingViewController) { return; }
  UIViewController *topVC = presentingVC ?: [self _stackTopViewController];
  topVC.modalPresentationStyle = UIModalPresentationCurrentContext;
  __weak typeof(topVC) weakTopVC = topVC;
  [topVC presentViewController:self animated:NO completion:^{
    __strong typeof(weakTopVC) strongTopVC = weakTopVC;
    strongTopVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self _showContainerView];
    if (completion) { completion(); }
  }];
}

- (void)showWithCompletion:(void (^)())completion {
  [self presentOn:nil withCompletion:completion];
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
    textField.backgroundColor = [UIColor whiteColor];
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
    [UIView animateWithDuration:kLVMAlertControllerAnimationDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    [UIView animateWithDuration:kLVMAlertControllerFastAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
        self.containerView.transform = CGAffineTransformMakeScale(kLVMAlertControllerAlertContrainerRatio,
                                                                  kLVMAlertControllerAlertContrainerRatio);
    } completion:^(BOOL finished) {
        if (completion) { completion(); }
    }];
    
    [UIView animateWithDuration:kLVMAlertControllerFastAnimationDuration delay:kLVMAlertControllerAnimationDuration - kLVMAlertControllerFastAnimationDuration options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.containerView.alpha = 0;
        self.view.backgroundColor = HIDDEN_COLOR;
    } completion:nil];
}

#pragma mark - Actions

- (void)_cancelAction {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.cancelAction.actionHandler) {
            strongSelf.cancelAction.actionHandler(strongSelf.cancelAction);
        }
    }];
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        if (action.actionHandler) {
            action.actionHandler(action);
        }
    }];
}

#pragma mark - LVMAlertButtonCellDelegate

- (void)alertButtonCell:(LVMAlertButtonCell *)cell didSelectAction:(LVMAlertAction *)action {
    [self dismissViewControllerAnimated:YES completion:^{
        if (action.actionHandler) {
            action.actionHandler(action);
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
    if (LVMAlertControllerStyleAlert == self.preferredStyle) {
        LVMAlertPresentationController *presentationController = [[LVMAlertPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
        return presentationController;
    }
    LVMActionSheetPresentationController *presentationController = [[LVMActionSheetPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    return presentationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if (LVMAlertControllerStyleAlert == self.preferredStyle) {
        LVMAlertTransition *transition = [[LVMAlertTransition alloc] initWithTransitionType:LVMAlertTransitionTypePresent];
        return transition;
    }
    LVMActionSheetTransition *transition = [[LVMActionSheetTransition alloc] initWithTransitionType:LVMAlertTransitionTypePresent];
    return transition;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (LVMAlertControllerStyleAlert == self.self.preferredStyle) {
        LVMAlertTransition *transition = [[LVMAlertTransition alloc] initWithTransitionType:LVMAlertTransitionTypeDismiss];
        return transition;
    }
    LVMActionSheetTransition *transition = [[LVMActionSheetTransition alloc] initWithTransitionType:LVMAlertTransitionTypeDismiss];
    return transition;
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
