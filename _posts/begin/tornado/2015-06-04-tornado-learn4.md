---
layout: post
title: "tornado分析(1).基础小结"
description: "tornado分析(1).基础小结"
category: "tornado"
tags: [tornado]
---
<p>主要模块：</p>

<ol>
<li><code>web</code>: 最重要的模块，是tornado web框架</li>
<li><code>escape</code>:  XHTML, JSON, URL 的编码/解码方法</li>
<li><code>template</code>: web 模板系统 </li>
<li><code>httpclient</code> : 非阻塞式 HTTP 客户端，它被设计用来和 web 及 httpserver 协同工作</li>
<li><code>auth</code>: 第三方认证的实现（包括 Google OpenID/OAuth、Facebook Platform、Yahoo BBAuth、FriendFeed OpenID/OAuth、Twitter OAuth）</li>
<li><code>locale</code>: 针对本地化和翻译的支持</li>
<li><code>options</code>: 命令行和配置文件解析工具，针对服务器环境做了优化</li>
<li><code>httpserver</code>: 服务于 web 模块的一个非常简单的 HTTP 服务器的实现</li>
<li><code>iostream</code>: 对非阻塞式的 socket 的简单封装，以方便常用读写操作</li>
<li><code>ioloop</code>: 核心的 I/O 循环</li>
</ol>

<p>下面从异步非阻塞I/O, 协程, tornado队列,web应用的结构，模板和UI，认证和安全，运行部署这几个方面进行总结，其实也就是对tornado文档：<a href="http://www.tornadoweb.org/en/stable/guide.html">User’s guide的总结</a>.同时会配合<a href="https://github.com/tornadoweb/tornado">tornado源码</a>进行源码剖析，对<a href="https://github.com/tornadoweb/tornado/tree/master/demos">tornado demo</a>进行研究学习。</p>

<h1>一.异步和非阻塞I/O</h1>

<p>Asynchronous and non-Blocking I/O</p>

<p>实时网络(Real-time)需要一个<code>long-lived</code>且大多时间是空闲的(mostly-idle)连接，且为每个用户都分发了一个（给每个用户一个线程），对于传统的web同步服务器(synchronous web server)是很不适宜的。为了最大限度减少并发连接成本，<strong>tornado采用单线程事件循环( single-threaded event loop)，意味着我们所有的程序都应该是异步和非阻塞的</strong>。</p>

<h2>1.1 如何理解tornado异步非阻塞</h2>

<p>关于这个参考：<a href="http://www.zhihu.com/question/19732473">怎样理解阻塞非阻塞与同步异步的区别？</a></p>

<blockquote>
  <p>在处理 IO 的时候，阻塞和非阻塞都是同步 IO。只有使用了特殊的 API 才是异步 IO。</p>
</blockquote>

<p><img src="http://pic2.zhimg.com/7d3eb389b7724878bd7e12ebc6dbcdb5_b.jpg" alt="" /></p>

<h2>1.2 阻塞</h2>

<p>阻塞的理解相对简单，如网络I/O, 磁盘I/O等导致的程序阻塞。</p>

<h2>1.3 异步</h2>

<p><strong>一个异步的函数会在它执行完成之后就先返回（Return），并且在触发一些即将发生的应用程序中的行为之前，通常会在后台进行一系列的工作（而对于正常的 同步 函数来说，任何工作都是在程序返回之前完成的）</strong>。 下面列举了几种不同的异步接口的开发方式：</p>

<ul>
<li>回调参数（Callback argument）</li>
<li>返回一个占位符 (<a href="http://tornadocn.readthedocs.org/zh/latest/concurrent.html#tornado.concurrent.Future">Future</a>, Promise, Deferred)</li>
<li>传送到队列</li>
<li>回调注册表 (比如 POSIX 信号)</li>
</ul>

<p>这几种方式可以参考<a href="http://www.beginman.cn/archives/486">tornado异步方案</a>, 关于占位符(Future),可以使用它替代回调方式</p>

<pre><code>from tornado.concurrent import Future

def async_fetch_future(url):
    http_client = AsyncHTTPClient()
    my_future = Future()
    fetch_future = http_client.fetch(url)
    fetch_future.add_done_callback(
        lambda f: my_future.set_result(f.result()))
    return my_future
</code></pre>

<h1>二.协程(Coroutines)</h1>

<blockquote>
  <p>在Tornado中 推荐使用 协程 进行异步代码的开发。协程使用Python的 yield 关键字将程序挂起和恢复执行，从而代替使用一连串的回调方式（ 像在 gevent 中出现的轻量级线程合作的方式有时也被成为协程，但是在Tornado中所有的协程使用显式上下文切换，并且被称为异步函数。使用协程开发是最接近于同步开发的方式，并且不用浪费额外的线程。 并且通过减少上下文转换的频率，协程 使并发编程变得更容易 。</p>
