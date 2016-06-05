//
//  MainViewController.m
//  LVMAlertHUD
//
//  Created by WuYikai on 16/5/27.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "LVMStatusBarHUD.h"
#import "LVMToastHUD.h"
#import "LVMAlertController.h"
#import "LVMAlertController+Convenient.h"

static NSString * const kMainViewControllerCellId = @"kMainViewControllerCellId";

@interface MainViewController ()

@property (nonatomic, strong) NSArray<NSString *> *dataSource;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@"下一级", @"导航条提示", @"Alert", @"ActionSheet", @"Toast", @"Alert Convenience", @"ActionSheet Convenience", @"Alert NO Title"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMainViewControllerCellId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMainViewControllerCellId forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            DetailViewController *vc = [[DetailViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
         
        case 1: {
            [self _showStatusBarHUD];
            break;
        }
            
        case 2: {
            [self _showAlert];
            break;
        }
            
        case 3: {
            [self _showActionSheet];
            break;
        }
        
        case 4: {
            [self _showToastHUD];
            break;
        }
            
        case 5: {
            [self _alertConvenience];
            break;
        }
            
        case 6: {
            [self _actionSheetConvenience];
            break;
        }
        
        case 7: {
            [self _alertNOTitle];
            break;
        }
        
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)_showStatusBarHUD {
    NSString *text = [NSString stringWithFormat:@"message %d", arc4random()];
    [LVMStatusBarHUD showWithMessage:text completion:^{
        NSLog(@"啊啊啊啊啊啊啊啊啊啊");
    }];
}

- (void)_showAlert {
    LVMAlertController *alertController = [LVMAlertController alertControllerWithTitle:@"测试" message:@"这是一个测试信息" image:[UIImage imageNamed:@"secoo_logo"] preferredStyle:LVMAlertControllerStyleAlert];
    LVMAlertAction *action = [LVMAlertAction actionWithTitle:@"呵呵" style:LVMAlertActionStyleDefault handler:^(LVMAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action];
    action = [LVMAlertAction actionWithTitle:@"嘿嘿" style:LVMAlertActionStyleDefault handler:^(LVMAlertAction * _Nonnull action) {
        NSLog(@"%@", action.title);
    }];
    [alertController addAction:action];
    action = [LVMAlertAction actionWithTitle:@"哈哈" style:LVMAlertActionStyleDestructive handler:^(LVMAlertAction * _Nonnull action) {
        NSLog(@"%@", action.title);
    }];
    [alertController addAction:action];
    action = [LVMAlertAction actionWithTitle:@"嘻嘻" style:LVMAlertActionStyleCancel handler:^(LVMAlertAction * _Nonnull action) {
        NSLog(@"%@", action.title);
    }];
    [alertController addAction:action];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"这是输入框";
    }];
    
    [alertController showWithCompletion:nil];
}

- (void)_showActionSheet {
    LVMAlertController *alertController = [LVMAlertController alertControllerWithTitle:@"测试测试测试测试测试测试测试测试测试测试测试测试测" message:@"这是一个测试信息这是一个测试信息这是一个测试信息这是一个测试信息这是一个测试信息这是一个测试信息这是一个测试信息这是一个测试信息这是一个测试信息" image:[UIImage imageNamed:@"secoo_logo"] preferredStyle:LVMAlertControllerStyleActionSheet];
    LVMAlertAction *action = [LVMAlertAction actionWithTitle:@"呵呵" style:LVMAlertActionStyleDefault handler:^(LVMAlertAction * _Nonnull action) {
        NSLog(@"%@", action.title);
    }];
    [alertController addAction:action];
    action = [LVMAlertAction actionWithTitle:@"嘿嘿" style:LVMAlertActionStyleDefault handler:^(LVMAlertAction * _Nonnull action) {
        NSLog(@"%@", action.title);
    }];
    [alertController addAction:action];
    action = [LVMAlertAction actionWithTitle:@"哈哈" style:LVMAlertActionStyleDestructive handler:^(LVMAlertAction * _Nonnull action) {
        NSLog(@"%@", action.title);
    }];
    [alertController addAction:action];
    action = [LVMAlertAction actionWithTitle:@"嘻嘻" style:LVMAlertActionStyleCancel handler:^(LVMAlertAction * _Nonnull action) {
        NSLog(@"%@", action.title);
    }];
    [alertController addAction:action];
    [alertController showWithCompletion:nil];
}

- (void)_showToastHUD {
    NSInteger i = arc4random() % 2;
    NSString *message = (0 == i) ? @"提示信息" : @"提示信息提示信息提示信息提示信息提示信息提示";
    [LVMToastHUD showMessage:message toView:self.view];
}

- (void)_alertConvenience {
    LVMAlertController *alertController = [LVMAlertController alertWithTitle:@"Title" message:@"Message" preferredStyle:LVMAlertControllerStyleAlert actionHandler:^(NSInteger index) {
        if (0 == index) {
            NSLog(@"Convenience 确定");
        } else if (1 == index) {
            NSLog(@"Convenience 取消");
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertController showWithCompletion:nil];
}

- (void)_actionSheetConvenience {
    LVMAlertController *alertController = [LVMAlertController alertWithTitle:@"Title" message:@"Message" preferredStyle:LVMAlertControllerStyleActionSheet actionHandler:^(NSInteger index) {
        if (0 == index) {
            NSLog(@"Convenience 神秘");
        } else if (1 == index) {
            NSLog(@"Convenience 男");
        } else if (2 == index) {
            NSLog(@"Convenience 女");
        } else if (3 == index) {
            NSLog(@"Convenience 取消");
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"神秘", @"男", @"女", nil];
    [alertController showWithCompletion:nil];
}

- (void)_alertNOTitle {
    LVMAlertController *alertController = [LVMAlertController alertWithTitle:nil message:@"This is a message" preferredStyle:LVMAlertControllerStyleAlert actionHandler:^(NSInteger index) {
        if (0 == index) {
            NSLog(@"Convenience 确定");
        }
    } cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertController showWithCompletion:nil];
}

@end
