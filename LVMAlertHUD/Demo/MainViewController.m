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
#import "LVMAlertHeader.h"
#import "DetailViewController.h"

typedef NS_ENUM(NSInteger, DataSourceType){
    DataSourceTypeNextPage,
    DataSourceTypeStatusBarHud,
    DataSourceTypeToastHud,
    DataSourceTypeAlertBase,
    DataSourceTypeAlertImage,
    DataSourceTypeAlertTextField,
    DataSourceTypeAlertCustomView,

    DataSourceTypeCount
};
static NSString * const DataSourceTypeNameMapping[] = {
    [DataSourceTypeNextPage] = @"push a view controller",
    [DataSourceTypeStatusBarHud] = @"Status bar hud",
    [DataSourceTypeToastHud] = @"Toast",
    [DataSourceTypeAlertBase] = @"Alert simple",
    [DataSourceTypeAlertImage] = @"Alert a image",
    [DataSourceTypeAlertTextField] = @"Alert text fields",
    [DataSourceTypeAlertCustomView] = @"Alert custom view",
};

static NSString * const kMainViewControllerCellId = @"kMainViewControllerCellId";

@interface MainViewController ()

@property (nonatomic, strong) NSArray<NSString *> *dataSource;
@property (nonatomic, assign) LVMAlertControllerStyle alertStyle;

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

    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Action sheet", @"Alert"]];
    [segmentControl addTarget:self action:@selector(_handleSegmentControlEvent:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentControl;
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
        case DataSourceTypeToastHud: {
            [self _showToastHUD];
        } break;
        case DataSourceTypeAlertBase: {
            [self _showAlert];
        } break;
        case DataSourceTypeAlertImage: {
            [self _showAlertImage];
        } break;
        case DataSourceTypeAlertTextField: {
            [self _showAlertTextField];
        } break;
        case DataSourceTypeAlertCustomView: {
            [self _showAlertCustomView];
        } break;
        case DataSourceTypeCount: break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)_handleSegmentControlEvent:(UISegmentedControl *)segmentControl {
    self.alertStyle = segmentControl.selectedSegmentIndex;
}

- (void)_showStatusBarHUD {
    NSString *text = [NSString stringWithFormat:@"message %d", arc4random()];
    [LVMStatusBarHUD showWithMessage:text completion:^{
        NSLog(@"status bar hud");
    }];
}

- (void)_showToastHUD {
    [LVMToastHUD showMessage:@"some message" toView:self.view];
}

- (void)_showAlert {
    LVMAlertAction *destructive = LVMAlertAction.action.setupTitle(@"Destructive").useStyle(LVMAlertActionStyleDestructive);
    LVMAlertAction *ok = LVMAlertAction.action.setupTitle(@"OK").setupEnable(NO);
    LVMAlertController.alert
        .useStyle(self.alertStyle)
        .setupTitle(@"Title")
        .setupMessage(@"Message")
        .addAction(destructive)
        .addAction(ok)
        .addCancelActionWithTitle(@"Cancel")
        .actionsHandler(^(NSInteger index, LVMAlertAction * _Nonnull action) {
            NSLog(@"%ld, %@", index, action.title);
        })
        .showOn(self, YES, ^{
            NSLog(@"show completion");
        });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ok.enabled = YES;
    });
}

- (void)_showAlertImage {
    LVMAlertController *alertController =
    [LVMAlertController alertControllerWithTitle:@"Title"
                                         message:@"Message"
                                           image:[UIImage imageNamed:@"IMG_1132"]
                                  preferredStyle:self.alertStyle];
    LVMAlertAction *cancel = [LVMAlertAction actionWithTitle:@"Cancel" style:LVMAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_showAlertTextField {
    LVMAlertController.alert
        .setupTitle(@"Title")
        .addCancelActionWithTitle(@"Cancel")
        .addTextFieldWithCompletion(^(UITextField * _Nonnull textField){
            textField.placeholder = @"This is a text field.";
        })
        .show(nil);
}

- (void)_showAlertCustomView {
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.preferredContentSize = CGSizeMake(0, 200);

    LVMAlertController.alert.useStyle(self.alertStyle)
        .setupTitle(@"Title")
        .setupMessage(@"Message")
        .setupContentViewController(vc)
        .addCancelActionWithTitle(@"Cancel")
        .show(nil);
}

@end
