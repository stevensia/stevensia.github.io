---
layout: post
title: "Python OOP 常见疑难点汇总"
description: "Python OOP 常见疑难点汇总"
category: "python"
tags: [python技巧]
---

<p>Python面向对象常见疑难点汇总</p>

<p><img src="http://img.mukewang.com/537d762600013df705000333.jpg" alt="" /></p>

<h3>No1.公有私有属性</h3>

<p>python oop无public 和private,对类的私有属性的处理通过<code>__</code>
    [python]
    class P():
        a = 100      # public
        __a = 200    # private
        def func(self):
            print 'Public function'
            print self.a
            print self.__a</p>

<pre><code>    def __pfunc(self):
        print 'Private function'
        print self.a
        print self.__a

p = P()
print p.a
print p.__a      #err
print p.func()
print p.__pfunc()  #err
[/python]
</code></pre>

<!--more-->

<h3>NO2.self的哲学</h3>

<p><strong>self非关键字</strong>，而是一个参数对象的代表，像<code>this</code>一样，代表实例对象本身。调用实例方法，会隐式传实递实例对象。</p>

<pre><code>&gt;&gt;&gt; class P():
...     def func(self):
...         print self
...         
...     
... 
&gt;&gt;&gt; p = P()  # 实例化
&gt;&gt;&gt; p.func()  # 调用实例方法，此时隐式传实递实例p对象
&lt;__main__.P instance at 0xb69282cc&gt;
</code></pre>

<h3>No3.新式类VS经典类</h3>

<blockquote>
  <p>新式类：就是所有类都必须继承的类，如果什么都不想继承，就继承到object类。
  经典类：没有父类</p>
</blockquote>

<h4>1.递归问题</h4>

<p><a href="http://zxn990.blog.51cto.com/4253193/1285599">http://zxn990.blog.51cto.com/4253193/1285599</a></p>

<h4>2.调用父类构造器</h4>

<p><a href="http://jianshu.io/p/2ZxRsn">http://jianshu.io/p/2ZxRsn</a></p>

<p>下面来自<a href="http://stackoverflow.com/questions/54867/old-style-and-new-style-classes-in-python">http://stackoverflow.com/questions/54867/old-style-and-new-style-classes-in-python</a></p>

<blockquote>
  <p>Up to Python 2.1, old-style classes were the only flavour available to the user. The concept of (old-style) class is unrelated(无关的) to the concept of type: if x is an instance of an old-style class, then x.<strong>class</strong> designates the class of x, but type(x) is always <type 'instance'>. This reflects the fact that all old-style instances, independently of their class, are implemented with a single built-in type, called instance.</p>
  
  <p>New-style classes were introduced in Python 2.2 to unify classes and types. A new-style class neither more nor less than a user-defined type. If x is an instance of a new-style class, then type(x) is the same as x.<strong>class</strong>.</p>
  
  <p>The major motivation for introducing new-style classes is to provide a unified object model with a full meta-model. It also has a number of immediate benefits, like the ability to subclass(亚纲) most built-in types, or the introduction of "descriptors(描述符号)", which enable computed properties.</p>
  
  <p>For compatibility reasons, classes are still old-style by default. New-style classes are created by specifying another new-style class (i.e. a type) as a parent class, or the "top-level type" object if no other parent is needed. The behaviour of new-style classes differs from that of old-style classes in a number of important details in addition to what type returns. Some of these changes are fundamental to the new object model, like the way special methods are invoked. Others are "fixes" that could not be implemented before for compatibility concerns, like the method resolution order in case of multiple inheritance.</p>
  
  <p>Python 3 only has new-style classes. No matter if you subclass from object or not, classes are new-style in Python 3. It is however recommended that you still subclass from object.</p>
</blockquote>

<pre><code>&gt;&gt;&gt; p = P2()               # 经典类
&gt;&gt;&gt; p.__class__         
&lt;class __main__.P2 at 0xb68bd1dc&gt;
&gt;&gt;&gt; type(p)
&lt;type 'instance'&gt;

