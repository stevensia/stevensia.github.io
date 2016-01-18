---
layout: post
title: "tornado分析(2).web基础"
description: "tornado分析(2).web基础"
category: "tornado"
tags: [tornado]
---
<blockquote>
  <p>通常来说， Tornado中，在 RequestHandler 类里（还有其他位置）方法都不是线程安全的。特别是如： write(), finish(), 和 flush() 这几个方法只能在主线程中调用。如果你使用了多线程模式运行，就必须在请求结束前使用 IOLoop.add_callback 将控制权交给主线程。</p>
</blockquote>

<!--more-->

<h1>处理句柄类</h1>

<p><code>class tornado.web.RequestHandler(application, request, **kwargs)</code></p>

<p><strong>编写该类的子类，并且定义 get() 或 post() 方法来处理请求。</strong></p>

<p>一些重要的方法，可分为<code>初始</code>,<code>输入</code>，<code>输出</code>,<code>cookie</code>，和其他操作。最后我们要总结Application配置文件进行整个tornado web服务的学习。</p>

<h2>1.初始操作</h2>

<p>初始是完成整个http请求之前或请求时，或返回response之前。除了<code>get()</code>,<code>post</code>,<code>put()</code>,<code>delete()</code>,<code>head()</code>,<code>options()</code>这几个常用的http方法外，主要还有<code>initialize()</code>,<code>prepare()</code>,<code>on_finish()</code>等。</p>

<h3>1.1 initialize</h3>

<p>子类的初始化函数，会在任何HTTP方法之前最先被调用,URL规范的第三个字典类型参数将会作为参数传给initialize() 函数。</p>

<p>这个方法在上一节：<a href="http://www.beginman.cn/archives/490">tornado分析(1).基础:3.2 RequestHandler 子类</a> 已经说过。</p>

<h3>1.2 prepare</h3>

<p>在http请求方法get,或post等之前，在initialize之后被调用。在3.1版本中增加了异步支持，通过<code>gen.coroutine</code>装饰器或<code>return_future</code>使其异步，（ asynchronous不能作用其上），如果该方法返回<code>Future</code>执行将不再进行直到<code>Future</code>完成。</p>

<p>todo: 这块尚未验证过.</p>

<h3>1.3 on_finish</h3>

<p>该方法在请求之后调用，重写该方法可以用于清除数据，处理日志等应用场景，这个方法与<code>prepare</code>是相对的。</p>

<h2>2.输入</h2>

<p>如：<code>get_argument(name, default=[], strip=True)</code></p>

<p>这个方法比较好理解，不过要注意几点：</p>

<ol>
<li>如果多个相匹配的url则取最后一个</li>
<li>默认不需要对返回值进行去除首尾空格，strip=True已经约定好了</li>
<li>返回值是<code>unicode</code>类型</li>
</ol>

<p>对于<code>get_arguments(name)</code>，<code>get_query_argument(name, default=[], strip=True)</code>，<code>get_query_arguments(name, strip=True)</code>,<code>get_body_argument(name, default=[], strip=True)</code>(get from request body.),<code>get_body_arguments(name, strip=True)</code>则一致，<a href="http://www.tornadoweb.org/en/stable/web.html">更加细粒查看文档</a></p>

<p>还有一个<code>decode_argument(value, name=None)</code>用于解码请求参数，By default, this method decodes the argument as utf-8 and returns a unicode string,这种方法被用作用于get_argument（）的过滤器，用于从URL中提取的值，并传递到获得get（）/post（）/等。如：</p>

<pre><code>nn = self.get_argument('name')
nn =  self.decode_argument(nn)
</code></pre>

<p>这个方法用的真少。</p>

<p>接下来是<code>request</code>对象，包含额外的请求参数如 headers and body data.如下实例：</p>

<pre><code>HTTPServerRequest(
    protocol='http', 
    host='127.0.0.1:8000', 
    method='GET', 
    uri='/?name=%20jack%20', 
    version='HTTP/1.1', 
    remote_ip='127.0.0.1', 
    headers={'Accept-Language': 'zh-CN,zh;q=0.8,en;q=0.6', 
            'Accept-Encoding': 'gzip, deflate, sdch', 
            'Host': '127.0.0.1:8000', 
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/4.36',         
            'Connection': 'keep-alive', 
            'Cookie': '__atuvc=3%7C15; session=.eJxxxxxJjabpC-tfQEQ.CFBT2w.tkj8xJijDt9rhLXCwldUhR6YveI; _xsrf=2|9303dcdb|e3573d513179d4f9afffbb7e2667ea64|1433406645',     'Cache-Control': 'max-age=0', 
            'If-None-Match': '"d03a799d49e1c7bae29464e6392b38a06404f157"'})
