链接：https://www.raywenderlich.com/153844/macos-view-controllers-tutorial

## 生命周期

#### 1. 创建环节

1. ViewDidLoad
2. viewWillAppear
3. viewDidAppear

#### 2. UI交互展示环节

1. updateViewConstraints

	> 每次布局更改时，都会被自动调用。如window大小变更
	
2. viewWillLayout：调用[self layout]，并在执行之前调用

	> 如使用该方法适配约束
	
3. viewDidLayout:调用[self layout]，并在执行之后调用

#### 3. 释放环节
	
1. viewWillDisappear
2. viewDidDisappear