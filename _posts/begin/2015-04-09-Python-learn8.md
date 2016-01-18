---
layout: post
title: "Python生成器小结"
description: "Python生成器小结"
category: "python"
tags: [python技巧]
---

<h2>一.简单的例子</h2>

<pre><code>[python]
&amp;gt;&amp;gt;&amp;gt; def gen(lis):             # 定义一个生成器函数
...     for i in lis:
...         yield i                  # yield关键字的使用
...     
... 
&amp;gt;&amp;gt;&amp;gt; g = gen(range(5))
&amp;gt;&amp;gt;&amp;gt; g
&amp;lt;generator object gen at 0xb6a23aa4&amp;gt;
&amp;gt;&amp;gt;&amp;gt; g.next()
0
&amp;gt;&amp;gt;&amp;gt; g.next()
1
&amp;gt;&amp;gt;&amp;gt; for obj in g:           #生成器for循环
...     print obj 
...     if obj&amp;gt;3: break
...     
... 
2
3
4
&amp;gt;&amp;gt;&amp;gt; list(g)
[]
&amp;gt;&amp;gt;&amp;gt; g.next()
Traceback (most recent call last):
  File &amp;quot;&amp;lt;input&amp;gt;&amp;quot;, line 1, in &amp;lt;module&amp;gt;
StopIteration
[/python]
</code></pre>

<p>上面例子中可以看出<code>迭代器</code>的影子，<strong>生成器有着与迭代器同样的机制和方法</strong>，可以next(),能够触发<code>StopIteration</code>异常，也能够遍历元素等。</p>

<!--more-->

<h2>二.生成器的概念</h2>

<h3>1.理解</h3>

<p><img src="http://www.darkbull.net/static/upload/4/yield.jpg" alt="" /></p>

<p>我试图从wiki中找到生成器概念，但没有找到，从<a href="http://www.ibm.com/developerworks/cn/linux/sdk/python/charm-20/">可爱的 Python: 迭代器和简单生成器</a>获悉道：
<strong>Python 2.2 引进了一种带有新关键字的新型构造。这种构造是生成器；关键字是yield。生成器使几个新型、强大和富有表现力的编程习惯用法成为可能。生成器是一种迭代器，生成器最典型的用途是用来定义迭代器。</strong></p>

<h3>2.yield</h3>

<p>对于普通函数返回使用<code>return</code>,对于生成器函数则使用<code>yield</code>，而不能使用return否则就会报错。</p>

<p>一个带有 yield 的函数就是一个 generator，它和普通函数不同，生成一个 generator 看起来像函数调用，但不会执行任何函数代码，直到对其调用 next()（在 for 循环中会自动调用 next()）才开始执行。虽然执行流程仍按函数的流程执行，但每执行到一个 yield 语句就会中断，并返回一个迭代值，下次执行时从 yield 的下一个语句继续执行。看起来就好像一个函数在正常执行的过程中被 yield 中断了数次，每次中断都会通过 yield 返回当前的迭代值。
yield 的好处是显而易见的，把一个函数改写为一个 generator 就获得了迭代能力，比起用类的实例保存状态来计算下一个 next() 的值，不仅代码简洁，而且执行流程异常清晰。</p>

<pre><code>#斐波那契函数
&gt;&gt;&gt; def fib():
...     a, b = 0, 1
...     while 1:
...         yield a
...         a, b = b, a+b
...         
&gt;&gt;&gt; import itertools
&gt;&gt;&gt; list(itertools.islice(fib(), 10))
[0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
&gt;&gt;&gt; 
</code></pre>

<h3>3.生成器函数的创建</h3>

<p><strong>方式一，通过yield关键字</strong>，这个就是上面的几个例子</p>

<p><strong>方式二,生成器表达式</strong>：</p>

<p>如：</p>

<pre><code># Generator expression
(x*2 for x in range(256))

# List comprehension
[x*2 for x in range(256)]
</code></pre>

<p>生成器表达式与列表推导该使用哪个呢，请参考<a href="http://stackoverflow.com/questions/47789/generator-expressions-vs-list-comprehension?rq=1">Generator Expressions vs. List Comprehension</a></p>

<h3>4.生成器方法</h3>

<p><strong>生成器是迭代器的一种，但功能方法更胜迭代器一筹。</strong>，Python高级编程中引用了<code>协同程序（协程）</code>用来在特定环境下替换线程，关于协程的介绍参考这里<a href="http://www.cnblogs.com/huxi/archive/2011/07/14/2106863.html">http://www.cnblogs.com/huxi/archive/2011/07/14/2106863.html</a>。</p>

<p>Python 2.5对生成器的增强实现了协程的其他特点，在这个版本中，生成器加入了如下方法：</p>

<p>(1).<code>send</code></p>

<pre><code>r.send: (arg)                                                
send(arg) -&gt; send 'arg' into generator,                      
return next yielded value or raise StopIteration.
</code></pre>

<p>如：</p>

<pre><code>&gt;&gt;&gt; def repeater():
...   n = 0
...   while True:
...     n = (yield n)
...
&gt;&gt;&gt; r = repeater()
&gt;&gt;&gt; r.next()
0
&gt;&gt;&gt; r.send(10)
10
</code></pre>

<p>(2).<code>close()</code>  用于关闭生成器。对关闭的生成器后再次调用next或send将抛出StopIteration异常。</p>

<h3>5.生成器判断</h3>

<p>判断是否为生成器函数可用<code>isgeneratorfunction</code>, 判断是否为生成器对象可用<code>isgenerator</code></p>

<pre><code>&gt;&gt;&gt; from inspect import isgeneratorfunction, isgenerator
&gt;&gt;&gt; g = (i for i in range(3))
&gt;&gt;&gt; isgenerator(g)
True
&gt;&gt;&gt; isgeneratorfunction(g)
False
&gt;&gt;&gt; def foo():
...     yield 1
... 
&gt;&gt;&gt; isgenerator(foo())
True
&gt;&gt;&gt; isgeneratorfunction(foo())
False
&gt;&gt;&gt; isgeneratorfunction(foo)
True
</code></pre>

<h3>6.推荐阅读</h3>

<p>在<a href="http://www.oschina.net/translate/improve-your-python-yield-and-generators-explained">提高你的Python: 解释‘yield’和‘Generators（生成器)</a>一文中解释了为什么要用生成器，以及一些实例。总结如下：</p>

<ul>
<li><p>generator是用来产生一系列值的</p></li>
<li><p>yield则像是generator函数的返回结果</p></li>
<li><p>yield唯一所做的另一件事就是保存一个generator函数的状态</p></li>
<li><p>generator就是一个特殊类型的迭代器（iterator）</p></li>
<li><p>和迭代器相似，我们可以通过使用next()来从generator中获取下一个值</p></li>
<li><p>通过隐式地调用next()来忽略一些值</p></li>
</ul>

<h2>三.参考</h2>

<p><a href="http://www.cnblogs.com/huxi/archive/2011/07/14/2106863.html">1.Python函数式编程指南（四）：生成器</a></p>

<p><a href="https://www.ibm.com/developerworks/cn/opensource/os-cn-python-yield/">2.Python yield 使用浅析</a></p>