</blockquote>

<pre><code># 引入协程库gen
from tornado import gen

# 使用gen.coroutine修饰器
@gen.coroutine
def fetch_coroutine(url):
    http_client = AsyncHTTPClient()
    response = yield http_client.fetch(url)
    # 在Python 3.3版本之前，在生成器中是不允许有返回值的
    #（既不允许在有生成器的函数内，使用return语句，Python解释器会报错）
    # 所以，必须通过使用抛出异常的方式代替
    # 如使用 raise gen.Return(response.body）
    return response.body
</code></pre>

<p>关于协程的概念，可参考：</p>

<ul>
<li><a href="http://www.beginman.cn/archives/73">深入理解yield(一)：yield原理</a></li>
<li><a href="http://www.beginman.cn/archives/71">深入理解yield(二)：yield与协程</a></li>
<li><a href="http://www.beginman.cn/archives/69">深入理解yield(三)：yield与基于Tornado的异步回调</a></li>
</ul>

<p>关于协程这一块的文档说明参考:<a href="http://tornadocn.readthedocs.org/zh/latest/guide/coroutines.html">http://tornadocn.readthedocs.org/zh/latest/guide/coroutines.html</a></p>

<p><em>todo： 回头整理这部分关于协程的东西</em></p>

<h1>三.Tornado web应用程序架构</h1>

<p>tornado web 程序一般由<code>RequestHandler</code>子类定义请求方法，<code>Application</code>对象定义路由规则，<code>main()</code> 控制启动。</p>

<h2>3.1 Application 对象</h2>

<p>Application 对象负责全局的配置，包括所有请求到句柄的路由映射表。关于路由是一些<code>URLSpec</code>对象组成的列表(或元祖),</p>

<pre><code>class tornado.web.URLSpec(pattern, handler, kwargs=None, name=None):
    """
    pattern：路由规则
    handler： RequestHandler子类
    kwargs: 它将会作为 初始化参数 传递给 RequestHandler.initialize 方法
    name: 这个handler的名称，Used by Application.reverse_url.
    """
</code></pre>

<p>如下实例：</p>

<pre><code>class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write('&lt;a href="%s"&gt; like to story 1 &lt;/a&gt;' %
            # 通过查找 `.URLSpec` 对象名称story，找到对应的URL，并且传入参数1
            self.reverse_url('story', '1')
        )

class StoryHandler(tornado.web.RequestHandler):
    #`.URLSpec` 对象 中传入的第三个字典参数直接传递给initialize方法
    def initialize(self, db):
        self.db = db

    def get(self, story_id):
        self.write("this is story %s and db is %s" % (story_id, self.db))


# ...
app = tornado.web.Application(
        handlers=[
            (r"/", MainHandler),
            (r"/story/([0-9]+)", StoryHandler, dict(db='demo'), 'story'),
        ])
</code></pre>

<h2>3.2 RequestHandler 子类</h2>

<p>用来处理HTTP方法，常用方法如：</p>

<p><code>render()</code>:加载<code>Template</code>对象并通过传入的参数进行渲染</p>

<p><code>write()</code>: 作为不使用模板时的基本输出，支持输入字符串、字节流或者字典（字典将会被编码成JSON格式）</p>

<p><code>write_error()</code>:用来在错误页面输出HTML代码。</p>

<p>通过<code>self.request</code>查看当前对象的请求数据, 如通过下面方法查看所有请求的数据</p>

<pre><code> {k:''.join(v) for k,v in self.request.arguments.iteritems()}
</code></pre>

<p>使用HTML forms形式的请求数据将会被解析，可以通过使用如 <code>get_query_argument</code>（get方法使用) 和 <code>get_body_argument</code> (post方法使用) 方法获取请求数据。</p>

<p>关于文件这块，可以参考<a href="http://www.beginman.cn/archives/45">tornado文件上传</a></p>

<p>其请求流程如下：</p>

<ol>
<li>在每一次请求中，一个新的 RequestHandler 对象都会被创建。</li>
<li>initialize() 会被优先调用，在 Application 里面配置的字典参数会作为该方法的输入参数。initialize 初始化操作通常只是将输入的参数传递该类对象的成员变量保存，而不应该产生任何的输出和方法调用。</li>
<li>之后 prepare() 方法会被调用。 无论哪一个HTTP方法被使用， prepare 都会被调用，它是在所有自定义的子类中共享的最有用的方法。可以使用 prepare 方法产生输入；如果在该方法中调用了 finish （或者 redirect 等）方法，本次处理就会在这停止。</li>
<li>接下来 get(), post(), put() 等HTTP方法将会被调用，如果URL的正则表达式包含了捕获组，将会将其作为参数传给对应的方法。</li>
<li>当请求处理完成时， on_finish() 方法会被调用。对于同步的请求来说，在 get() (等)方法返回后会立刻执行；而对于异步请求，它会在调用 finish() 方法完成后才执行。</li>
</ol>

