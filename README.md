![](https://travis-ci.org/DouKing/LVMAlertHUD.svg?branch=master)


## LVMAlertController

> 仿系统API弹框

- 使用方式

```

LVMAlertController *alertController = [LVMAlertController alertControllerWithTitle:@"测试" message:@"这是一个测试信息" preferredStyle:LVMAlertControllerStyleAlert];

LVMAlertAction *action = [LVMAlertAction actionWithTitle:@"呵呵" style:LVMAlertActionStyleDefault handler:nil];
[alertController addAction:action];

action = [LVMAlertAction actionWithTitle:@"嘻嘻" style:LVMAlertActionStyleCancel handler:^(LVMAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}];
[alertController addAction:action];

[alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
   textField.placeholder = @"这是输入框";
}];

[self presentViewController:alertController animated:YES completion:nil];

```

- 链式调用

```

LVMAlertController.alert
	              .setupTitle(@"title")
	              .setupMessage(@"message")
	              .addActionsWithTitles(@"ok", @"later", @"know", nil)
	              .addCancelActionWithTitle(@"cancel")
	              .actionsHandler(^(NSInteger index, LVMAlertAction *action) {
	                 NSLog(@"click %ld, %@", index, action.title);
	              })
 				  .show(^{
				     NSLog(@"show");
				  });

```

## 其他

- LVMStatusBarHUD	导航条提示
- LVMToastHUD		toast提示