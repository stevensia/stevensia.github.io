---
layout: post
title: "Python常用的魔法方法"
description: "Python常用的魔法方法"
category: "Python"
tags: [Python]
---

<p>所谓魔法方法就是给类添加'magic'的能力，常以双下划线标示。对<code>__new__()</code>,<code>__init__()</code>,<code>__del__()</code>已说过，这里就略过。</p>

<p><strong>使用Python的魔术方法的最大优势在于他们提供了一种简单的方法来让对象可以表现的像内置类型一样</strong></p>

<p>一下从几个方面总结下Python魔法方法：</p>

<!--more-->

<h2>1.操作符</h2>

<p>对于对于操作符分为：</p>

<ul>
<li>用于比较的魔术方法</li>
<li>数值处理的魔术方法</li>
</ul>

<p>参考见<a href="http://pyzh.readthedocs.org/en/latest/python-magic-methods-guide.html#id5">http://pyzh.readthedocs.org/en/latest/python-magic-methods-guide.html#id5</a></p>

<h2>2.类的表示</h2>

<p><strong>就是对内建函数定义类的行为。</strong></p>

<p><code>__str__(self)</code>: 定义对类的实例调用 str() 时的行为。</p>

<p><code>__repr__(self)</code>:定义对类的实例调用 repr() 时的行为。</p>

<p><code>__unicode__(self)</code>:定义对类的实例调用 unicode() 时的行为</p>

<p><code>__format__(self)</code>:定义对类的实例调用 format() 时的行为。</p>

<p><code>__hash__(self)</code>:定义对类的实例调用 hash() 时的行为.</p>

<p><code>__nonzero__(self)</code>: 定义对类的实例调用 bool() 时的行为,返回True或False。</p>

<p><code>__dir__(self)</code>:定义对类的实例调用 dir() 时的行为</p>

<p>如下实例：</p>

<pre><code>class myClass(object):
    def __str__(self):
        return 'beginman'

    def __repr__(self):
        return 'fuck'

    def __unicode__(self):
        return u'哈哈'

    def __format__(self, *args, **kwargs):
        return 'beginman'

    def __hash__(self):
        return 100

    def __nonzero__(self):
        if self.__str__() == 'beginman':
            return True

        return False


m = myClass()

print m

print str(m)

print unicode(m) + u'，你们好!'

print "hello, {0}, are you ok?".format(m)

print hash(m), hash(m) == hash(myClass())

print bool(m)
</code></pre>

<p>结果：</p>

<pre><code>beginman
beginman
哈哈，你们好!
hello, beginman, are you ok?
100 True
True
</code></pre>

<h2>3.访问控制</h2>

<p><strong>python通过魔法方法就行封装</strong></p>

<p><strong><code>__getattr__(self, name)</code></strong></p>

<p>当用户试图访问一个根本不存在（或者暂时不存在）的属性时，你可以通过这个魔法方法来定义类的行为。这个可以用于捕捉错误的拼写并且给出指引，使用废弃属性时给出警告（如果你愿意，仍然可以计算并且返回该属性），以及灵活地处理AttributeError。只有当试图访问不存在的属性时它才会被调用，所以这不能算是一个真正的封装的办法。</p>

<pre><code>class myClass(object):
   def __getattr__(self, item):
       print 'to do something.'
       return 'Default'

m = myClass()
print m.name    # Default
</code></pre>

<p><strong><code>__setattr__(self, name, value)</code></strong></p>

<p>和 <code>__getattr__</code> 不同， <code>__setattr__</code> 可以用于真正意义上的封装。它允许你自定义某个属性的赋值行为，不管这个属性存在与否，也就是说你可以对任意属性的任何变化都定义自己的规则。然后，一定要小心使用 <code>__setattr__</code>防止无限递归.</p>

<pre><code>def __setattr__(self, name. value):
    self.name = value
    # 因为每次属性幅值都要调用 __setattr__()，所以这里的实现会导致递归
    # 这里的调用实际上是 self.__setattr('name', value)。因为这个方法一直
    # 在调用自己，因此递归将持续进行，直到程序崩溃

def __setattr__(self, name, value):
    self.__dict__[name] = value # 使用 __dict__ 进行赋值
    # 定义自定义行为
</code></pre>

<p>下面是应用的例子：</p>

<pre><code>allowed_fields = ('delete', 'remove')

class myClass(object):
   def __setattr__(self, key, value):
       if key in allowed_fields:
           print 'set Ok.'
           # object.__setattr__(self, key, value)
           super(myClass, self).__setattr__(key, value)

       else:
           raise Exception('Not allowed')


c = myClass()
c.delete = 'ok'
print c.delete
</code></pre>

