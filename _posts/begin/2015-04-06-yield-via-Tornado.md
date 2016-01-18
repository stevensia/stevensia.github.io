---
layout: post
title: "深入理解yield(三)：yield与基于Tornado的异步回调"
description: "深入理解yield(三)：yield与基于Tornado的异步回调"
category: "Python"
tags: [Python]
---

<p>在<a href="http://blog.beginman.cn/blog/133/"> 深入理解yield(二)：yield与协程</a> 和<a href="http://blog.beginman.cn/blog/132/">深入理解yield(一)：yield原理</a>已经对yield原理及在python中的运用了解了很多，那么接下来就要结合Tornado,进行python异步的分析。</p>

<h2>一.异步的实现</h2>

<p>异步的实现离不开回调函数，接下来介绍回调函数的概念以及在python中的使用。</p>

<blockquote>
  <p>软件模块之间总是存在着一定的接口，从调用方式上，可以把他们分为三类：同步调用、回调和异步调用。同步调用是一种阻塞式调用，调用方要等待对方执行完毕才返回，它是一种单向调用；回调是一种双向调用模式，也就是说，被调用方在接口被调用时也会调用对方的接口；异步调用是一种类似消息或事件的机制，不过它的调用方向刚好相反，接口的服务在收到某种讯息或发生某种事件时，会主动通知客户方（即调用客户方的接口）。回调和异步调用的关系非常紧密，通常我们使用回调来实现异步消息的注册，通过异步调用来实现消息的通知。同步调用是三者当中最简单的，而回调又常常是异步调用的基础，</p>
</blockquote>

<!--more-->

<p>可以参阅<a href="http://blog.csdn.net/dan_blog/article/details/7897852"> 同步调用、回调和异步调用区别</a>加深理解。</p>

<p><img src="https://www.ibm.com/developerworks/cn/linux/l-callback/images/image001.gif" alt="" /></p>

<p>图片来源：https://www.ibm.com/developerworks/cn/linux/l-callback/</p>

<p>有时候对回调这个概念比较模糊，在知乎上<a href="回调函数（callback）是什么？">回调函数（callback）是什么？</a>,举了一个很好的例子：</p>

<blockquote>
  <p>你到一个商店买东西，刚好你要的东西没有货，于是你在店员那里留下了你的电话，过了几天店里有货了，店员就打了你的电话，然后你接到电话后就到店里去取了货。在这个例子里，你的电话号码就叫回调函数，你把电话留给店员就叫登记回调函数，店里后来有货了叫做触发了回调关联的事件，店员给你打电话叫做调用回调函数，你到店里去取货叫做响应回调事件。</p>
</blockquote>

<p>下面举一个Python的回调例子</p>

<pre><code># coding=utf-8
__author__ = 'fang'

def call_back(value):
    print 'call back value:', value

def caller(func, arg):
    print 'caller'
    func(arg)

caller(call_back, 'hello,world')
</code></pre>

<h2>Tornado异步</h2>

<p>tornado提供了一套异步机制，<code>asynchronous</code>装饰器能够使其异步，tornado默认在get()或者post()返回后自动结束HTTP请求（默认在函数处理返回时关闭客户端的连接），当装饰器给定，在函数返回时response不会结束，self.finish()去结束HTTP请求，它的主要工作就是将 RequestHandler 的 _auto_finish 属性置为 false。</p>

<p>如下例子：</p>

<pre><code>#同步阻塞版本
def MainHandler(tornado.web.RequestHandler):
    def get(self):
        client = tornado.httpclient.HttpClient()
        # 阻塞
        response = client.fetch("http://www.google.com/")
        self.write('Hello World')
</code></pre>

<p>这个例子就不在啰嗦了，整体性能就在于访问google的时间.下面展示异步非阻塞的例子：</p>

<pre><code>def MainHandler(tornado.web.RequestHandler):
    @tornado.web.asynchronous
    def get(self):
        client = tornado.httpclient.AsyncHTTPClient()
            def callback(response):
                self.write("Hello World")
                self.finish()

    client.fetch("http://www.google.com/", callback)
</code></pre>

<p>fetch的时候提供callback函数，这样当fetch http请求完成的时候才会去调用callback，而不会阻塞。callback调用完成之后通过finish结束与client的连接。</p>

<p><strong>这种异步回调的缺点就是：拆分代码逻辑，多重回调的繁琐</strong>，能不能有一套方案像正常执行逻辑一样使异步能够顺序化去执行呢？在上面的两节yield的学习中可知：<strong>因为yield很方便的提供了一套函数挂起，运行的机制，所以我们能够通过yield来将原本是异步的流程变成同步的。</strong>，在tornado中具体表现为<code>tornado.gen</code>.</p>

