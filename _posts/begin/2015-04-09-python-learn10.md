---
layout: post
title: "python迭代器小结"
description: "python迭代器小结"
category: "python"
tags: [python技巧]
---

<p><img src="http://img6.cache.netease.com/video/2012/9/29/20120929164524f8660.jpg" alt="" /></p>

<h2>1.一个简单的例子</h2>

<pre><code>[python]
i = iter(range(10))  # 内建函数iter 生成迭代器，吃了一堆元素
&amp;gt;&amp;gt;&amp;gt; i
&amp;lt;listiterator object at 0xb69aeder&amp;gt;
&amp;gt;&amp;gt;&amp;gt; i.next()  # 吐出一个
0
&amp;gt;&amp;gt;&amp;gt; i.next()  # 又吐出了一个
1
..
&amp;gt;&amp;gt;&amp;gt; list(i)  # 剩下的全部吐出来
[2, 3, 4, 5, 6, 7, 8, 9]

&amp;gt;&amp;gt;&amp;gt; i.next()  # 胃空空，再吐就吐出肠子了
Traceback (most recent call last):
File &amp;quot;&amp;lt;input&amp;gt;&amp;quot;, line 1, in &amp;lt;module&amp;gt;
StopIteration
&amp;gt;&amp;gt;&amp;gt; 

&amp;gt;&amp;gt;&amp;gt; r = range(10)  # 全在胃里
&amp;gt;&amp;gt;&amp;gt; r
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
&amp;gt;&amp;gt;&amp;gt; r.pop()        # 吐掉最后一个
9
&amp;gt;&amp;gt;&amp;gt; r.pop()        # 吐掉最后一个
8
&amp;gt;&amp;gt;&amp;gt; r.pop()
7
&amp;gt;&amp;gt;&amp;gt; r
[0, 1, 2, 3, 4, 5, 6]
[/python]
</code></pre>

<!--more-->

<p>从上面代码可以看出，迭代器属于一个临时区，安排一些元素在里面，但只用用的时候才会创建一些临时区，一旦遍历结束则临时区清空，再遍历就失效了。所以说迭代器能够减少内存的开销，只用用的时候才会创建，而且是一块一块的，就如上传视频，可以一段一段上传，也可以整个一下子都上传，而迭代器就属于一段一段的。可以看看它的内存占用：</p>

<pre><code>&gt;&gt;&gt; import sys
&gt;&gt;&gt; i = iter(range(1000000))
&gt;&gt;&gt; sys.getsizeof(i)
28

&gt;&gt;&gt; r = range(1000000) # 全部塞入内存中
&gt;&gt;&gt; sys.getsizeof(r)
4000032
</code></pre>

<p><strong>这是改善Python性能的一个知识点，对于大数据如几个G的数据最好采用迭代器。</strong>，这种方式叫<strong>惰性计算</strong>。</p>

<h2>2迭代器简介</h2>

<p>从wiki中引述：</p>

<blockquote>
  <p>迭代器（iterator）有时又称游标（cursor）是<strong>程式设计的软件设计模式</strong>，可在容器物件（container，例如链表或阵列）上遍访的<strong>接口</strong>，设计人员无需关心容器物件的内存分配的实现细节。</p>
  
  <p>各种语言实作迭代器的方式皆不尽同，有些面向对象语言像<strong>Java, C#, Ruby, Python, Delphi都已将迭代器的特性内建语言当中，完美的跟语言整合，我们称之隐式迭代器（implicit iterator）</strong>，但像是C++语言本身就没有迭代器的特色。</p>
</blockquote>

<p><strong>概述：</strong>从上面例子和wiki可分析出，迭代器就是访问集合元素，一种惰性加载元素的方式。<strong>从根本上说，迭代器就是有一个next()方法的对象，而不是通过索引来计数的</strong>。</p>

<h2>3. 迭代器的创建</h2>

<p>在 Python 中，迭代器是遵循迭代协议的对象。使用 iter() 从任何序列对象中得到迭代器（如 list, tuple, dictionary, set 等）。另一种形式的输入迭代器是generator 。</p>

<h4>方式1 内置函数<code>iter()</code></h4>

<pre><code>with open('mydata.txt') as fp:
    for line in iter(fp.readline, ''):
        process_line(line)
</code></pre>

<p><code>iter()</code>语法在这里:<a href="https://docs.python.org/2/library/functions.html#iter">https://docs.python.org/2/library/functions.html#iter</a>,它接收支持迭代协议(实现了<code>__iter__()</code>方法)的collection对象和序列协议（实现了<code>__getitem__()</code>方法）。它返回迭代对象，iter(迭代对象)返回的还是它本身。如：</p>

<pre><code>i = iter(range(10))
ii = iter(i)
&gt;&gt;&gt; i is ii
True
</code></pre>

<p>对于迭代器<strong>比较规范的写法</strong>：</p>

<pre><code># 從序列得到
x = [42, "test", -12.34]
it = iter(x)
try:
  while True:
    x = next(it) # 在 Python 2 中，要改成 it.next()
    print(x)
except StopIteration:
  pass
</code></pre>

<h4>方式2.生成器获取</h4>