&gt;&gt;&gt; pp = P()               # 新式类
&gt;&gt;&gt; pp.__class__
&lt;class '__main__.P'&gt;
&gt;&gt;&gt; type(pp)
&lt;class '__main__.P'&gt;
</code></pre>

<h3>No4.类方法VS实例方法VS静态方法</h3>

<p>类方法：<code>classmethod</code>修饰，第一个参数<code>cls</code>,类与实例共享。</p>

<p>实例方法：无修饰，第一个参数<code>self</code>,实例所有</p>

<p>静态方法：<code>staticmethod</code>修饰，无需参数，类与实例共享。无法访问类属性、实例属性，相当于一个相对独立的方法，跟类其实没什么关系，换个角度来讲，其实就是放在一个类的作用域里的函数而已。静态方法中引用类属性的话，必须通过类对象来引用。</p>

<pre><code>class P(object):
    tip = 'Persion tips'  # 类属性，类及类成员共享
    @classmethod
    def clsFunc(cls):
        """类方法共享"""
        return 'Welcome:' + cls.tip
    def insFunc(self):
        """实例方法"""
        return self.__class__
    @staticmethod
    def staFunc():
        """静态方法"""
        return P.tip

p = P()
print P.tip
print p.tip
print p.insFunc()
p.age = 20   # 实例属性无需在类中显示定义
print p.age
print p.clsFunc()  # 类方法
print p.clsFunc()  
print p.staFunc() # 静态方法实例与类共享
print p.staFunc()
</code></pre>

<h3>NO5.<strong>init</strong> VS <strong>new</strong></h3>

<p>首先看这段代码，代码参考<a href="http://stackoverflow.com/questions/674304/pythons-use-of-new-and-init">Python's use of <strong>new</strong> and <strong>init</strong>?</a></p>

<pre><code>class P(object):
    _dict = dict()
    def __new__(cls):
        if 'key' in P._dict:
            print "EXISTS"
            #return P._dict['key']    # 返回实例对象
            return P._dict            # 返回不合法的对象
        else:
            print 'NEW'
            return super(P, cls).__new__(cls)  # 返回实例对象

    def __init__(self):
        print 'INIT..'
        P._dict['key'] = self
        print " "


p1 = P()
p2 = P()
p3 = P()

# 输出结果
NEW
INIT..

EXISTS
EXISTS

# 如果把上面的注释取消，变成：return P._dict['key'] 则输出结果如下：
NEW
INIT..

EXISTS
INIT..

EXISTS
INIT..
</code></pre>

<p>看出点端倪了么。。</p>

<p><code>__new__()</code>：静态方法，<code>cls</code>作为第一个参数，控制创造一个新实例</p>

<p><code>__init__()</code>：实例方法，<code>self</code>作为第一个参数，控制初始化一个实例</p>

<p>在Python OOP中，<code>__new__()</code>相比<code>__init__()</code>更像一个构造器，<strong><code>__new__()</code>是一个静态方法，必须返回一个合法的实例，这样解释器在调用<strong>init</strong>()之前把这个实例作为self传递过去</strong></p>

<p><code>__init__()</code>实例初始化，它返回<code>None</code>,它的工作就是在实例被创建(<strong>new</strong>())后初始化它。</p>

<pre><code>&gt;&gt;&gt; class P(object):
...     def __init__(self):
...         print 'ok'
...     def __new__(cls):
...         print 'new'
...         
...     
... 
&gt;&gt;&gt; p = P()
new
&gt;&gt;&gt; class P(object):
...     def __init__(self):
...         print 'ok'
...         
...     def __new__(cls):
...         print 'new'
...         return super(P, cls).__new__(cls)
...     
... 
&gt;&gt;&gt; p = P()
new
ok
</code></pre>

<h3>NO6.特殊的实例属性VS特殊的类属性</h3>

<p>dir()相关知识移步这里<a href="http://sebug.net/paper/python/ch08s06.html">http://sebug.net/paper/python/ch08s06.html</a>.</p>

