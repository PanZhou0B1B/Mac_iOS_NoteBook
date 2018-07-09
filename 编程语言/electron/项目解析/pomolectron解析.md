## 源码

1. 资源：[https://github.com/amitmerchant1990/pomolectron](https://github.com/amitmerchant1990/pomolectron)


## 结构：

#### 1. package.json配置文件:

1. 如配置main加载文件为：index.js


#### 2. index.js:
#### 3. index.html:
#### 4. res文件夹:
#### 5. js文件夹：
#### 6. fonts文件夹：
#### 7. css文件夹：
#### 8. audio文件夹：


## 源码详解：

#### 1. index.js：

1. `'use strict';`   :严格语法
2. `const electron = require('electron');`:引入模块
3. `var menubar = require('menubar');`:获取对象
4. `const ipcMain = require('electron').ipcMain;`:获取ipcMain
5. `__dirname`:项目主目录