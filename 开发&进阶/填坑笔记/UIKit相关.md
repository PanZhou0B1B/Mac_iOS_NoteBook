# 填坑笔记

## 目录

* [UIAlertContrller](#UIAlertContrller)
* [UIPanGestureRecognizer定位](#UIPanGestureRecognizer定位)
* [UIImage缩放技术ImageIO](#UIImage缩放技术ImageIO)

## <span id = "UIAlertContrller"> UIAlertContrller </span>

1. 进行iPad开发时，使用UIAlertContrller的actionSheet属性时，注意与iPhone开发的区别。即需要添加sourceView、sourceRect。否则在ipad中运行时会crash。

	```
	let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
	//...
	if isPadDevice {
            alert.popoverPresentationController?.sourceView = baseCtrl?.view
            alert.popoverPresentationController?.sourceRect = CGRect.init(x: 10, y:UIScreen.main.bounds.height - 110 , width: 300, height: 400)
        }
   baseCtrl?.present(alert, animated: true, completion: nil)
	```
	
## <span id = "UIPanGestureRecognizer定位"> UIPanGestureRecognizer定位 </span>

1. translationInView : 手指在视图上移动的位置（x,y）向下和向右为正，向上和向左为负。
2. locationInView ： 手指在视图上的位置（x,y）就是手指在视图本身坐标系的位置。
3. velocityInView： 手指在视图上移动的速度（x,y）, 正负也是代表方向，值得一体的是在绝对值上|x| > |y| 水平移动， |y|>|x| 竖直移动。

## <span id = "UIImage缩放技术ImageIO"> UIImage缩放技术ImageIO</span>

关于 iOS 中图片缩放方案，如果在网上搜索的话，一般都会找到类似“新建一个 context ，把图画在里面，再从 context 里读取图片”的答案。此时如果原图很大，那么即使缩放后的图片很小，解压原图的过程仍然需要占用大量内存资源，一不小心就会 OOM。
但是如果换用 `ImageIO` 情况就会好很多，整个过程最多只会占用缩放后的图片所需的内存（通常只有原图的几分之一），大大减少了内存压力。

