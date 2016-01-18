---
layout: post
title: "Python assert vs raise"
description: "Python assert vs raise"
category: "python"
tags: [python技巧]
---
<h1>一.raise</h1>

<p><code>raise</code>更多的时候是coder自己需要触发的异常,比如说:</p>

<pre><code>if x &lt; 0:
    raise Exception, 'x is less than zero'
</code></pre>

<p><code>raise</code> 语法如下:
    raise [someException, [args]]</p>

<p>someException表示常见异常名或自定义异常类等.可以传递参数,如字符串描述等.更多详见&lt;Python核心编程2>.</p>

<p><img src="http://img.blog.csdn.net/20130429161814679" alt="" /></p>

<h1>二.断言assert</h1>

<p>assert就是检测一个条件，如果条件为真，它什么都不做；反之它触发一个带可选错误信息的AssertionError。</p>

<!--more-->

<p>有时候我们对断言的使用场景不是那么清楚,总分不清<code>assert</code>与<code>raise</code>,在<a href="http://www.oschina.net/translate/when-to-use-assert"><strong>Python 使用断言的最佳时机</strong></a>这篇译文中总结如下:</p>

<h2>1.断言使用场景:</h2>

<blockquote>
  <p>防御性的编程</p>
  
  <p>运行时对程序逻辑的检测</p>
  
  <p>合约性检查（比如前置条件，后置条件）</p>
  
  <p>程序中的常量</p>
  
  <p>检查文档</p>
</blockquote>

<h3>(1).防御性编程(Defensive programming)</h3>

<p>在<a href="http://zh.wikipedia.org/zh/%E9%98%B2%E5%BE%A1%E6%80%A7%E7%BC%96%E7%A8%8B">wiki</a>中说道:</p>

<blockquote>
  <p>防御性编程（Defensive programming）是防御式设计的一种具体体现，它是为了保证，对程序的不可预见的使用，不会造成程序功能上的损坏。它可以被看作是为了减少或消除墨菲定律(凡是可能出错的事必定会出错)效力的想法。防御式编程主要用于可能被滥用，恶作剧或无意地造成灾难性影响的程序上。</p>
</blockquote>

<p><strong>断言也是一种防御性的编程形式。你不是在防范当前代码发生错误，而防范由于以后的代码变更发生错误。比如预先知道变量期望的值</strong></p>

<pre><code>&gt;&gt;&gt; def getLetters(arg):
...     assert arg in (1, 2, 3) , "arg must in (1,2,3)"
...     if arg == 1: pass
...     if arg == 2: pass
...     if arg == 3: pass
...     
... 
&gt;&gt;&gt; getLetters(1)
&gt;&gt;&gt; getLetters(4)
Traceback (most recent call last):
  File "&lt;input&gt;", line 1, in &lt;module&gt;
  File "&lt;input&gt;", line 2, in getLetters
AssertionError: arg must in (1,2,3)
</code></pre>

<h3>(2).运行时对程序逻辑的检测</h3>

<p>主要用于开发阶段,判断逻辑时用<code>assert</code>简单明了,但是在生产阶段用户是不希望看到<code>AssertionError</code>.</p>

<pre><code>assert x &gt; 0, "x is not zero or negative"
</code></pre>

<h3>(3).合约性检查</h3>

<p>合约式设计中，我们认为函数与其他调用者遵循合约</p>

<pre><code># 一个非空字符串，返回转换成大写的首字母
def first_upper(astring):
    assert isinstance(astring, str) and len(astring) &gt; 0
    result = astring[0].upper()
    assert isinstance(result, str) and len(result) == 1
    assert result == result.upper()
    return result
</code></pre>

<p><strong>合约式设计的目的是，在一个正确的程序里，所有的对期望的参数的限制）和后置条件（对返回结果的约束）都将得到处理。这是断言的经典应用</strong></p>

<h3>(4).程序中的常量</h3>

<p>处理一些在程序运行中不可变的量.</p>

<p>文中<a href="http://www.oschina.net/translate/when-to-use-assert">Python 使用断言的最佳时机</a>提到断言不建议使用的场景:</p>

<blockquote>
  <p>这里是我建议不使用断言的情况：</p>
  
  <p>不要用于测试用户提供的数据，或者那些需要在所有情况下需要改变检查的地方</p>
  
  <p>不要用于检查你认为在通常使用中可能失败的地方。断言用于非常特别的失败条件。你的用户绝不看到一个AssertionError，如果看到了，那就是个必须修复的缺陷。</p>
  
  <p>特别地不要因为断言只是比一个明确的测试加一个触发异常矮小而使用它。断言不是懒惰的代码编写者的捷径。</p>
  
  <p>不要将断言用于公共函数库输入参数的检查，因为你不能控制调用者，并且不能保证它不破坏函数的合约。</p>
  
  <p>不要将断言用于你期望修改的任何错误。换句话，你没有任何理由在产品代码捕获一个AssertionError异常。</p>
  
  <p>不要太多使用断言，它们使代码变得晦涩难懂。</p>
</blockquote>

<h1>三.assert vs raise</h1>

<p>如下:
    # 断言
    assert x >= 0, 'x is less than zero'</p>

<pre><code># raise
if x &lt; 0:
    raise Exception, 'x is less than zero'
</code></pre>

<p>能比较它们的性能吗?对于这两种触发异常的形式而言,对于性能上旗鼓相当,但是各有各的应用场景,这里比较的是哪个在哪些场景中使用更加适合,更加Pythonic.</p>

<p>上面的代码来自stackoverflow.<a href="http://stackoverflow.com/questions/944592/best-practice-for-python-assert">Best practice for Python Assert</a></p>

<p>对于这两种情况解释:</p>

<p>Asserts should be used to test conditions that should never happen. The purpose is to crash early in the case of a corrupt program state.</p>

<p>Exceptions should be used for errors that can conceivably happen, and you should almost always create your own Exception classes.</p>

<p>For example, if you're writing a function to read from a configuration file into a dict, improper formatting in the file should raise a ConfigurationSyntaxError, while you can assert that you're not about to return None.</p>

<p>In your example, if x is a value set via a user interface or from an external source, an exception is best.</p>

<p>If x is only set by your own code in the same program, go with an assertion.</p>
