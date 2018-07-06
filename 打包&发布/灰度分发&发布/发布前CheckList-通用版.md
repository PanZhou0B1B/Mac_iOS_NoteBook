
1. https开启，环境切换是否复原为线上。
2. 应用内Debug模块是否关闭并移除。

	> main()函数处有侵入代码，需要清除或者注释掉。
	
3. 临时资源：如图片、html是否完全替换。
4. 版本Version设置是否正确；buildVersion设置是否正确。
5. app名称，图标icon，启动页是否正确。
5. 网络模块中version参数是否设置正确。
6. info.list配置：

	> * Build Active Architecture Only -> No
	> * App Transport Security Settings网络配置是否正确。
	> * 证书配置等。
	> * bundle id 是否匹配。
	
7. 查看项目中静态分析的警告条目，是否是逻辑性问题引起。
8. 上线前私有API检测。
9. 官网版本文案、图片是否更新为匹配项。





