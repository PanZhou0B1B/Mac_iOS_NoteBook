## 链接参考：

1. [https://foofish.net/python-crawler.html](https://foofish.net/python-crawler.html)
2. [https://toutiao.io/posts/zh0psv/preview](https://toutiao.io/posts/zh0psv/preview)



---

## demo

1. 简单的爬取：

	```
request = urllib.request.Request("https://www.baidu.com")
response = urllib.request.urlopen(request)
print (response.read())
```

2. POST:

	```
import urllib.request
values = {}
values['username'] = "1016903103@qq.com"
values['password'] = "XXXX"
data = urllib.parse.urlencode(values)
data = data.encode('utf-8') # data should be bytes
request = urllib.request.Request("https://www.baidu.com",data)
response = urllib.request.urlopen(request)
print (response.read())
```

3. GET:

	```
import urllib.request
values = {}
values['username'] = "1016903103@qq.com"
values['password'] = "XXXX"
data = urllib.parse.urlencode(values)
data = data.encode('utf-8') # data should be bytes
url = "https://www.baidu.com/account/login"
geturl = url + "?"+data
request = urllib.request.Request(geturl)
response = urllib.request.urlopen(request)
print (response.read())
```

4. Headers添加：

	```
import urllib.request
headers = {}
headers['User-Agent'] = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'  
values = {}
values['username'] = "1016903103@qq.com"
values['password'] = "XXXX"
data = urllib.parse.urlencode(values)
data = data.encode('utf-8') # data should be bytes
request = urllib.request.Request("https://www.baidu.com",data, headers)
response = urllib.request.urlopen(request)
print (response.read())
```

5. Proxy代理设置，timeout超时设置。
6. HTTP中使用较少的PUT、DELETE等请求方式。
7. DebugLog查看收发内容：

	```
httpHandler = urllib.request.HTTPHandler(debuglevel=1)
httpsHandler = urllib.request.HTTPSHandler(debuglevel=1)
opener = urllib.request.build_opener(httpHandler, httpsHandler)
urllib.request.install_opener(opener)
```

8. URLError输出
9. HTTPError输出

	```
import urllib.request
import urllib.error
request = urllib.request.Request("http://blog.csdn.net/cqcrsddsve")
try:
     urllib.request.urlopen(request)
except urllib.error.HTTPError as e:
    if hasattr(e,'reason'):
       print (e.reason)
    print(e.code)
except urllib.error.URLError as e:
    print (e.reason)
else:
	print ('OK')
```

10. 获取cookie：

	```
import urllib.request
from http.cookiejar import CookieJar
request = urllib.request.Request("http://www.baidu.com")
cookie = CookieJar()
#从文件中读取cookie内容到变量
#cookie.load('cookie.txt', ignore_discard=True, ignore_expires=True)
cookieHandler = urllib.request.HTTPCookieProcessor(cookie)
opener = urllib.request.build_opener(cookieHandler)
response = opener.open(request)
for item in cookie:
    	print ('Name = '+item.name)
    	print ('Value = '+item.value)
```

11. 获取cookie并保存本地文件

	```
	import urllib.request
from http.cookiejar import CookieJar
from http.cookiejar import MozillaCookieJar
request = urllib.request.Request("http://www.baidu.com")
filename = 'cookie.txt'
cookie = MozillaCookieJar(filename)
cookieHandler = urllib.request.HTTPCookieProcessor(cookie)
opener = urllib.request.build_opener(cookieHandler)
response = opener.open(request)
cookie.save(ignore_discard=True, ignore_expires=True)
	```