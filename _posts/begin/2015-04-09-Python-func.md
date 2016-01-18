---
layout: post
title: "Python 函数式编程"
description: "Python 函数式编程"
category: "python"
tags: [python技巧]
---
<h2>前言</h2>

<p>Python不大可能会成为一种函数式编程语言，但它支持许多有价值的函数式编程语言构建。</p>

<p>然后就开始介绍lambda与四种内建函数。 对于新手来说，就有点迷惑了，到底什么是函数式编程了？？ 于是google如下：</p>

<p>函数式编程是一种编程模型，他将计算机运算看做是数学中函数的计算，并且避免了状态以及变量的概念。wiki</p>

<p>我们知道，对象是面向对象的第一型，那么函数式编程也是一样，函数是函数式编程的第一型。在面向对象编程中，我们把对象传来传去，那在函数式编程中，我们要做的是把函数传来传去,而这个，说成术语，我们把他叫做高阶函数。飞林沙</p>

<p>在<a href="http://www.cnblogs.com/kym/archive/2011/03/07/1976519.html">函数式编程扫盲篇</a>,我们探求高阶函数：</p>

<p>该文说： 在数学和计算机科学中，高阶函数是至少满足下列一个条件的函数:</p>

<p>接受一个或多个函数作为输入
输出一个函数
重点：</p>

<p>在函数式编程中，函数是基本单位，是第一型，他几乎被用作一切，包括最简单的计算，甚至连变量都被计算所取代。在函数式编程中，变量只是一个名称，而不是一个存储单元，这是函数式编程与传统的命令式编程最典型的不同之处。</p>

<p>在上面的代码中，我们可以简写如下：</p>

<pre><code>lis = [1,2,-3,4,-46,0]
print map(lambda x:0 if x&lt;0 else x, lis)
</code></pre>

<p>该文又介绍了函数式编程与递归，递归是函数式编程的一个重要的概念，循环可以没有，但是递归对于函数式编程却是不可或缺的。</p>

<p>递归其实就是将大问题无限地分解，直到问题足够小。 而递归与循环在编程模型和思维模型上最大的区别则在于：</p>

<p>循环是在描述我们该如何地去解决问题。</p>

<p>递归是在描述这个问题的定义。</p>

<!--more-->

<h1>学习</h1>

<p>阮一峰的网络日志中说：也许继"面向对象编程"之后，"函数式编程"会成为下一个编程的主流范式（paradigm）。</p>

<p>并且总结了函数式编程具有五个鲜明的特点。：</p>

<p>函数是"第一等公民"
只用"表达式"，不用"语句"
没有"副作用"
不修改状态
引用透明
意义如下：</p>

<p>代码简洁，开发快速
函数式编程大量使用函数，减少了代码的重复，因此程序比较短，开发速度较快。</p>

<p>接近自然语言，易于理解
更方便的代码管理
易于"并发编程" 函数式编程不需要考虑"死锁"（deadlock），因为它不修改变量，所以根本不存在"锁"线程的问题。不必担心一个线程的数据，被另一个线程修改，所以可以很放心地把工作分摊到多个线程，部署"并发编程"（concurrency）。
5.代码的热升级</p>

<p>函数式编程没有副作用，只要保证接口不变，内部实现是外部无关的。所以，可以在运行状态下直接升级代码</p>

<p>Python下函数式编程</p>

<p>在理解了上面的文字后，不难发现前言部分所言的Python不大可能会成为一种函数式编程语言，但它支持许多有价值的函数式编程语言构建。</p>

<p>因为python一切皆对象的原则，但是python也提供了函数式编程的支持，就如函数式语言Lisp兴起之后各大热门编程语言都凑热闹纷纷提供对函数式编程的支持一样，Python当然也会分得一杯羹啊。</p>

<p>那下面就学习Python体现函数式编程的方面吧：</p>

<p>方面1：lambda表达式</p>

<p>体现原理就是python允许lambda关键字创建匿名函数，所谓匿名就是python不会创建名称空间，lambda表达式返回可调用的函数对象，这些都符合函数式编程的思想。</p>

