---
layout: post
title: "python可变对象的坑"
description: "python可变对象的坑"
category: "Python"
tags: [Python]
---

<p>在Python中要注意可变对象的使用，比如：</p>

<h2>1&#46;可变对象不能作为默认参数</h2>

<pre><code>class MyCls(object):
    def __init__(self, name, obj=[]):
        self.name = name
        self.obj = obj

    def appendIt(self):
        self.obj.append(self.name)

    def printIt(self):
        print self.obj,id(self.obj)

c = MyCls('beginman')
c.appendIt()
c.printIt()

m = MyCls('fang')
m.appendIt()
m.printIt()
</code></pre>

<p>输出结果：</p>

<pre><code>['beginman'] 4405681616
['beginman', 'fang'] 4405681616
</code></pre>

<p><strong>显然，obj重复利用了</strong>，这不是我们想要的结果，原因就在于<strong><font color="red">init()初始化时，由于默认参数在被调用的时候仅仅被评估一次，以后都会使用第一次评估的结果。</font><font></font></strong></p>

<!--more-->

<p><strong>如何处理？</strong></p>

<p><strong><font color="red">把可变对象的默认参数换成<code>None</code>，在创建对象的时候动态生成列表</font></strong></p>

<pre><code>class MyCls2(object):
    def __init__(self, name, obj=None):
        self.name = name
        self.obj = obj if obj else []

    def appendIt(self):
        self.obj.append(self.name)

    def printIt(self):
        print self.obj,id(self.obj)


    c1 = MyCls2('beginman')
    c1.appendIt()
    c1.printIt()

    m1 = MyCls2('fang')
    m1.appendIt()
    m1.printIt()

#输出结果
['beginman'] 4491080336
['fang'] 4491044840
</code></pre>

<p>对于函数而言，存在同样的问题。</p>

<pre><code>def myfunc(k, obj=[]):
    obj.append(k)
    print obj, id(obj)

m = myfunc('beginman')
m2 = myfunc('fang')

#输出
['beginman'] 4560637392
['beginman', 'fang'] 4560637392

print myfunc.func_defaults      # (['beginman', 'fang'],)
</code></pre>

<p>这是因为<strong><code>def</code>在python中是可执行语句，当解释器执行def时，默认参数会被计算并存入函数的<code>func_defaults</code>属性中，由于python中函数参数传递的时对象，可变对象在调用者和被调用者之间共享</strong></p>

<p>当然解决方案还是<strong>None对象做占位符</strong>:</p>

<pre><code>def myfunc2(k, obj=None):
    if obj is None:
        obj = []

    obj.append(k)
    print obj, id(obj)

m3 = myfunc2('beginman')
m4 = myfunc2('fang')

print myfunc2.func_defaults 

#输出结果
['beginman'] 4560679640
['fang'] 4560679640
(None,)
</code></pre>