<p>特殊实例属性：<code>__dict__</code>,<code>__init__</code>,<code>__class__</code>,如：</p>

<pre><code>&gt;&gt;&gt; p.__class__
&lt;class __main__.P at 0xb692d05c&gt;
&gt;&gt;&gt; p.__doc__
&gt;&gt;&gt; p.__init__
&lt;bound method P.__init__ of &lt;__main__.P instance at 0xb6936bac&gt;&gt;
&gt;&gt;&gt; p.__module__
'__main__'
&gt;&gt;&gt; p.__new__
&lt;bound method P.__new__ of &lt;__main__.P instance at 0xb6936bac&gt;&gt;
&gt;&gt;&gt; p.__dict__
{}
&gt;&gt;&gt; p.age = 100
&gt;&gt;&gt; p.__dict__
{'age': 100}
&gt;&gt;&gt; dir(p)
['__doc__', '__init__', '__module__', '__new__', 'age']
</code></pre>

<p>特殊类属性：<code>C.__name__</code>:类名，  <code>C.__bases__ or(__base__)</code>：父类，<code>C.__dict__</code>:类属性， <code>C.__module__</code>:定义类所在的model, <code>C.__class__</code>：实例C对应的类。</p>

<p>一般这些特殊的东西用的较少，这里展示下且当记忆。</p>

<h3>NO7.理解super()</h3>

<p><code>super</code>主要为了不显示的引用基类的东西，主要的优势体现在多重继承上如 class (A,B)等，使用super能够智能的帮助我们调用基类。</p>

<blockquote>
  <ol>
  <li>super并不是一个函数，是一个类名，形如super(B, self)事实上调用了super类的初始化函数，产生了一个super对象；</li>
  <li>super类的初始化函数并没有做什么特殊的操作，只是简单记录了类类型和具体实例；</li>
  <li>super(B, self).func的调用并不是用于调用当前类的父类的func函数；</li>
  <li>Python的多继承类是通过mro的方式来保证各个父类的函数被逐一调用，而且保证每个父类函数只调用一次（如果每个类都使用super）；</li>
  <li>混用super类和非绑定的函数是一个危险行为，这可能导致应该调用的父类函数没有调用或者一个父类函数被调用多次。</li>
  </ol>
</blockquote>

<p>关于Python super的解释参考这里<a href="http://www.cnblogs.com/lovemo1314/archive/2011/05/03/2035005.html"><strong>python super()</strong></a>.</p>

<p>这里有个误区就是:</p>

<pre><code>super( BasicElement, self ).__init__()
super( BasicElement, self ).__init__(self)
</code></pre>

<p>实例如下：</p>

<pre><code>&gt;&gt;&gt; class A(object):
...     def __init__(self):
...         print 'AAAAAA'
...         
...     
... 
&gt;&gt;&gt; class B(A):
...     def __init__(self):
...         super(B, self).__init__()
...         
...     
... 
&gt;&gt;&gt; b = B()
AAAAAA

&gt;&gt;&gt; class B(A):
...     def __init__(self):
...         super(B, self).__init__(self)
...         
...     
... 
&gt;&gt;&gt; b = B()
Traceback (most recent call last):
  File "&lt;input&gt;", line 1, in &lt;module&gt;
  File "&lt;input&gt;", line 3, in __init__
TypeError: __init__() takes exactly 1 argument (2 given)

&gt;&gt;&gt; class A(object):
...     def __init__(self, args):
...         print 'AAAAAAAAAAA', args
...         
...     
... 
&gt;&gt;&gt; class B(A):
...     def __init__(self):
...         super(B, self).__init__('Man')
...         
...     
... 
&gt;&gt;&gt; b = B()
AAAAAAAAAAA Man
</code></pre>

<p><strong>看出<code>super(B, self).__init__("sss")</code> 向基类传参。在Python3中，可以直接写super().<strong>init</strong>() 取代 super(B, self).<strong>init</strong>()</strong></p>