<pre><code>def MainHandler(tornado.web.RequestHandler):
@tornado.web.asynchronous
@tornado.gen.engine
def get(self):
    client = tornado.httpclient.AsyncHTTPClient()
    response = yield tornado.gen.Task(client.fetch, "http://www.google.com/")
    self.write("Hello World")
    self.finish()
</code></pre>

<p>使用gen.engine的decorator，该函数主要就是用来管理generator的流程控制。
使用了gen.Task，在gen.Task内部，会生成一个callback函数，传给async fetch，并执行fetch，因为fetch是一个异步操作，所以会很快返回。
在gen.Task返回之后使用yield，挂起
当fetch的callback执行之后，唤醒挂起的流程继续执行.</p>

<p>那么接下来分析<code>gen</code>源码：</p>

<pre><code>def engine(func):
    """Decorator for asynchronous generators.
    异步generators装饰器
    任何从这个module生产的生成器必须被这个装饰器所装饰。这个装饰器只用于已经是异步的函数
    如：
    @tornado.web.asynchronous
    @tornado.gen.engine
    def get(RequestHandler):  #http method.
        pass

    源码分析：http://blog.xiaogaozi.org/2012/09/21/understanding-tornado-dot-gen/

    Any generator that yields objects from this module must be wrapped in this decorator.  The decorator only works on functions that are already asynchronous.  For `~tornado.web.RequestHandler```get``/``post``/etc methods, this means that both the `tornado.web.asynchronous` and `tornado.gen.engine` decorators must be used (for proper exception handling, ``asynchronous` should come before ``gen.engine``).  In most other cases, it means that it doesn't make sense to use ``gen.engine`` on functions that
don't already take a callback argument.
"""
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        runner = None

        def handle_exception(typ, value, tb):
            # if the function throws an exception before its first "yield"
            # (or is not a generator at all), the Runner won't exist yet.
            # However, in that case we haven't reached anything asynchronous
            # yet, so we can just let the exception propagate.
            if runner is not None:
                return runner.handle_exception(typ, value, tb)
            return False
        with ExceptionStackContext(handle_exception) as deactivate:
        # 代表被装饰的http method(如get)， 因为在之前所装饰的method 包含yield关键字，所以gen = func()是generator
        gen = func(*args, **kwargs)
        # 检查是否是generator对象
        if isinstance(gen, types.GeneratorType):
            # 虽然调用了包含yield的http method,但函数并没有立即执行,只是赋值给了gen
            # 可想而知Runner()是来启动生成器函数的,包含next(),send(),throw(),close()等方法
            runner = Runner(gen, deactivate)
            runner.run()
            return
        assert gen is None, gen
        deactivate()
        # no yield, so we're done
    return wrapper
</code></pre>

<p>了解了gen,接下来我们自己实现一个：</p>

<pre><code># coding=utf-8

__author__ = 'fang'
import tornado.ioloop
from tornado.httpclient import AsyncHTTPClient
import functools

def task(fun, url):
    return functools.partial(fun, url)

def callback(gen, response):
    try:
        print 'callback:', response
        gen.send(response)
    except StopIteration:
        pass

def sync(func):
    def wrapper():
        gen = func()
        f = gen.next()
        print 'aa', f, gen
        f(functools.partial(callback, gen))
    return wrapper

@sync
def fetch():
    response = yield task(AsyncHTTPClient().fetch, 'http://www.suhu.com')
    print '1'
    print response
    print '2'

fetch()
print 3
tornado.ioloop.IOLoop.instance().start()
</code></pre>

<p>输出：</p>

<pre><code>aa &lt;functools.partial object at 0x10a992fc8&gt; &lt;generator object fetch at 0x10a6e6460&gt;
3
callback:   HTTPResponse(code=200,request_time=0.9294881820678711,buffer=&lt;_io.BytesIO object at 0x10a9b9110&gt;......)
1
HTTPResponse(code=200,request_time=0.9294881820678711,buffer=&lt;_io.BytesIO object at 0x10a9b9110&gt;......)
2
</code></pre>

<h2>参考</h2>

<p><a href="http://blog.csdn.net/siddontang/article/details/18053967">1.学习tornado：异步</a></p>

<p><a href="http://www.zouyesheng.com/generator-for-async.html">2.使用生成器展平异步回调结构</a></p>

<p><a href="https://www.ibm.com/developerworks/cn/linux/l-callback/">3.异步消息的传递－回调机制</a></p>

<p><a href="http://blog.xiaogaozi.org/2012/09/21/understanding-tornado-dot-gen/">4.理解 tornado.gen</a></p>