<p>方面2：函数式编程的内建函数：apply()、filter()、map()、reduce()</p>

<p>它们都会将函数作为参数。这里重点学习后面三个。</p>

<p>filter(func,seq):</p>

<p>调用一个布尔类型的函数func来迭代遍历每一个seq中的元素，返回一个是func返回值为ture的元素的序列。</p>

<p>示例如下：</p>

<p><img src="http://content.screencast.com/users/BeginMan/folders/Snagit/media/c2c9ffcb-b8c1-490c-bec7-5b5140da1e3a/01.07.2014-23.13.png" alt="" /></p>

<p>当然还可以重构如下，更加简洁：</p>

<pre><code># 重构
from random import randint as r
print [i for i in [r(1, 99) for j in range(10)] if i%2]
map(func, seq1[,seq2...]):
</code></pre>

<p>将函数func作用于给定序列的每一个元素，并用一个列表来提供返回值；如果func为None，func表现为一个身份函数，返回一个含有每个序列中元素集合的n个元祖的列表。</p>

<p>一个简单的例子：</p>

<pre><code># map 针对一个序列
print map(lambda a:a+2, [4,5,6])
# [6, 7, 8]
# 重构
print [i+2 for i in [4,5,6]]

#map 针对多个序列
#在第一次调用时，map()会将每个序列对应位置的元素捆绑到一个元祖中，将func函数作用到map()上
#当map()已经完成执行时，将元祖的结果返回到mapped_seq映射的，最终以整体返回的序列上。
print map(lambda a,b:a+b, [1,2,3],[4,5,6])
# [5, 7, 9]
# print map(lambda a,b:a+b, [1,2,3],[4,5])
# 出错：TypeError: unsupported operand type(s) for +: 'int' and 'NoneType'

#None与map()
print map(None,[1,2,3],[4,5,6]) #[(1, 4), (2, 5), (3, 6)]
#重构
print zip([1,2,3], [4,5,6])
#[(1, 4), (2, 5), (3, 6)]
对于上述的zip:zip([seql, ...])接受一系列可迭代对象作为参数，将对象中对应的元素打包成一个个tuple（元组），然后返回由这些tuples组成的list（列表）。若传入参数的长度不等，则返回list的长度和参数中长度最短的对象相同。 可看这篇博客Python零碎知识(2):强大的zip

print zip([1,2],[1,2,3,4,5]) #[(1, 1), (2, 2)]
print map(None,[1,2],[1,2,3,4,5])   # [(1, 1), (2, 2), (None, 3), (None, 4), (None, 5)]
reduce(func,seq[,init]):
</code></pre>

<p><img src="http://content.screencast.com/users/BeginMan/folders/Snagit/media/efbaae63-99e0-427e-a851-a39b6a098222/01.08.2014-00.05.png" alt="" /></p>

<p>理解方式可以用下面Python代码实现：</p>

<pre><code>"""纯Python模拟reduce()"""
def Myreduce(bin_func,seq,init=None):
    Iseq = list(seq)
    if init is None:
        res = Iseq.pop(0)
    else:
        res = init
    for obj in Iseq:
        res = bin_func(res,obj)
    return res

print Myreduce(lambda x,y:x+y, [i for i in range(10)])  #45
print Myreduce(lambda x,y:x+y, [i for i in range(10)],100)  #145

"""reduce()"""
print reduce(lambda x,y:x+y,[i for i in range(10)]) #45
print reduce(lambda x,y:x+y,[i for i in range(10)],100) #145
</code></pre>

<p>其工作方式如下图：</p>

<p><img src="http://content.screencast.com/users/BeginMan/folders/Snagit/media/e7275a15-0267-4fc4-ac3b-ce34d880bf96/01.08.2014-00.09.png" alt="" /></p>

<h2>参考资料：</h2>

<p><a href="http://www.ruanyifeng.com/blog/2012/04/functional_programming.html">函数式编程初探（阮一峰）</a></p>
