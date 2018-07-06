## 0、说明

* Carthage之于CocoaPods，在于去中心化，更多主动管理三方库以及二方库。
* 对于后续模块化开发，十分方便。（即将开发的独立模块置于自己的服务上）
* 本文是`Carthage GitHub文档翻译`+`后续实际开发经验`的整合，旨在方便理解和使用。

### 参考链接

* Github地址：[https://github.com/Carthage/Carthage](https://github.com/Carthage/Carthage)

* 资源Trending索引：[https://github.com/trending?l=swift](https://github.com/trending?l=swift)


## 一、作业流程：

1. 创建Cartfile：项目中所有到的所有frameworks均罗列于此。
2. 运行Carthage，获取和构建上述罗列的frameworks。
3. 拖拽构建完成的`.framework`二进制文件至项目中。

* 注：Carthage仅支持动态库，且使用范围：ios8及以上


### 安装Carthage

1. 使用Homebrew：

	> $ brew update
	>
	> $ brew install carthage
	>
	> 删除老版路径： /Library/Frameworks/CarthageKit.framework
	
### 添加frameworks到项目中

1. 创建Cartfile，并罗列frameworks

	> $ cd ..path
	>
	> $ touch Cartfile
	>
	> $  open -a Xcode Cartfile (optional )
	> 
	> add origin to file
2. 执行运行命令：`carthage update --platform iOS`

	> 下载依赖库至`Carthage/Chackout`目录，并编译每个依赖库或下载编译好的库
	
	> 更新亦是用该命令或者单独更新某一个库：carthage update Box Result
	
3. 引入Framework：

	1. 在Mac开发中：在项目Targets的`General`tab->`Embedded Binaries`，拖拽编译好的依赖库framework导入即可。

		> 编译好的库位于`Carthage/Build`路径中。
		
	2. 在iOS中：在项目Targets的`General`tab->`“Linked Frameworks and Libraries`，拖拽编译好的依赖库framework导入。

		> 追加步骤1：在targets中点击+，选择New Run Script Phase，选择/bin/sh,添加脚本：``/usr/local/bin/carthage copy-frameworks``
		> 
		> 追加步骤2：在1中脚本下Input Files添加如下`$(SRCROOT)/Carthage/Build/iOS/Result.framework`语句
		> 
		> 追加步骤3：在1中脚本下Output Files添加如下`$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/Result.framework`语句
	
4. 可选。添加debug 文件

	> 在项目Targets的Buidlding phases-> + -> new copy files Phases,选择Destination为Products Direction，Subpath为相应依赖库framework的DYSM文件路径

---

# 二、Cartfile文件构成

## 1. Cartfile

* 文件由2部分构成：origin、Version requirement

### origin：

* 目前支持源：GitHub repositories、Git repositories、以https提供的二进制framework。

1. GitHub:

	> github "ReactiveCocoa/ReactiveCocoa" # GitHub.com
	>
	> github "https://enterprise.local/ghe/desktop/git-error-translations" # GitHub Enterprise

2. Git:

	> git "https://enterprise.local/desktop/git-error-translations2.git"
3. 二进制库：
	> binary "https://my.domain.com/release/MyFramework.json"
	
### version要求
* 针对具体framework版本要求

1. `>= 1.0`：最低版本为1.0
2. `~> 1.0`：需兼容版本1.0（可以高于1.0，但必须兼容1.0）
3. `== 1.0`：严格控制为版本1.0
4. `some-branch-or-tag-or-commit`：针对Git要求，不支持二进制库

### 示例

```
# Require version 2.3.1 or later
github "ReactiveCocoa/ReactiveCocoa" >= 2.3.1

# Require version 1.x
github "Mantle/Mantle" ~> 1.0    # (1.0 or later, but less than 2.0)

# Require exactly version 0.4.1
github "jspahrsummers/libextobjc" == 0.4.1

# Use the latest version
github "jspahrsummers/xcconfigs"

# Use the branch
github "jspahrsummers/xcconfigs" "branch"

# Use a project from GitHub Enterprise
github "https://enterprise.local/ghe/desktop/git-error-translations"

# Use a project from any arbitrary server, on the "development" branch
git "https://enterprise.local/desktop/git-error-translations2.git" "development"

# Use a local project
git "file:///directory/to/project" "branch"

# A binary only framework
binary "https://my.domain.com/release/MyFramework.json" ~> 2.3
```
	
## 2. Cartfile.private

* framework需要使用的依赖库，对于主项目来讲，非必须引入的部分，即可选的依赖库。

	> 使用场景：如一些测试库：在debug阶段需要，在发布阶段需要去除。

## 3. Cartfile.resolved

* 执行`carthage update`后，在`Cartfile `同级别中将产生此目录：罗列所有依赖库和版本信息

## 4. Carthage/Build

* 执行`carthage update`后产生，涵盖：二进制库和debug信息

## 5. arthage/Checkouts

* 执行`carthage checkout `后产生于application目录中，涵盖：依赖库的源码文件，`Carthage/Checkouts`目录用于后续`carthage build`命令。
* todo：submodules

## 6. ~/Library/Caches/org.carthage.CarthageKit

* 自动创建，涵盖Git下载的依赖库的源数据，多个项目公用。
* 在下次调用`carthage checkout`,将重新生成

## 7. Binary Project Specification

* 二进制文件
* 例：

> 
> {
>	
>"1.0": "https://my.domain.com/release/1.0.0/framework.zip",
>	"1.0.1": "https://my.domain.com/release/1.0.1/framework.zip"
>
> }
