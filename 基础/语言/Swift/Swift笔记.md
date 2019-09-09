###### 1. 数组排序

```
var animalSectionTitles = [String]()
...
animalSectionTitles.sort { (s1, s2) -> Bool in
     return s1 < s2
}
```

###### 2. 标题动态处理

```
navigationController?.navigationBar.prefersLargeTitles = true
   navigationController?.navigationItem.largeTitleDisplayMode = .automatic
```

###### 3. cell动画：在willDisplay Cell方法中执行，并延迟动画复原。

```
let rotationAngleInRadians = 90.0 * CGFloat(Double.pi/180)
//let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1)
let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
cell.layer.transform = rotationTransform
        
UIView.animate(withDuration: 1.0) {
//cell.alpha = 1.0
cell.layer.transform = CATransform3DIdentity
	}
```

###### 4. `"""`对用于声明多行字符串。

###### 5. Codable:Swift4支持。即支持json编解码解析，而不需JSONSerialization逐个内容字段解析。

###### 6. `traitCollection`:设置size class，做不同屏幕的适配。

```
//屏幕变更检测
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {}
```
	
