![](https://travis-ci.org/DouKing/LVMAlertHUD.svg?branch=master)


## LVMAlertController

> An alert control that follows the system's API.

![](./capture.gif)

## Usage

- The basic

```

LVMAlertController *alertController = [LVMAlertController alertControllerWithTitle:@"TITLE" message:@"some message" preferredStyle:LVMAlertControllerStyleAlert];

LVMAlertAction *action = [LVMAlertAction actionWithTitle:@"OK" style:LVMAlertActionStyleDefault handler:nil];
[alertController addAction:action];

action = [LVMAlertAction actionWithTitle:@"Cancel" style:LVMAlertActionStyleCancel handler:^(LVMAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}];
[alertController addAction:action];

[alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
   textField.placeholder = @"A text field placeholder";
}];

[self presentViewController:alertController animated:YES completion:nil];

```

- support for DSL

```

LVMAlertController.alert
	          .setupTitle(@"Title")
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

## The other UI controls contain

- LVMStatusBarHUD
- LVMToastHUD

## Install with CocoaPods

Add the following content to your Podfile.

```
pod 'LVMAlertHUD'
```

OR

```
pod 'LVMAlertHUD/AlertController' 
pod 'LVMAlertHUD/StatusBarHUD'
pod 'LVMAlertHUD/Toast'
```
#### Compatibility

- iOS 8.0+
- Xcode 9.4

## License

See LICENSE.
