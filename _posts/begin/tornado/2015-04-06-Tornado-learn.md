---
layout: post
title: "Tornado研究分析"
description: "Tornado研究分析"
category: "tornado"
tags: [tornado]
---
<h2>Tornado 主要模块细分（重要程度从上至下）</h2>

<h3>主要模块</h3>

<p>1.<a href="https://github.com/tornadoweb/tornado/blob/master/tornado/web.py"><code>web</code></a>: Tornado的Web框架（其他模块都是工具性质）</p>

<p>2.<a href="https://github.com/tornadoweb/tornado/blob/master/tornado/httpclient.py"><code>httpclient</code></a>: 非阻塞式 HTTP 客户端，它被设计用来和 web 及 httpserver 协同工作</p>

<p>3.<a href="http://www.tornadoweb.org/en/branch2.4/database.html"><code>database</code></a>:对 MySQLdb 的简单封装，使其更容易使用, 注意：在Tornado3.0中，这个模块被移除了，现在改成了<a href="https://github.com/bdarnell/torndb"><code>torndb</code></a>, 安装方式：<code>pip install torndb</code>, 可<a href="http://www.tornadoweb.org">参考tornadb文档</a></p>

<p>4<a href="https://github.com/tornadoweb/tornado/blob/master/tornado/template.py"><code>template</code></a>: 基于 Python 的 web 模板系统</p>

<p>5.<a href="https://github.com/tornadoweb/tornado/blob/master/tornado/auth.py"><code>auth</code></a>:第三方认证的实现（包括 Google OpenID/OAuth、Facebook Platform、Yahoo BBAuth、FriendFeed OpenID/OAuth、Twitter OAuth）</p>

<p>6.<a href="https://github.com/tornadoweb/tornado/blob/master/tornado/options.py"><code>options</code></a>: 命令行和配置文件解析工具，针对服务器环境做了优化</p>

<p>7.<a href="https://github.com/tornadoweb/tornado/blob/master/tornado/escape.py"><code>escape</code></a>: XHTML, JSON, URL 的编码/解码方法</p>

<p>8.<a href="https://github.com/tornadoweb/tornado/blob/master/tornado/locale.py"><code>locale</code></a>:针对本地化和翻译的支持</p>

<!--more-->

<h3>底层模块</h3>

<p>1.<a href="https://github.com/tornadoweb/tornado/blob/master/tornado/httpserver.py"><code>httpserver</code></a> :web框架的HTTP服务器</p>

<p>2.<a href="http://github.com/facebook/tornado/blob/master/tornado/iostream.py"><code>iostream</code></a>: 对非阻塞式的 socket 的简单封装，以方便常用读写操作</p>

<p>3.<a href="http://github.com/facebook/tornado/blob/master/tornado/ioloop.py"><code>ioloop</code></a>: 核心的I/O循环</p>

<h3>源码组织</h3>

<p>.
├── <strong>init</strong>.py</p>

<p>├── auth.py</p>

<p>├── autoreload.py</p>

<p>├── curl_httpclient.py</p>

<p>├── database.py</p>

<p>├── escape.py</p>

<p>├── gen.py</p>

<p>├── httpclient.py</p>

<p>├── httpserver.py</p>

<p>├── httputil.py</p>

<p>├── ioloop.py</p>

<p>├── iostream.py</p>

<p>├── locale.py</p>

<p>├── netutil.py</p>

<p>├── options.py</p>

<p>├── platform(...省略，不重要)</p>

<p>├── simple_httpclient.py</p>

<p>├── stack_context.py</p>

<p>├── template.py</p>

<p>├── test(....省略，不重要)</p>

<p>│  </p>

<p>├── testing.py</p>

<p>├── util.py</p>

<p>├── web.py</p>

<p>├── websocket.py</p>

<p>├── wsgi.py</p>

<p>可以看到，代码量很少，完全可以读几遍里面的源码。</p>

<h2>Tornado模块分类</h2>

<p><strong>Core web framework</strong></p>

<p>tornado.web — 包含web框架的大部分主要功能，包含RequestHandler和Application两个重要的类</p>

<p>tornado.httpserver — 一个无阻塞HTTP服务器的实现</p>

<p>tornado.template — 模版系统</p>

<p>tornado.escape — HTML,JSON,URLs等的编码解码和一些字符串操作</p>

<p>tornado.locale — 国际化支持</p>

<p><strong>Asynchronous networking 底层模块</strong></p>

<p>tornado.ioloop — 核心的I/O循环</p>

<p>tornado.iostream — 对非阻塞式的 socket 的简单封装，以方便常用读写操作</p>

<p>tornado.httpclient — 一个无阻塞的HTTP服务器实现</p>

<p>tornado.netutil — 一些网络应用的实现，主要实现TCPServer类</p>

<p><strong>Integration with other services</strong></p>

<p>tornado.auth — 使用OpenId和OAuth进行第三方登录</p>

<p>tornado.database — 简单的MySQL服务端封装</p>

<p>tornado.platform.twisted — 在Tornado上运行为Twisted实现的代码</p>

<p>tornado.websocket — 实现和浏览器的双向通信</p>

<p>tornado.wsgi — 与其他python网络框架/服务器的相互操作</p>

<p><strong>Utilities</strong></p>

<p>tornado.autoreload — 生产环境中自动检查代码更新</p>

<p>tornado.gen — 一个基于生成器的接口，使用该模块保证代码异步运行</p>

<p>tornado.httputil — 分析HTTP请求内容</p>

<p>tornado.options — 解析终端参数</p>

<p>tornado.process — 多进程实现的封装</p>

<p>tornado.stack_context — 用于异步环境中对回调函数的上下文保存、异常处理</p>

<p>tornado.testing — 单元测试</p>
