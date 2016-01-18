---
layout: post
title: "关于Python闭包"
description: "关于Python闭包"
category: "Python"
tags: [Python]
---

<h1>一.闭包(Closure)概念</h1>

<p><img src="http://images.cnblogs.com/cnblogs_com/BeginMan/480086/o_closure.jpg" alt="" /></p>

<blockquote>
  <p>闭包的概念出现于60年代，最早实现闭包的程序语言是Scheme。之后，闭包被广泛使用于函数式编程语言如ML语言和LISP。很多命令式程序语言也开始支持闭包。</p>
  
  <p><strong>在一些语言中，在函数中可以（嵌套）定义另一个函数时，如果内部的函数引用了外部的函数的变量，则可能产生闭包。运行时，一旦外部的 函数被执行，一个闭包就形成了，闭包中包含了内部函数的代码，以及所需外部函数中的变量的引用。其中所引用的变量称作上值(upvalue)。</strong></p>
</blockquote>

<h1>二.Python的闭包</h1>

<p><strong>内部函数可以使用外部函数变量的行为，就叫闭包</strong>, 如下例子:</p>

<pre><code>#!/usr/bin/env python
# coding=utf-8
a = 1
def foo(x):
    b = 2
    def bar():
        c = 3
        return c+b
    return x + a + b + bar()

print foo(4)
</code></pre>

<p>参考:http://zh.wikipedia.org/zh/%E9%97%AD%E5%8C%85_(%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%A7%91%E5%AD%A6)</p>
