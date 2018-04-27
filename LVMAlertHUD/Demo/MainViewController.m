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
#import "DetailViewController.h"

typedef NS_ENUM(NSInteger, DataSourceType){
    DataSourceTypeNextPage,
    DataSourceTypeStatusBarHud,
    DataSourceTypeAlert,
    DataSourceTypeActionSheet,
    DataSourceTypeToastHud,
    DataSourceTypeAlertConvenience,
    DataSourceTypeActionSheetConvenience,
    DataSourceTypeAlertNoTitle,
    DataSourceTypeActionSheetNoTitle,

    DataSourceTypeCount
};
static NSString * const DataSourceTypeNameMapping[] = {
    [DataSourceTypeNextPage] = @"下一级",
    [DataSourceTypeStatusBarHud] = @"导航条提示",
    [DataSourceTypeAlert] = @"Alert",
    [DataSourceTypeActionSheet] = @"ActionSheet",
    [DataSourceTypeToastHud] = @"Toast",
    [DataSourceTypeAlertConvenience] = @"Alert Convenience",
    [DataSourceTypeActionSheetConvenience] = @"ActionSheet Convenience",
    [DataSourceTypeAlertNoTitle] = @"Alert NO Title",
    [DataSourceTypeActionSheetNoTitle] = @"ActionSheet NO Title",
};

static NSString * const kMainViewControllerCellId = @"kMainViewControllerCellId";

@interface MainViewController ()

@property (nonatomic, strong) NSArray<NSString *> *dataSource;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray<NSString *> *temp = [NSMutableArray arrayWithCapacity:DataSourceTypeCount - 1];
    for (DataSourceType i = DataSourceTypeNextPage; i < DataSourceTypeCount; i++) {
        [temp addObject:DataSourceTypeNameMapping[i]];
    }
    self.dataSource = [temp copy];
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
    DataSourceType type = indexPath.row;
    switch (type) {
        case DataSourceTypeNextPage: {
            DetailViewController *vc = [[DetailViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case DataSourceTypeStatusBarHud: {
            [self _showStatusBarHUD];
        } break;
        case DataSourceTypeAlert: {
            [self _showAlert];
        } break;
        case DataSourceTypeActionSheet: {
            [self _showActionSheet];
        } break;
        case DataSourceTypeToastHud: {
            [self _showToastHUD];
            break;
        }
        case DataSourceTypeAlertConvenience: {
            [self _alertConvenience];
        } break;
        case DataSourceTypeActionSheetConvenience: {
            [self _actionSheetConvenience];
        }  break;
        case DataSourceTypeAlertNoTitle: {
            [self _alertNOTitle];
        } break;
        case DataSourceTypeActionSheetNoTitle: {
            [self _actionSheetNOTitle];
        } break;
        case DataSourceTypeCount: break;
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
    
    [self presentViewController:alertController animated:YES completion:nil];
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
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_showToastHUD {
    [LVMToastHUD showMessage:@"提示信息" toView:self.view];
}

- (void)_alertConvenience {
    LVMAlertController *alertController = [LVMAlertController alertWithTitle:@"Title" message:@"Message" preferredStyle:LVMAlertControllerStyleAlert actionHandler:^(NSInteger index) {
        if (0 == index) {
            NSLog(@"Convenience 确定");
        } else if (1 == index) {
            NSLog(@"Convenience 取消");
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [self presentViewController:alertController animated:YES completion:nil];
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
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_alertNOTitle {
    LVMAlertController *alertController = [LVMAlertController alertWithTitle:nil message:@"This is a message" preferredStyle:LVMAlertControllerStyleAlert actionHandler:^(NSInteger index) {
        if (0 == index) {
            NSLog(@"Convenience 确定");
        }
    } cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_actionSheetNOTitle {
    LVMAlertController *alertController = [LVMAlertController alertWithTitle:nil message:nil preferredStyle:LVMAlertControllerStyleActionSheet actionHandler:^(NSInteger index) {
        if (0 == index) {
            NSLog(@"Convenience 啦啦");
        } else if (1 == index) {
            NSLog(@"Convenience 取消");
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"啦啦", nil];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
