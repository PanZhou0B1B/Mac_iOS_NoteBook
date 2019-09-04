* Apple的2D渲染引擎。

## 创建、配置自定义View，base Layer

1. 创建一个NSView子类
2. 重写draw()方法，绘制

	> Graphics Contexts:系统在ctx上直接绘制图形，然后再展示在View上
	>
	> * 绘制：CGPathRef绘制矢量图形路径；将Path添加至ctx；ctx设置渲染属性，根据Path渲染图形。

	> * 在绘制占比时，可使用区块遮罩方式实现。即Ctx.clip
	
3. 绘制字符串

	> * 获取当前Ctx
	> * 获取字符串以及其AttributionString，并计算出size、postion
	> * 使用字符串draw方法绘制到当前ctx上。

3. AppKit高层级绘制

	> NSBezierPath封装于CG的CGPathRef。高度封装。
	
	> * 绘制：NSBezierPath绘制矢量图形路径；path设置渲染属性，根据Path渲染图形(此时无Ctx，实际是自动获取了当前的Ctx)
	> * 通过NSGradient和Clip 遮罩绘制渐变背景。
	
---
## 其它

1. live渲染View:在XIB中直观修改定制View的属性，而无需编译运行

	> * @IBDesignable:在class声明之前添加
	> * @IBInspectable:在属性之前添加。在XIB中直观修改属性。
	> * override func prepareForInterfaceBuilder():重载，并初始配置。

2.  ByteCountFormatter：将字节转换为可描述方式。
