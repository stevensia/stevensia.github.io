---
layout: post
title: "Python 面向对象继承"
description: "Python 面向对象继承"
category: "Python"
tags: [Python]
---
<p>关于Python面向对象的继承有以下几个需要注意的点：</p>

<ol>
<li><code>__bases__</code>属性的理解</li>
<li>覆盖与继承，如果子类完全覆盖父类方法则不用显式基类方法；如果通过继承来覆盖则需要显式调用基类方法。</li>
<li>重写<code>__init__</code>不会自动调用基类的<code>__init__</code></li>
<li><code>super()</code>方法的位置</li>
<li>关于不可变类型和可变类型的继承</li>
<li>多重继承</li>
</ol>

<!--more-->

<h1>一. <code>__bases__</code> 类属性</h1>

<p><code>__bases__</code>属性：包含父类集合的元祖</p>

<pre><code>class A: pass

class B(object): pass

class C(object): pass

class D(B, C): pass

class F(dict): pass

print A.__bases__           # (), 对于经典类则无
print B.__bases__           # (&lt;type 'object'&gt;,)
print D.__bases__           # (&lt;class '__main__.B'&gt;, &lt;class '__main__.C'&gt;)
print F.__bases__           # (&lt;type 'dict'&gt;,)
</code></pre>

<h1>二.继承覆盖</h1>

<p>如果重写父类方法，则可以显式调用基类方法，有两种方式：</p>

<pre><code>BaseCls.method(self, *args, **kwargs)
super(ChildCls, self).method(*args, **kwargs)
</code></pre>

<p><strong>对于重写<code>__init__</code>，我们也需要显式调用基类的<code>__init__</code>.</strong></p>

<p>关于<code>super</code>可参考<a href="http://www.beginman.cn/archives/264">Python OOP 常见疑难点汇总</a>, 如果我们把<code>super</code>位置决定从子类的哪个位置开始继承基类方法，如下测试：</p>

<pre><code>class A(object):
    a = 100
    def __init__(self):
        print 'init class A  a is', A.a

class C(A):
    def __init__(self):
        super(C, self).__init__()
        A.a = 200
        print 'init class C a is', C.a
        print C.a
</code></pre>

<p>C子类初始化后结果如下：</p>

<pre><code>init class A  a is 100
init class C a is 200
200
</code></pre>

<p>这里我们把<code>super(C, self).__init__()</code>放在<code>print C.a</code>上面</p>

<pre><code>A.a = 200
print 'init class C a is', C.a
super(C, self).__init__()
print C.a
</code></pre>

<p>则结果如下：</p>

<pre><code>init class C a is 200
init class A  a is 200
200
</code></pre>

<p><strong>为了保证数据一致性，在继承的时候我们应该考虑继承优先的原则，即super()要放在子类方法第一位置。</strong></p>

<h1>三.关于可变类型与不可变类型的继承</h1>

<p>对于不可变类型，如str,int,unicode,fload,tuple,forzenset等，<strong><code>__init__()</code>方法是个伪方法，必须重新覆盖<code>__new__()</code>方法才能满足继承。</strong></p>

<pre><code>class RoundFloat(float):
    def __new__(cls, val, *args, **kwargs):
        # return float.__new__(cls, round(val, 2))
        return super(RoundFloat, cls).__new__(cls, round(val, 2))

r = RoundFloat(1.8833)
print r         # 1.88
</code></pre>

<p>注意：<strong>对于</strong><strong>new</strong>()使用super则需要我们显式传入类对象cls,所以要<code>super(x, cls).__new__(cls)</code>, 对于<strong>init</strong>()则super会自动传入实例对象self, <code>super(x, self).__init__()</code></p>

<p><strong>对于可变类型的子类化，可能不需要使用<code>__new__()</code>或<code>__init__()</code> 而是直接子类化其方法，应用的比较少，首先要确定你的业务逻辑是什么，有没有比子类化更简单的方式(如一个简单函数)等</strong>， 如下例子参考《Python核心编程》将keys()自动排序：</p>

<pre><code>class SortedKeyDict(dict):
    def keys(self):
        return sorted(super(SortedKeyDict, self).keys())

data = (('fang',100), ('apple', 28), ('zone', 10), ('dig', 200))
s = SortedKeyDict(data)
print s.keys()      # ['apple', 'dig', 'fang', 'zone']
</code></pre>

<h1>四.MRO与多重继承</h1>

<p>所谓MRO(Method Resolution Order)是广度优先，而非深度优先算法，在python2.2引入。</p>

<p><strong>对于经典类，采用的是深度优先搜索; 对于新类则广度优先</strong>：如下实例：</p>

<pre><code>class A1: #(object)
    def foo(self):
        print 'A1.foo'

class A2: #(object)
    def foo(self):
        print 'A2.foo'
    def bar(self):
        print 'A2.bar'

class B1(A1, A2):
    pass

class B2(A1, A2):
    def bar(self):
        print 'B2.bar'

class C(B1, B2):
    pass
</code></pre>

<p>其继承关系图如下：</p>

<p><img src="http://7fvf56.com1.z0.glb.clouddn.com/MRO.png" alt="" /></p>

<p><strong>经典类测试：</strong></p>

<pre><code>c = C()
c.foo()     # C(无) -&gt; B1(无) -&gt; A1(有, 不再继续搜索)
c.bar()     # C(无) -&gt; B1(无) -&gt; A1(无, 已经深度搜索完B1左侧, 开始搜索B1右侧).. -&gt; A2(有, 不再继续搜索)
</code></pre>

<p>结果如下：</p>

<pre><code>A1.foo
A2.bar
</code></pre>

<p><strong>新式类测试：</strong></p>

<pre><code>c = C()
c.foo()     # C(无) -&gt; B1(无) -&gt; B2(无, 继续下层搜索) -&gt; A1
c.bar()     # C(无) -&gt; B1(无) -&gt; B2(有, 不再继续搜索)
</code></pre>

<p>结果如下：</p>

<pre><code>A1.foo
B2.bar
</code></pre>

<p><strong>新式类中<code>__mro__</code>属性可现实广度次序</strong></p>

<pre><code>print C.__mro__
(&lt;class '__main__.C'&gt;, &lt;class '__main__.B1'&gt;, &lt;class '__main__.B2'&gt;, &lt;class '__main__.A1'&gt;, &lt;class '__main__.A2'&gt;, &lt;type 'object'&gt;)
</code></pre>
