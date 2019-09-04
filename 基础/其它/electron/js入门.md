## js文件互相引用方案

1. js1文件中声明属性：

	> module.exports.str="string var";
	
2. js1文件中声明方法：

	```
	module.exports.testF = function(){
         console.log("testF")
    };
   ```
 
 3. 在js中引用js1文件：

 	```
 	const js1 = require("./js/js1.js");
 	
 	js1.str;
 	js1.testF();
 	
 	```