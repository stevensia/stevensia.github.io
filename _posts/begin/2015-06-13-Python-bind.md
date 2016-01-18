---
layout: post
title: "Python 绑定与非绑定"
description: "Python 绑定与非绑定"
category: "Python"
tags: [Python]
---

<blockquote>
  <p>当方法由实例带动，方法才被认为是绑定到那个实例，就是<code>binding</code>；没有实例时方法就是未绑定(<code>Unbound</code>)的.</p>
</blockquote>

<h1>一.绑定与非绑定概念阐述</h1>

<p>在调用类的实例对象时动态地将对象本身作为作为第一个参数传入，这里Python约定<code>self</code>表示对象本身，如同js的<code>this</code>一样，当然<code>self</code>只是一个变量名的约定，你可以替换为任何非系统保留字。</p>

<p>对于这种方法，就是依赖实例对象本身了，也称绑定到该对象身上。如果实例化前self没有对象绑定，则会触发<code>Method Unbound Error</code></p>

<p>对于非绑定：通过类来引用方法返回一个未绑定方法对象。要调用它，你必须显式地提供一个实例作为第一个参数。</p>

<p>两者区别就是：</p>

<ol>
<li>是否需要实例化</li>
<li>一个自动一个手动传入实例对象</li>
</ol>

<p>如下实例：</p>

<pre><code>class Foo(object):
    def bar(self):
        print 'FOO.bar'

# 绑定
f = Foo()       # 实例化
print f         # &lt;__main__.Foo object at 0x1046b0110&gt;
f.bar()         # 隐式传入实例对象

# 未绑定
u_f = Foo.bar
print u_f       # &lt;unbound method Foo.bar&gt;
u_f(f)          # 显式传入类对象
</code></pre>

<h1>二.应用场景</h1>

<p>绑定方法应用是最广泛了，不太提了，对于非绑定一般多用于<strong>覆盖父类方法</strong></p>

<pre><code>class FooA(FOO):
    def __init__(self, arg1, *args, **kwargs):
        FOO.__init__(self, arg1, *args, **kwargs)
        self.arg1 = arg1
        ...
</code></pre>

<p>我们通过<code>父类名.方法名(self, *args, **kwargs)</code> 传递self和其他参数给父类方法，实现继承。</p>
