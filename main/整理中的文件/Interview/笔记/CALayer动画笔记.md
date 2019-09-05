
## CALayer 和 UIView

* CALyer：主要负责渲染（界面和动画）
* UIView：在 layer 基础上添加了 Event Handle。

* 关系：调整 view 上展示的属性实际上都是在调整 layer 上对应的属性。

	> 在创建UIView对象时，UIView内部会自动创建一个图层(即CALayer对象)，通过UIView的layer属性可以访问这个层。
	
	> 当UIView需要显示到屏幕上时，会调用drawRect:方法进行绘图，并且会将所有内容绘制在自己的图层上，绘图完毕后，系统会将图层拷贝到屏幕上，于是就完成了UIView的显示。

	>换句话说，UIView本身不具备显示的功能，是它内部的层才有显示功能。

	> 因此，通过调节CALayer对象，可以很方便的调整UIView的一些外观属性。
	
* 动画：则是 layer 层的再次渲染。

	* Core Animation，中文翻译为核心动画，它是一组非常强大的动画处理API，使用它能做出非常炫丽的动画效果。
Core Animation可以用在Mac OS X和iOS平台。
Core Animation的动画执行过程都是在后台操作的，不会阻塞主线程。
要注意的是，Core Animation是直接作用在CALayer上的，并非UIView。



	> 原理：Core Animation 维护了两个平行 layer 层次结构： model layer tree（模型层树） 和 presentation layer tree（表示层树）。前者中的 layers 反映了我们能直接看到的 layers 的状态，而后者的 layers 则是动画正在表现的值的近似。

	>实际上还有所谓的第三个 layer 树，叫做 rendering tree（渲染树）。因为它对 Core Animation 而言是私有的，所以我们在这里不讨论它。

	> 考虑在 view 上增加一个渐出动画。如果在动画中的任意时刻，查看 layer 的 opacity 值，你是得不到与屏幕内容对应的透明度的。取而代之，你需要查看 presentation layer 以获得正确的结果。

	> 虽然你可能不会去直接设置 presentation layer 的属性，但是使用它的当前值来创建新的动画或者在动画发生时与 layers 交互是非常有用的。

	> 通过使用 -[CALayer presentationLayer] 和 -[CALayer modelLayer]，你可以在两个 layer 之间轻松切换。
	
	> 注意：动画完成后，presentationLayer将回到modelLayer 的位置。故动画结束，让 layer 停留在结束处的方案有2个：
		
	> 	* 直接在 model layer 上更新属性。这是推荐的的做法，因为它使得动画完全可选
	>	* 设置动画的 fillMode 属性为 kCAFillModeForward 以留在最终状态，并设置removedOnCompletion 为 NO 以防止它被自动移除.(不推荐：如果将已完成的动画保持在 layer 上时，会造成额外的开销，因为渲染器会去进行额外的绘画工作)
	
	* 核心动画：我们创建的动画对象在被添加到 layer 时立刻就复制了一份。这个特性在多个 view 中重用动画时这非常有用

## POP 动画原理

### CADisplayLink

* POP的帧率可以达到 60fps，主要原因即是CADisplayLink。

	> CADisplayLink提供一个回调，在每次屏幕刷新的时候就会执行这个回调。在这个回调里根据当前动画已经执行的时间来计算Ojbect应该在哪个位置或者颜色为多少，然后将Object移动到此位置，连贯起来就是一个完整的动画.
	
	```
	#if TARGET_OS_IPHONE
  _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render)];
  _displayLink.paused = YES;
  [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
#else
  CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);
  CVDisplayLinkSetOutputCallback(\_displayLink, displayLinkCallback, (\_\_bridge void *)self);
#endif
//render
- (void)render
{
  CFTimeInterval time = [self _currentRenderTime];
  [self renderTime:time];
}
	```
	
	> 更详细的在函数- (void)renderTime:(CFTimeInterval)time里，感兴趣的慢慢往里深入吧。
POP只需要根据各种动画的执行曲线，再考虑各种因素Bouncinesss, Speed, Tension等，计算出一个跟时间t有关的曲线，在render函数里得到当前时间，根据t来的到位置，再显示出来即可。可以看一下spring动画的曲线，

### 动画属性

* 最终动画作用在某个属性上就是这个writeBlock其作用的。当然，如果想了解当前动画执行到哪个程度了，可以通过readBlock来获得。不信在第6行setPosition那个地方下个断点试试。

* Core Animation的载体只能是CALayer，而Pop Animation可以是任意基于NSObject的对象。当然大多数情况Animation都是界面上显示的可视的效果，所以动画执行的载体一般都直接或者间接是UIView或者CALayer。

### 基本的动画

* POPBasicAnimation
* PopSpringAnimation
* PopDecayAnimation
* POPCustomAnimation

优势：Pop Animation应用于CALayer时，在动画运行的任何时刻，layer和其presentationLayer的相关属性值始终保持一致，而Core Animation做不到。 
Pop Animation可以应用任何NSObject的对象，而Core Aniamtion必须是CALayer。













