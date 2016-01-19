---
layout: post
title:  Learning Python Requests I
date:   2015-12-11 07:22:47
categories: Python
excerpt: 
---
* content
{:toc}

####Requests examples:

	r=requests.get('http://10.32.196.15:4000/')
	r.headers
	{'content-length': '12913', 'server': 'WEBrick/1.3.1 (Ruby/2.0.0/2014-01-12)', 'last-modified': 'Wed, 09 Dec 2015 01:22:59 GMT', 'connection': 'Keep-Alive', 'etag': '2c0065-3271-56678273', 'date': 'Thu, 10 Dec 2015 02:01:58 GMT', 'content-type': 'text/html'}
	r.encoding
	'ISO-8859-1'


####快速上手

- #####发送请求  

Example:

	#!/usr/bin/python
	#corp requests with BS4:
	import requests
	from bs4 import BeautifulSoup
	import time
	import json
	import os
	import re
	session = requests.session()
	req = session.get(url, headers=headers)
	soup = BeautifulSoup(req.text, "html.parser")


那么其他HTTP请求类型：PUT， DELETE， HEAD以及OPTIONS又是如何的呢？都是一样的简单:

	r = requests.put("http://httpbin.org/put")
	r = requests.delete("http://httpbin.org/delete")
	r = requests.head("http://httpbin.org/get")
	r = requests.options("http://httpbin.org/get")

- #####为URL传递参数

如果你是手工构建URL，那么数据会以键/值 对的形式置于URL中，跟在一个问号的后面。例如， 

	httpbin.org/get?key=val  
	
Requests允许你使用 params 关键字参数，以一个字典来提供这些参数。举例来说，如果你想传递 key1=value1 和 key2=value2 到 httpbin.org/get ，那么你可以使用如下代码:

	payload = {'key1': 'value1', 'key2': 'value2'}
	r = requests.get("http://httpbin.org/get", params=payload)
	print (r.url)
	http://httpbin.org/get?key2=value2&key1=value1


- #####响应内容

请求发出后，Requests会基于HTTP头部对响应的编码作出有根据的推测。当你访问 r.text 之时，Requests会使用其推测的文本编码。你可以找出Requests使用了什么编码，并且能够使用 r.encoding 属性来改变它:

	r = requests.get('https://github.com/timeline.json')
	r.text
	u'{"message":"Hello there, wayfaring stranger. If you\u2019re reading this then you probably didn\u2019t see our blog post a couple of years back announcing that this API would go away: http://git.io/17AROg Fear not, you should be able to get what you need from the shiny new Events API instead.","documentation_url":"https://developer.github.com/v3/activity/events/#list-public-events"}'
	r.content
	'{"message":"Hello there, wayfaring stranger. If you\xe2\x80\x99re reading this then you probably didn\xe2\x80\x99t see our blog post a couple of years back announcing that this API would go away: http://git.io/17AROg Fear not, you should be able to get what you need from the shiny new Events API instead.","documentation_url":"https://developer.github.com/v3/activity/events/#list-public-events"}'
	r.encoding
	'utf-8'
	r.encoding = 'ISO-8859-1'

- #####二进制响应内容

你也能以字节的方式访问请求响应体，对于非文本请求:

	r.content
	b'[{"repository":{"open_issues":0,"url":"https://github.com/...
	
Requests会自动为你解码 gzip 和 deflate 传输编码的响应数据。

例如，以请求返回的二进制数据创建一张图片，你可以使用如下代码:

	from PIL import Image
	from StringIO import StringIO
	i = Image.open(StringIO(r.content))

- #####JSON响应内容