<p><strong><code>__delattr__(self, name)</code></strong></p>

<p>这个魔法方法和 <code>__setattr__</code> 几乎相同，只不过它是用于处理删除属性时的行为。和 <code>__setattr__</code> 一样，使用它时也需要多加小心，防止产生无限递归（在 <code>__delattr__</code> 的实现中调用 del self.name 会导致无限递归）。</p>

<p><strong><code>__getattribute__(self, name)</code></strong></p>

<p><code>__getattribute__</code> 看起来和上面那些方法很合得来，但是最好不要使用它。 <code>__getattribute__</code>只能用于新式类。在最新版的Python中所有的类都是新式类，在老版Python中你可以通过继承 object 来创建新式类。 <code>__getattribute__</code> 允许你自定义属性被访问时的行为，它也同样可能遇到无限递归问题（通过调用基类的 <code>__getattribute__</code> 来避免）。 <code>__getattribute__</code> 基本上可以替代 <code>__getattr__</code> 。只有当它被实现，并且显式地被调用，或者产生 AttributeError 时它才被使用。 这个魔法方法可以被使用（毕竟，选择权在你自己），我不推荐你使用它，因为它的使用范围相对有限（通常我们想要在赋值时进行特殊操作，而不是取值时），而且实现这个方法很容易出现Bug。</p>

<p>如下是个属性计数器：</p>

<pre><code>class AccessCounter(object):

    def __init__(self, val):
        super(AccessCounter, self).__setattr__('counter', 0)
        super(AccessCounter, self).__setattr__('value', val)

    def __setattr__(self, key, value):
        if key == 'value':
            super(AccessCounter, self).__setattr__('counter', self.counter + 1)
            super(AccessCounter, self).__setattr__(key, value)

    def __delattr__(self, key):
        if key == 'value':
            super(AccessCounter, self).__setattr__('counter', self.counter + 1)
            super(AccessCounter, self).__delattr__(key)

ac = AccessCounter('python')
print ac.counter, ac.value

ac.name = 'beginman'
ac.value = 'XX'

print ac.counter, ac.value

del ac.value

print ac.counter
</code></pre>

<p>结果：</p>

<pre><code>0 python
1 XX
2
</code></pre>

<h2>4.可调用对象</h2>

<p><strong><code>__call__(self, [args...])</code></strong></p>

<p>允许类的一个实例像函数那样被调用。本质上这代表了 x() 和 <code>x.__call__()</code> 是相同的。注意 <code>__call__</code> 可以有多个参数，这代表你可以像定义其他任何函数一样，定义 <code>__call__</code> ，喜欢用多少参数就用多少。</p>

<p><code>__call__</code> 在某些需要经常改变状态的类的实例中显得特别有用。“调用”这个实例来改变它的状态，是一种更加符合直觉，也更加优雅的方法。一个单例模式例子:</p>

<pre><code>class Singleton(type):
    _instance = {}
    def __call__(cls, *args, **kwargs):
        if cls not in cls._instance:
            cls._instance[cls] = super(Singleton, cls).__call__(*args, **kwargs)

        return cls._instance[cls]

class Blah(object):
    __metaclass__ = Singleton
</code></pre>

<h2>5.上下文管理器</h2>

<p>就是对<code>with</code>操作的类化，对于上下文管理器存在两点：<code>__enter__()</code>和<code>__exit__()</code></p>

<p><strong><code>__enter__(self)</code></strong></p>

<p>定义使用 with 声明创建的语句块最开始上下文管理器应该做些什么。注意 <code>__enter__</code> 的返回值会赋给 with 声明的目标，也就是 as 之后的东西。</p>

<p><strong><code>__exit__(self, exception_type, exception_value, traceback)</code></strong></p>

<p>定义当 with 声明语句块执行完毕（或终止）时上下文管理器的行为。它可以用来处理异常，进行清理，或者做其他应该在语句块结束之后立刻执行的工作。如果语句块顺利执行， exception_type , exception_value 和 traceback 会是 None 。否则，你可以选择处理这个异常或者让用户来处理。如果你想处理异常，确保 <code>__exit__</code> 在完成工作之后返回 True 。如果你不想处理异常，那就让它发生吧。</p>

<p>如下计时器实例：</p>

<pre><code>import time

class Timmer(object):
    def __enter__(self):
        self.start = time.time()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.end = time.time()
        self.interval = self.end - self.start


with Timmer() as t:
    dosometing

print t.interval
</code></pre>

<p>上面从几个常用的点总结，更多内容参考<a href="http://pyzh.readthedocs.org/en/latest/python-magic-methods-guide.html#id12">11. (译)Python魔法方法指南</a></p>