</code></pre>

<p>你们获取所有请求参数可以这样写：</p>

<pre><code>print {k:''.join(v) for k,v in self.request.arguments.iteritems()}
</code></pre>

<h2>3.输出</h2>

<p>所谓输出就是对请求结果response的操作。总结如下：</p>

<h3>3.1 set_status(status_code, reason=None)</h3>

<p>设置状态码,关于状态码查看<a href="http://www.w3school.com.cn/tags/html_ref_httpmessages.asp">Http状态码</a>,状态码由两部分组成：code和描述，如请求成功则：Headers中General会标明：<code>Status Code:200 OK</code></p>

<p>我们手动控制：</p>

<pre><code>self.set_status(200)
</code></pre>

<p>出现的效果同上，我们再自定义描述信息如：</p>

<pre><code>self.set_status(200, 'great....')
</code></pre>

<p>则在Headers中General会标明：<code>Status Code:200 great....</code>信息。</p>

<h3>3.2 set_header(name, value)</h3>

<blockquote>
  <p>http就整个网络资源传输而言，包括message-header和message-body两部分。首先传递message- header，即http header消息 。http header 消息通常被分为4个部分：general  header, request header, response header, entity header。但是这种分法就理解而言，感觉界限不太明确。根据维基百科对http header内容的组织形式，大体分为Request和Response两部分。</p>
</blockquote>

<p>关于HTTP Header这里参考了<a href="http://kb.cnblogs.com/page/92320/">HTTP Header 详解</a></p>

<h3>3.3 add_header(name, value)</h3>

<p>相当于自定义header,可重复，如下实例：</p>

<pre><code>self.set_header('ETag', '111111111')
self.add_header('author', 'beginman')
self.add_header('author', 'beginman')
self.add_header('author', 'fang')
</code></pre>

<p>在浏览器Reponse header中的表现如下：</p>

<pre><code>Author:beginman
Author:beginman
Author:fang
Content-Length:387
Content-Type:text/html; charset=UTF-8
Date:Tue, 09 Jun 2015 10:35:11 GMT
Etag:111111111
Server:TornadoServer/4.0.2
</code></pre>

<h3>3.4 clear_header(name)</h3>

<p>清除你自定义的header。标准的header是无法清除的.如<code>self.clear_header('author')</code></p>

<h3>3.5 write(chunk)</h3>

<p>写入给定块到输出缓冲器，如果给定块是字典则作为JSON输出，且设置Content-Type：<code>application/json</code>,注意list不能装换json,因为一个潜在的跨站点安全漏洞到JSON,所有都需包含在一个字典内。</p>

<h3>3.6 flush(include_footers=False, callback=None)</h3>

<p>Flushes the current output buffer to the network.<code>callback</code>用于控制流，如果给定则当所有数据被flushed 到socket后才执行。</p>

<blockquote>
  <p>Note that only one flush callback can be outstanding at a time; if another flush occurs before the previous flush’s callback has been run, the previous callback will be discarded.在 4.0 版更改: Now returns a Future if no callback is given.</p>
</blockquote>

<h3>3.7 finish(chunk=None)</h3>

<p>Finishes this response, ending the HTTP request.</p>

<h3>3.8 render(template_name, **kwargs)</h3>

<p>Renders the template with the given arguments as the response.</p>

<p>源码如下：</p>

<pre><code>def render(self, template_name, **kwargs):
    """Renders the template with the given arguments as the response."""
    html = self.render_string(template_name, **kwargs)
    ....
    self.finish(html)
</code></pre>

<h3>3.9 render_string(template_name, **kwargs)</h3>

<p>通过给定的参数生成给定的模块， 返回生成后的byte字符串，在<code>render()</code>方法之上执行，生成和写入一个模块作为响应.</p>

<h3>3.10 redirect(url, permanent=False, status=None)</h3>

<p>跳转url，<code>permanent</code>:永久性，<code>status</code>:状态码，301 (permanent) or 302 (temporary) ，默认是302.</p>

<h3>3.11 send_error(status_code=500, **kwargs)</h3>

<p>Sends the given HTTP error code to the browser.</p>

<h3>3.12 write_error(status_code, **kwargs)</h3>

<p>Override to implement custom error pages.</p>

<h3>3.13 clear()</h3>

<p>Resets all headers and content for this response.</p>

<h3>3.14 data_received(chunk)</h3>

<p>实现此方法来处理流请求数据。<em>todo:这个方法没有实现过</em></p>

<p><strong>关于<a href="http://www.tornadoweb.org/en/stable/web.html#cookies">cookie参考文档</a>以及源码</strong></p>