Requests中也有一个内置的JSON解码器，助你处理JSON数据:

	import requests
	r = requests.get('https://github.com/timeline.json')
	r.json()
	[{u'repository': {u'open_issues': 0, u'url': 'https://github.com/...

如果JSON解码失败， r.json 就会抛出一个异常。例如，相应内容是 401 (Unauthorized) ，尝试访问 r.json 将会抛出 ValueError: No JSON object could be decoded 异常。


- #####原始响应内容

在罕见的情况下你可能想获取来自服务器的原始套接字响应，那么你可以访问 r.raw 。 如果你确实想这么干，那请你确保在初始请求中设置了 stream=True 。具体的你可以这么做:

	r = requests.get('https://github.com/timeline.json', stream=True)
	r.raw
	<requests.packages.urllib3.response.HTTPResponse object at 0x101194810>
	r.raw.read(10)
	'\x1f\x8b\x08\x00\x00\x00\x00\x00\x00\x03'

但一般情况下，你应该下面的模式将文本流保存到文件:

	with open(filename, 'wb') as fd:
		for chunk in r.iter_content(chunk_size):
			fd.write(chunk)
			
- #####定制请求头

如果你想为请求添加HTTP头部，只要简单地传递一个 dict 给 headers 参数就可以了。


很多时候你想要发送的数据并非编码为表单形式的。如果你传递一个 string 而不是一个 dict ，那么数据会被直接发布出去。
例如，在前一个示例中我们没有指定content-type:

例如，Github API v3接受编码为JSON的POST/PATCH数据:

	import json
	url = 'https://api.github.com/some/endpoint'
	payload = {'some': 'data'}
	headers = {'content-type': 'application/json'}
	
	r = requests.post(url, data=json.dumps(payload), headers=headers)
	r.text
	u'{"message":"Not Found","documentation_url":"https://developer.github.com/v3"}'


- #####更加复杂的POST请求    

This is an example:  

    headers = {
    "User-Agent": 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36',
    }
    r = requests.post("http://httpbin.org/post", data=payload, headers=headerr )
    print  (r.text)
    {
    "args": {},
    "data": "",
    "files": {},
    "form": {
    	"key1": "value1",
    	"key2": "value2"
    },
    "headers": {
    	"Accept": "*/*",
    	"Accept-Encoding": "gzip, deflate",
    	"Content-Length": "23",
    	"Content-Type": "application/x-www-form-urlencoded",
    	"Host": "httpbin.org",
    	"User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36",
    	"X-Imforwards": "20"
    },
    "json": null,
    "origin": "168.159.144.56",
    "url": "http://httpbin.org/post"
    }   



- #####POST一个多部分编码(Multipart-Encoded)的文件

Requests使得上传多部分编码文件变得很简单;
你可以显式地设置文件名，文件类型和请求头;
如果你想，你也可以发送作为文件来接收的字符串'
在一个请求中发送多文件参考 [高级用法 一节](http://cn.python-requests.org/zh_CN/latest/user/advanced.html#advanced)

- #####响应状态码

Simple example: 

	r = requests.get('http://httpbin.org/get')
	r.status_code
	200


- #####响应头

我们可以查看以一个Python字典形式展示的服务器响应头:

	r.headers
	{
		'content-encoding': 'gzip',
		'transfer-encoding': 'chunked',
		'connection': 'close',
		'server': 'nginx/1.0.4',
		'x-runtime': '148ms',
		'etag': '"e1ca502697e5c9317743dc078f67693f"',
		'content-type': 'application/json'
	}
	
但是这个字典比较特殊：它是仅为HTTP头部而生的。根据 RFC 2616 ， HTTP头部是大小写不敏感的。

因此，我们可以使用任意大写形式来访问这些响应头字段:

	>>> r.headers['Content-Type']
	'application/json'
	
	>>> r.headers.get('content-type')
	'application/json'


- #####**Cookies**

如果某个响应中包含一些Cookie，你可以快速访问它们:

	url = 'http://example.com/some/cookie/setting/url'
	r = requests.get(url)
	
	r.cookies['example_cookie_name']
	'example_cookie_value'

要想发送你的cookies到服务器，可以使用 cookies 参数:

	url = 'http://httpbin.org/cookies'
	cookies = dict(cookies_are='working')
	
	r = requests.get(url, cookies=cookies)
	r.text
	'{"cookies": {"cookies_are": "working"}}'



- #####重定向与请求历史

- #####超时

经过以 timeout 参数设定的秒数时间之后停止等待响应
	requests.get('http://github.com', timeout=0.001)


- #####错误与异常





