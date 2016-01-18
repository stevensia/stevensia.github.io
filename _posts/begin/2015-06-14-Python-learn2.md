---
layout: post
title: "Python 下划线特征体现与私有概念"
description: "Python 下划线特征体现与私有概念"
category: "python"
tags: [python技巧]
---
<p>与大多数语言一样，Python 也有私有的概念：</p>

<ul>
<li>私有函数不可以从它们的模块外面被调用</li>
<li>私有类方法不能够从它们的类外面被调用</li>
<li>私有属性不能够从它们的类外面被访问</li>
</ul>

<p>与大多数的语言不同，一个 Python 函数，方法，或属性是私有还是公有，完全取决于它的名字。</p>

<p><strong>如果一个 Python 函数，类方法，或属性的名字以两个下划线开始 (但不是结束)，它是私有的；其它所有的都是公有的。</strong> Python 没有类方法保护 的概念 (只能用于它们自已的类和子类中)。类方法或者是私有 (只能在它们自已的类中使用) 或者是公有 (任何地方都可使用)。</p>

<p>参考：<a href="http://woodpecker.org.cn/diveintopython/object_oriented_framework/private_functions.html"> Dive Into Python </a></p>

<p>关于Python的下划线也是一道亮丽的风景，在<a href="http://www.zhihu.com/question/19754941">Python 的类的下划线命名有什么不同?</a>中，说道：</p>

<p><strong>1. 单下划线开头:</strong></p>

<blockquote>
  <p>这个被常用于模块中，在一个模块中以单下划线开头的变量和函数被默认当作内部函数，如果使用 <code>from a_module import *</code> 导入时，这部分变量和函数不会被导入。不过值得注意的是，如果使用 <code>import a_module</code>这样导入模块，仍然可以用 <code>a_module._some_var</code> 这样的形式访问到这样的对象。</p>
</blockquote>

<p><strong>2.单下划线结尾:</strong></p>

<p>通常用于和 Python 关键词区分开来,如<code>class_</code>区分关键字<code>class</code></p>

<p><strong>3.双下划线开头:</strong></p>

<p>上面已涉及到如果一个 Python 函数，类方法，或属性的名字以两个下划线开始 (但不是结束)，它是私有的。</p>

<p><strong>如果有一 Test 类里有一成员 __x，那么 dir(Test) 时会看到 _Test__x 而非 __x。这是为了避免该成员的名称与子类中的名称冲突。</strong></p>

<pre><code>class A(object):
    __ll = 'll'     # 私有属性
    cc = 'cc'           # 公有属性

class B(A):
    pass


# 注意：_A__ll 而非 __ll
print A.__dict__        # {'_A__ll': 'll', 'cc': 'cc'}

print B.__dict__        # {'__module__': '__main__', '__doc__': None}

print B.cc

#异常
print B.__ll    # AttributeError: type object 'B' has no attribute '__ll'
</code></pre>

<p><strong>4.双下划线开头双下划线结尾</strong></p>

<p>是一些 Python 的“魔术”对象,如<code>__new__</code>,<code>__call__</code></p>