<pre><code>&gt;&gt;&gt; l = (i for i in range(10))
&gt;&gt;&gt; l
&lt;generator object &lt;genexpr&gt; at 0xb699c11c&gt;
&gt;&gt;&gt; try:
...     while 1:       # while 1 性能要比 while True好
...         x = l.next()  # python3 写成： next(l)
...         print x
... except StopIteration:
...     pass
</code></pre>

<h2>4. 迭代器 Vs for</h2>

<p>如下代码：</p>

<pre><code>&gt;&gt;&gt; i = iter(range(3))    # 迭代器
&gt;&gt;&gt; l = range(3)          # 可迭代对象
&gt;&gt;&gt; for j in i: print j
... 
0
1
2
&gt;&gt;&gt; for j in l: print j
... 
0

&gt;&gt;&gt; try:
...     while 1:
...         print i.next()
... except StopIteration:
...     pass
... 
</code></pre>

<p><strong>for 是对获取迭代器，调用next()方法和处理StopIteration异常的封装，是迭代器提供的语法糖</strong>,对于<code>for</code>循环中，用于迭代器检查是否是迭代对象，如果是则循环遍历输出；如果不是则检查是否是可迭代对象，如是则隐式调用<code>iter()</code>实现迭代对象，然后调用next()方法遍历所有元素，知道触发<code>StopIteration</code>异常，就表示遍历完成了。</p>

<h2>5. 迭代器vs索引</h2>

<p>从上面的学习知道，迭代器是不支持索引的，原因就是索引需实现明元素确占用的内存地址，而迭代器是用到元素的时候才会创建。如下：</p>

<pre><code>&gt;&gt;&gt; i = iter(range(3))    # 创建迭代器
&gt;&gt;&gt; i.index(2)            # 获取元素为2的索引
Traceback (most recent call last):  # 触发异常
  File "&lt;input&gt;", line 1, in &lt;module&gt;
AttributeError: 'listiterator' object has no attribute 'index'

#列表
&gt;&gt;&gt; l = range(3)
&gt;&gt;&gt; l.index(2)  # 获取索引
2     
</code></pre>

<p>这个时候可以使用内建函数<code>enumerate()</code></p>

<pre><code>enumerate(iterable[, start]) -&gt; iterator for index, value of iterable
</code></pre>

<p>使用：</p>

<pre><code>&gt;&gt;&gt; for i,j in enumerate(iter(['A', 'B', 'C'])):  # 或 enumerate(['A', 'B', 'C'])
...     print i,j
...     
... 
0 A
1 B
2 C
</code></pre>

<h2>6.迭代协议</h2>

<p>迭代协议并不是Python约定俗成的协议，以下参考《改善Python程序的91个建议》：</p>

<blockquote>
  <p>1.实现<code>__iter__()</code>方法，返回一个迭代器</p>
  
  <p>2.实现<code>next()</code>方法迭代，抛出<code>StopIteration</code>异常</p>
</blockquote>

<pre><code>&gt;&gt;&gt; s = ['A', 'B', 'C']
&gt;&gt;&gt; i = s.__iter__()          # container.__iter__() 返回iterator对象，如iterator本身则返回本身。
&gt;&gt;&gt; i
&lt;listiterator object at 0xb69cd2cc&gt;
&gt;&gt;&gt; i.next()
'A'
&gt;&gt;&gt; 
</code></pre>

<h2>6.迭代器的优缺点</h2>

<p><strong>优点</strong>：节省内存（惰性求值）开销；提供统一容器访问接口；比较适合大的数据或无穷尽的需求。如斐波那契函数：</p>

<pre><code>#!/usr/bin/env python
# coding=utf-8
class Fib(object):
    def __init__(self):
        self.a = 0
        self.b = 1
    def __iter__(self):    # 调用__iter__()函数返回迭代对象，这里返回它自身。
        return self
    def next(self):        # 定义next()方法
        self.a, self.b = self.b, self.a+self.b
        return self.a

f = Fib()
print f.next()  # 1
print f.next()  # 1
print f.next()  # 2
for i, j in enumerate(f):
    print j
    if i &gt; 10: break
</code></pre>

<p><strong>缺点</strong>：不能回退（不能算是缺点，因为回退是没有意义的）；迭代器也不是线程安全的，在多线程环境中对可变集合使用迭代器是一个危险的操作。但如果小心谨慎，或者干脆贯彻函数式思想坚持使用不可变的集合，那这也不是什么大问题。</p>

<h2>7.itertools模块</h2>

<p>itertools是python提供的非常高效创建与使用迭代器的模块，<strong>注意：利用itertools模块能够提高Python性能</strong>。如：</p>

<pre><code>&gt;&gt;&gt; from itertools import chain
&gt;&gt;&gt; test = chain.from_iterable('ABCDEFG')
&gt;&gt;&gt; test.next()
'A'
&gt;&gt;&gt; test.next()
'B'
&gt;&gt;&gt; test.next()
'C'
&gt;&gt;&gt; test2 = chain('AB', 'CDE', 'F')
&gt;&gt;&gt; list(test2)
['A', 'B', 'C', 'D', 'E', 'F']
</code></pre>

<p>更多参考：<a href="http://www.cnblogs.com/cython/articles/2169009.html">Python：itertools模块</a></p>

<h2>8.参考</h2>

<p>1.<a href="http://www.cnblogs.com/huxi/archive/2011/07/01/2095931.html">Python函数式编程指南（三）：迭代器</a></p>
