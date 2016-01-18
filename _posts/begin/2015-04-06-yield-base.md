---
layout: post
title: "深入理解yield(一)：yield原理"
description: "深入理解yield(一)：yield原理"
category: "Python"
tags: [Python]
---

<h2>一.yield基础</h2>

<p>某个函数包含了yield，这意味着这个函数已经是一个Generator，它的执行会和其他普通的函数有很多不同。比如下面的简单的函数：</p>

<pre><code>def foo():
    print 'exec 1'
    yield 1
    print 'done!'
&gt;&gt;&gt; f = foo()   # 函数内代码并不会立即执行
&gt;&gt;&gt; print f # 输出&lt;generator object foo at 0x10f1dad20&gt;
</code></pre>

<p>那如何才能执行函数呢？可以通过<code>next()</code>方法执行：</p>

<pre><code>&gt;&gt;&gt; f = foo()
&gt;&gt;&gt; f.next()
exec 1
1
&gt;&gt;&gt; f.next()
done!
Traceback (most recent call last):
File "&lt;stdin&gt;", line 1, in &lt;module&gt;
StopIteration
</code></pre>

<p><code>next()</code>:通过next()语句让它执行。next()语句将恢复Generator执行，并直到下一个yield表达式处, 如果后面没有yield了，因此会拋出StopIteration异常.</p>

<p><code>send(mgs)</code>: 其实next()和send()在一定意义上作用是相似的，区别是send()可以传递yield表达式的值进去，而next()不能传递特定的值，只能传递None进去。因此，我们可以看做 c.next() 和 c.send(None) 作用是一样的。</p>

<!--more-->

<p><code>next()</code>或<code>send(arg)</code>能够使其开始执行， 执行遇到<code>yield</code>即保存状态挂起，直到再执行<code>next()</code>或<code>send(arg)</code>方法使其从挂起的位置继续执行，然后执行遇到<code>yield</code>又保存状态挂起....依次类推。</p>

<pre><code>def foo():
    print 'exec 1'
    m = yield 1
    print m

    print 'exec 2'
    n = yield 2
    print n
    print 'done!'

f = foo()
print f
f.next()
f.send('ok')
f.next()
</code></pre>

<p>上面执行流程可以通过<a href="http://pythontutor.com/visualize.html#mode=edit">http://pythontutor.com/visualize.html#mode=edit</a>进行查看.</p>

<p><img src="http://images.cnblogs.com/cnblogs_com/BeginMan/486940/o_yield.gif" alt="" /></p>

<p>注意：不能使用send发送一个非None的值，否则会出错的，因为没有yield语句来接收这个值。</p>

<p><strong>send(msg) 和 next()是有返回值的，它们的返回值很特殊，返回的是下一个yield表达式的参数</strong>。比如yield 5，则返回 5.</p>

<pre><code>&gt;&gt;&gt; def foo():
...     m = yield 5
...     print m
...     d = yield 12
...     
... 
&gt;&gt;&gt; f = foo()
&gt;&gt;&gt; m = f.next()
&gt;&gt;&gt; m
5
&gt;&gt;&gt; d = f.send('fun')
fun 
&gt;&gt;&gt; d
12
</code></pre>

<p>文档地址:<a href="https://docs.python.org/2/reference/expressions.html#generator-iterator-methods">Generator-iterator methods</a></p>

<p>处理generator.next(), generator.send(value),这里还有两个方法不是那么常用，一个是generator.throw(type[, value[, traceback]]), 一个是generator.close()。</p>

<blockquote>
  <p><code>generator.throw(type[, value[, traceback]])</code></p>
  
  <p>Raises an exception of type type at the point where generator was paused, and returns the next value yielded by the generator function. If the generator exits without yielding another value, a StopIteration exception is raised. If the generator function does not catch the passed-in exception, or raises a different exception, then that exception propagates to the caller.</p>
  
  <p><code>generator.close()</code></p>
  
  <p>Raises a GeneratorExit at the point where the generator function was paused. If the generator function then raises StopIteration (by exiting normally, or due to already being closed) or GeneratorExit (by not catching the exception), close returns to its caller. If the generator yields a value, a RuntimeError is raised. If the generator raises any other exception, it is propagated to the caller. close() does nothing if the generator has already exited due to an exception or normal exit.</p>
</blockquote>

<p>如下实例：</p>

<pre><code># coding=utf-8
__author__ = 'fang'
def foo(value=None):
    try:
        while 1:
            try:
                value = yield value
            except Exception, e:
                value = e 
                print 'ssss', value
    finally:
        print "Don't forget to clean up when 'close()' is called"

f = foo(1)
print f.next()          # 1
print f.next()          # None
print f.send('foo')     # foo
print f.throw(TypeError, 'error')   # ssss error
f.close()               # Don't forget to clean up when 'close()' is called
</code></pre>
