---
layout: post
title:  Learning Python Requests [advance]
date:   2015-12-12 15:13:27
categories: python
tags: python
excerpt: 
---


#### 高级用法
- ##### 会话对象

**下面并不是都能理解，需要运用后再看了。尤其是每次调用的方法和请求是否都是在同一个session里面呢？**

>会话对象让你能够跨请求保持某些参数。它也会在同一个Session实例发出的所有请求之间保持cookies。

会话对象具有主要的Requests API的所有方法。

我们来跨请求保持一些cookies:

	s = requests.Session()
	
	s.get('http://httpbin.org/cookies/set/sessioncookie/123456789')
	r = s.get("http://httpbin.org/cookies")
	
	print(r.text)
	# '{"cookies": {"sessioncookie": "123456789"}}'

会话也可用来为请求方法提供缺省数据。这是通过为会话对象的属性提供数据来实现的:

	s = requests.Session()
	s.auth = ('user', 'pass')
	s.headers.update({'x-test': 'true'})

	# both 'x-test' and 'x-test2' are sent
	s.get('http://httpbin.org/headers', headers={'x-test2': 'true'})

任何你传递给请求方法的字典都会与已设置会话层数据合并。方法层的参数覆盖会话的参数。




- ##### 请求与响应对象

任何时候调用requests.*()你都在做两件主要的事情。其一，你在构建一个 Request 对象， 该对象将被发送到某个服务器请求或查询一些资源。其二，一旦 requests 得到一个从 服务器返回的响应就会产生一个 Response 对象。该响应对象包含服务器返回的所有信息， 也包含你原来创建的 Request 对象。

想访问服务器返回给我们的响应头部信息，可以这样做:
	>>> r.headers
如果想得到发送到服务器的请求的头部，我们可以简单地访问该请求，然后是该请求的头部:
	>>> r.request.headers

- ##### Prepared Requests
- ##### SSL证书验证
- ##### 响应体内容工作流
- ##### 保持活动状态（持久连接）
- ##### 流式上传
- ##### 块编码请求
- ##### POST Multiple Multipart-Encoded Files
- ##### 事件挂钩
- ##### 自定义身份验证
- ##### 流式请求
- ##### 代理
- ##### 合规性
- ##### HTTP动词
- ##### 响应头链接字段
- ##### Transport Adapters
- ##### Blocking Or Non-Blocking?
- ##### Timeouts
- ##### CA Certificates


### 身份认证
- ###### 基本身份认证
- ###### 摘要式身份认证
- ###### OAuth 1 Authentication
- ###### 其他身份认证形式
- ###### 新的身份认证形式



