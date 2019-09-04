## Charts简述
1. 源码地址：[https://github.com/danielgindi/Charts]([https://github.com/danielgindi/Charts])
2. 源码是由swift编写，但可用于swift和Obj-C项目。
3. 更多简介可以进入上述源码区查看README.md

## 正文
1. 由于该三方库体量庞大，划分的非常细致。粗略数了下，总体约十多个文件组、合一百多个文件。优点是各功能划分清楚，结构清晰。缺点是像阅读wiki，跳转比较多。所以下面将以饼图作为切入点来分析一下源码，原因其一避免了散点解析，毫无头绪；其二是马上要用到这块的内容开发（O(∩_∩)O~~）。
2. 文件组结构简介：

	> 1. Animation：各种动画的定义和实现
	
	> 2. Charts: 图表文件,含基类和具体类型的图表
	
	> 3. Component：组件（如X、Y轴定义等）
	
	> 4. Data:图表数据源定义（协议+实现）
	
	> 5. Filter:RDP算法，减少曲线中的点（Whoops）
	
	> 6. Formatters:格式化value
	
	> 7. Highlight:选中图表条目实现方案
	
	> 8. Interfaces: 
	
	> 9. Jobs: 提供控件的一些位置变换
	
	> 10. Renderers：图表渲染器
	
	> 11. Utils:通用工具类（如角度和弧度转换）

3. 针对饼图解析，下面给出了必要的相关类图，其中还有很多基类和辅助性的工具类，如X、Y轴，Legend描述图表，都做了简化和忽略。

	> 当一个类有多级父类，并且在最顶层父类才具有的属性，但在子类中进行实例化。目前这种类图的描述方案是：从父类指向引用，但实际引用的子类在同一级别（黄色背景）
	
 ![PieChart](./charts(1)/PieCharts.jpg)

	效果图：
	
 ![效果图](./charts(1)/a.gif)

***

#### 1. 饼图使用方法：

1. 初始化PieChartView，并设置相关属性
	
	> 可以参见PieChartView的属性部分解析
2. 协议设置
3. 动态设置其值
4. Optional实时变更

	```
_chartView.drawHoleEnabled = !_chartView.isDrawHoleEnabled;      
[_chartView setNeedsDisplay];
	```

#### 2. PieChartView文件

##### 属性（部分）
1. usePercentValuesEnabled：是否使用百分比来表示切片的值，NO：使用真实值显示
	
2. drawSlicesUnderHoleEnabled：切片是否要绘制于Hole之下；该属性需要和drawHoleEnabled一起使用。
	
3. holeRadiusPercent：饼图中心的圆形半径
4. transparentCircleRadiusPercent：透明圆形半径（通常和3中属性一起使用）
	
5. chartDescription（ChartDescription）：chartView.chartDescription.enabled = NO;是否启用饼图右下角的文本展示
	
6. drawCenterTextEnabled：是否展示饼图中心文本
	
7. centerAttributedText：设置饼图中心文本
	
9. rotationAngle：饼图旋转角度（默认270->top）；0~360°范围
10. rotationEnabled：是否可拖拽旋转
	
11. highlightPerTapEnabled：点击放大展示选中
12. legend（ChartLegend）：每个切片数据的占比-色值对；展示于图表的右上角。

	```
ChartLegend *l = chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationVertical;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
```
13. data（PieChartData--PieChartDataSet）：设置切片个数和每个切片的value值
	
#### 初始化
1. 渲染器PieChartRenderer和设置IHighlighter协议实体

	```
	renderer = PieChartRenderer(chart: self, animator: _animator, viewPortHandler: _viewPortHandler)
   _xAxis = nil
   
   self.highlighter = PieHighlighter(chart: self)
	```
2. 渲染器具体实施原理，详见下文
3. highlighter具体实施原理，详见下文


#### draw()

```
open override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        if _data === nil
        {
            return
        }
        
        let optionalContext = NSUIGraphicsGetCurrentContext()
        guard let context = optionalContext else { return }
        
        renderer!.drawData(context: context)
        
        if (valuesToHighlight())
        {
            renderer!.drawHighlighted(context: context, indices: _indicesToHighlight)
        }
        
        renderer!.drawExtras(context: context)
        
        renderer!.drawValues(context: context)
        
        _legendRenderer.renderLegend(context: context)
        
        drawDescription(context: context)
        
        drawMarkers(context: context)
    }

```
代码解析：

1. renderer!.drawData(context: context)在上下文中使用渲染器绘制图表
2. renderer!.drawValues(context: context):一些图表的相关绘制

总结：renderer通过弱引用Chart实例，是Chart绘制的具体实施者，而数据源则是_data。

##### 方法
1. 角度offset等具体的计算：（略）
2. 属性的具体设置（通过存储属性和计算属性的set方法）：
	如
	
	```
	open var drawEntryLabelsEnabled: Bool
    {
        get
        {
            return _drawEntryLabelsEnabled
        }
        set
        {
            _drawEntryLabelsEnabled = newValue
            setNeedsDisplay()
        }
    }
	```

1. setExtraOffsetsWithLeft:top:right:bottom:

	> 设置图表的padding offset
	>
	> ChartViewBase中的方法
	
2. animateWithYAxisDuration:
	> 渲染图表并动态展示
	
3. Options设置属性：

	```
	_chartView.drawEntryLabelsEnabled = !_chartView.isDrawEntryLabelsEnabled;
        
    [_chartView setNeedsDisplay];
	```

##### ChartViewDelegate 协议
1. 位于ChartViewBase文件中
2. 图表切片选中时反馈给调用者


---

#### 3. PieChartRenderer文件
数据渲染器：将chart对应的数据绘制于Chart上

##### 方法
1. drawData(context: CGContext)：具体绘制
2. slice数学分析计算
3. 属性文本、图形等计算绘制

#### 4. PieChartData文件
饼图数据源：提供最大值，最小值、移除value等操作功能。

##### 属性
1. internal var _dataSets = \[IChartDataSet]():图表具体切片value；IChartDataSet规范统一的计算方法。


##### Chart中具体使用方法：
 
```
- (void)setDataCount:(int)count range:(double)range
{
    double mult = range;
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [entries addObject:[[PieChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) label:parties[i % parties.count]]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:entries label:@"Election Results"];
    dataSet.sliceSpace = 2.0;
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    dataSet.valueLinePart1OffsetPercentage = 0.8;
    dataSet.valueLinePart1Length = 0.2;
    dataSet.valueLinePart2Length = 0.4;
    //dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.blackColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}

```

---
#### 基类
##### 1. PieRadarChartViewBase
1. PieChartView的直接父类
2. 角度、padding offset、手势添加
3. Legend Renderer 设置

##### 2. ChartViewBase
1. ChartView的基类
2. 主要涵盖数据源、view属性等基础性的配置

---
## 附：语法萃取
1. 导入模块：`import Foundation`
2. 判断开发平台宏定义：

	```
#if !os(OSX)
    import UIKit
#endif
	```
	platform文件即统一了各平台的差异：
	
	```
#if os(iOS) || os(tvOS)
 import UIKit
 ......					(别名定义)
public typealias NSUIFont = UIFont
open class NSUIView: UIView
{
......
}
#if !os(tvOS)
...
#endif
#endif
#if os(OSX)
import Cocoa
import Quartz
//---
public typealias NSUIFont = NSFont
....		(扩展)
#endif
	```
	为支持 UIKit (iOS, tvOS) and Cocoa (OS X)，判断平台，并给予一个别名定义：
	
	```
	public typealias NSUIFont = UIFont
	```

4. 扩展某些类的功能：

	```
	 extension NSUITapGestureRecognizer
    {
        final func nsuiNumberOfTouches() -> Int
        {
            return numberOfTouches
        }
        
        final var nsuiNumberOfTapsRequired: Int
        {
            get
            {
                return self.numberOfTapsRequired
            }
            set
            {
                self.numberOfTapsRequired = newValue
            }
        }
    }

	```
	
3. `open class **`修饰的类除了具有public的特点外，该类还可以被其它模块的类继承，而public修饰的类只能被模块外引用，却不可继承。
4. fileprivate:访问控制。本模块本文件即文件内私有，只可在本源文件中使用

	```
	fileprivate var _drawHoleEnabled = true

	fileprivate var _holeColor: NSUIColor? = NSUIColor.white
	```
	
4. `===`指针判定
5. Double中的infinity代表无穷，它是类似 1.0 / 0.0 这样的数学表达式的结果，代表数学意义上的无限大。NaN代表的是某些未被定义的或者出现了错误的运算，它是 “Not a Number” 的简写
6. FLT\_EPSILON和DBL\_EPSILON：float和double 类型的机器精度，即 1.0 与下一个可被 double 类型描述的值的差。
7. 关于类中的属性和计算属性，常使用私有的属性、open类型的计算属性来支持对外访问（同时可以设置其setter、getter方法，来监听值的变化做一些联动操作）。

	```
fileprivate var _type: FillType = FillType.empty

	// MARK: Properties
 open var type: FillType
  {
    return _type
  }
	```
	
8. @nonobjc、@objc(**)：Obj-C和Swift混编时使用   
9. fatalError：Release编译时期抛出错误、Assert只在Debug时使用

	> 某些方法要求子类必须override：fatalError("这个方法必须在子类中被重写)"
10. guard：

	```
	guard let
            viewPortHandler = self.viewPortHandler
            else { return }
	```
11.  _displayLink?.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
12. 宏定义

	```
	#if os(tvOS)
            // 23 is the smallest recommended font size on the TV
            font = NSUIFont.systemFont(ofSize: 23)
        #elseif os(OSX)
            font = NSUIFont.systemFont(ofSize: NSUIFont.systemFontSize())
        #else
            font = NSUIFont.systemFont(ofSize: 8.0)
        #endif
   ```
   
13. @available:声明这些类型的生命周期依赖于特定的平台和操作系统版本.

	> \#available 用在条件语句代码块中，判断不同的平台下，做不同的逻辑处理
	> 
	```
	if #available(iOS 8, *) {
        // iOS 8 及其以上系统运行
	}
	```
	>