<h1>四.模板和UI</h1>

<p>Tornado在所有模板中默认提供了一些便利的函数。它们包括：</p>

<ul>
<li><code>escape(s)</code> 替换字符串s中的&amp;、&lt;、>为他们对应的HTML字符。是<code>tornado.escape.xhtml_escape</code> 的别名</li>
<li><code>url_escape(s)</code> 使用urllib.quote_plus替换字符串s中的字符为URL编码形式, 是<code>tornado.escape.url_escape</code> 的别名</li>
<li><code>json_encode(val)</code> 将val编码成JSON格式。（在系统底层，这是一个对json库的dumps函数的调用), 是<code>tornado.escape.json_encode</code> 的别名</li>
<li><code>squeeze(s)</code> 过滤字符串s，把连续的多个空白字符替换成一个空格。是<code>tornado.escape.squeeze</code>的别名</li>
<li><code>linkify(s, url)</code> 是<code>tornado.escape.linkify</code>缩写，如：<code>linkify("Hello http://tornadoweb.org!")</code> 会返回 <code>Hello &lt;a href="http://tornadoweb.org"&gt;http://tornadoweb.org&lt;/a&gt;!</code></li>
<li><code>datetime</code>: 是 Python 的 datetime 模块</li>
<li><code>handler</code>: 当前的 RequestHandler 对象</li>
<li><code>request</code>: handler.request 的别名</li>
<li><code>current_user</code>: handler.current_user 的别名</li>
<li><code>locale</code>: handler.locale 的别名</li>
<li><code>_</code>: handler.locale.translate 的别名，关于本地化，如设置多语言在后期会总结</li>
<li><code>static_url</code>: handler.static_url 的别名</li>
<li><code>xsrf_form_html</code>: handler.xsrf_form_html 的别名</li>
<li><code>reverse_url</code>: Application.reverse_url 的别名</li>
<li>所有来自<code>ui_methods</code>项和 <code>ui_modules</code> 的 <code>Application</code>设置</li>
<li>所有传给 render 或 render_string 方法的关键字</li>
</ul>

<blockquote>
  <p>默认情况下，所有的模板输出的时候都会使用 <code>tornado.escape.xhtml_escape</code> 函数加密。这个行为可以通过传递 <code>autoescape=None</code> 给 Application 设置或者 <code>tornado.template.Loader</code> 的构造函数来关闭，也可以使用 <code>`autoescape None`</code> 命令仅在某个模板文件中关闭该功能，或者使用 <code>`raw`</code> 替换  从而在某个单独的表达式中关闭该功能。</p>
</blockquote>

<p>Tornado自动的模板加密有助于避免 XSS 漏洞,但并非一劳永逸，关于tornado安全性将会在后期进行总结。</p>

<p>UI,这块参考<a href="http://demo.pythoner.com/itt2zh/ch3.html#ch3-2">http://demo.pythoner.com/itt2zh/ch3.html#ch3-2</a></p>

<h1>五.认证和安全</h1>

<p>在《白帽子讲web安全》第9章 认证与会话管理中讲到：</p>

<blockquote>
  <p>很多时候，人们会把“认证”和“授权”两个概念搞混，甚至有些安全工程师也是如此。实际上“认证”和“授权”是两件事情，认证的英文是 Authentication，授权则是Authorization。分清楚这两个概念其实很简单，只需要记住下面这个事实：<strong>认证的目的是为了认出用户是谁，而授权的目的是为了决定用户能够做什么。</strong></p>
</blockquote>

<p>当登录完成后，用户访问网站的页面，不可能每次浏览器请求页面时都再使用密码认证一次。因此，<strong>当认证成功后，就需要替换一个对用户透明的凭证。这个凭证，就是SessionID</strong>。</p>

<p>当用户登录完成后，在服务器端就会创建一个新的会话（Session），会话中会保存用户的状态和相关信息。服务器端维护所有在线用户的Session，此时的认证，只需要知道是哪个用户在浏览当前的页面即可。为了告诉服务器应该使用哪一个Session，浏览器需要把当前用户持有的SessionID告知服务器。</p>

<p><strong>最常见的做法就是把SessionID加密后保存在Cookie中，因为Cookie会随着HTTP请求头发送，且受到浏览器同源策略的保护,SessionID除了可以保存在Cookie中外，还可以保存在URL中，作为请求的一个参数。但是这种方式的安全性难以经受考验.在手机操作系统中，由于很多手机浏览器暂不支持Cookie，所以只能将SessionID作为URL的一个参数用于认证</strong></p>
