---
layout: post
title: "Python 深入zip与列表推导"
description: "Python 深入zip与列表推导"
category: "python"
tags: [python技巧]
---

<h2>一.zip的魔法</h2>

<p>关于<code>zip</code>可参考<a href="www.cnblogs.com/BeginMan/archive/2013/03/14/2959447.html">Python强大的zip</a>,这里有几个小技巧</p>

<!--more-->

<h3>(1).压缩，解压缩</h3>

<pre><code>&gt;&gt;&gt; a=[1,2,3]
&gt;&gt;&gt; b=[4,5,6]
&gt;&gt;&gt; x,y = zip(*zip(a, b))
&gt;&gt;&gt; x,y
((1, 2, 3), (4, 5, 6))
</code></pre>

<h3>(2).合并相邻的列表项</h3>

<pre><code>&gt;&gt;&gt; a = [1, 2, 3, 4, 5, 6]
&gt;&gt;&gt; zip(*([iter(a)] * 2))
[(1, 2), (3, 4), (5, 6)]
# 过程
&gt;&gt;&gt; c = iter(a)
&gt;&gt;&gt; c
&lt;listiterator object at 0xb69ff40c&gt;
&gt;&gt;&gt; c = [c][/c]
&gt;&gt;&gt; c
[&lt;listiterator object at 0xb69ff40c&gt;]
&gt;&gt;&gt; c=c*2
&gt;&gt;&gt; c
[&lt;listiterator object at 0xb69ff40c&gt;, &lt;listiterator object at 0xb69ff40c&gt;]
&gt;&gt;&gt; zip(*c)  # 解压
[(1, 2), (3, 4), (5, 6)]
</code></pre>

<p>扩展：<code>zip(*([iter(a)] * k))</code> a表示可迭代对象，k表示相邻的k个，Python会自动组合，未匹配组合的则剔除，如：</p>

<pre><code>&gt;&gt;&gt; a = [1, 2, 3, 4, 5, 6]
&gt;&gt;&gt; zip(*([iter(a)]*4))   # 相邻的四个
[(1, 2, 3, 4)]
</code></pre>

<p>扩展如下：</p>

<pre><code>&gt;&gt;&gt; group_adjacent = lambda a, k: zip(*([iter(a)] * k))
&gt;&gt;&gt; group_adjacent(a, 3)
[(1, 2, 3), (4, 5, 6)]
&gt;&gt;&gt; group_adjacent(a, 2)
[(1, 2), (3, 4), (5, 6)]
&gt;&gt;&gt; group_adjacent(a, 1)
[(1,), (2,), (3,), (4,), (5,), (6,)]
</code></pre>

<p>或者：</p>

<pre><code>&gt;&gt;&gt; zip(a[::2], a[1::2])
[(1, 2), (3, 4), (5, 6)]

&gt;&gt;&gt; zip(a[::3], a[1::3], a[2::3])
[(1, 2, 3), (4, 5, 6)]

&gt;&gt;&gt; group_adjacent = lambda a, k: zip(*(a[i::k] for i in range(k)))
&gt;&gt;&gt; group_adjacent(a, 3)
[(1, 2, 3), (4, 5, 6)]
&gt;&gt;&gt; group_adjacent(a, 2)
[(1, 2), (3, 4), (5, 6)]
&gt;&gt;&gt; group_adjacent(a, 1)
[(1,), (2,), (3,), (4,), (5,), (6,)]
</code></pre>

<h3>3.反转字典</h3>

<pre><code>&gt;&gt;&gt; m = {'a': 1, 'b': 2, 'c': 3, 'd': 4}
&gt;&gt;&gt; dic = dict(zip(m.values(), m.keys()))
&gt;&gt;&gt; dic
{1: 'a', 2: 'b', 3: 'c', 4: 'd'}

#过程
&gt;&gt;&gt; x = m.values()
&gt;&gt;&gt; y = m.keys()
&gt;&gt;&gt; x, y
([1, 3, 2, 4], ['a', 'c', 'b', 'd'])
&gt;&gt;&gt; d = zip(x, y)
&gt;&gt;&gt; d
[(1, 'a'), (3, 'c'), (2, 'b'), (4, 'd')]
&gt;&gt;&gt; dic = dict(d)
&gt;&gt;&gt; dic
{1: 'a', 2: 'b', 3: 'c', 4: 'd'}
</code></pre>

<h2>二.摊平列表</h2>

<p>如何让[1, 2], [3, 4], [5, 6] 平摊成[1, 2, 3, 4, 5, 6]</p>

<h3>1.<code>itertools</code>模块</h3>

<pre><code>&gt;&gt;&gt; a = [[1, 2], [3, 4], [5, 6]]
&gt;&gt;&gt; list(itertools.chain.from_iterable(a))
[1, 2, 3, 4, 5, 6]
</code></pre>

<p>关于<code>itertools</code>模块参考这里<a href="http://www.cnblogs.com/cython/articles/2169009.html">Python：itertools模块</a></p>

<pre><code>chain(iter1, iter2, ..., iterN)：  给出一组迭代器(iter1, iter2, ..., iterN)，创建一个新迭代器来将所有的迭代器链接起来.
</code></pre>

<p><code>chain</code>可以写成：</p>

<pre><code>&gt;&gt;&gt; a1, a2, a3 = a[0], a[1], a[2]
&gt;&gt;&gt; t = chain(a1, a2, a3)
&gt;&gt;&gt; list(t)
[1, 2, 3, 4, 5, 6]
</code></pre>

<p><code>chain.from_iterable</code>：</p>

<pre><code>chain.from_iterable(iterables):一个备用链构造函数，其中的iterables是一个迭代变量，生成迭代序列
</code></pre>

<p>也就是上面的，如果用生成器函数则可写成：</p>

<pre><code>&gt;&gt;&gt; def f(iterables):
...     for x in iterables:
...         for y in x:
...             yield y
...           
&gt;&gt;&gt; t = f(a)
&gt;&gt;&gt; list(t)
[1, 2, 3, 4, 5, 6]
</code></pre>

<h3>2.sum(i, start)</h3>

<pre><code>&gt;&gt;&gt; sum(a, [])
[1, 2, 3, 4, 5, 6]
</code></pre>

<p>sum的start默认是0，如：</p>

<pre><code>&gt;&gt;&gt; l = [1,2,3]
&gt;&gt;&gt; sum(l)
6
&gt;&gt;&gt; sum(l, 0)
6
&gt;&gt;&gt; sum(l, 100)
106
&gt;&gt;&gt; sum(l, -4)
2
&gt;&gt;&gt; sum('abcd')
Traceback (most recent call last):
  File "&lt;input&gt;", line 1, in &lt;module&gt;
TypeError: unsupported operand type(s) for +: 'int' and 'str'
&gt;&gt;&gt; sum('abcd', 'j')
Traceback (most recent call last):
  File "&lt;input&gt;", line 1, in &lt;module&gt;
TypeError: sum() can't sum strings [use ''.join(seq) instead]
</code></pre>

<p>sum([[1, 2], [3, 4], [5, 6]])相当于：[1,2]+[3,4]+[5,6], 由于默认start为0，前面的加起来为[1,2,3,4,5,6]如果加上0那就语法错误了，所以我们给出start是[],这么一来就可以了，所以<code>sum([[1, 2], [3, 4], [5, 6]], [])</code>就显得十分Pythonic了。</p>

<h3>3.列表推导</h3>

<pre><code>&gt;&gt;&gt; [y for x in a for y in x]
[1, 2, 3, 4, 5, 6]

做成通用点就这样：
&gt;&gt;&gt; res = lambda it: [y for x in a for y in x]
&gt;&gt;&gt; res(a)
[1, 2, 3, 4, 5, 6]

#演示过程见下面
</code></pre>

<h3>4.reduce</h3>

<pre><code>&gt;&gt;&gt; l = [[1,2,3],[4,5,6], [7], [8,9]]
&gt;&gt;&gt; reduce(lambda x,y: x+y,l)
[1, 2, 3, 4, 5, 6, 7, 8, 9]
</code></pre>

<h3>5.operator</h3>

<pre><code>&gt;&gt;&gt; import operator
&gt;&gt;&gt; l = [[1,2,3],[4,5,6], [7], [8,9]]
&gt;&gt;&gt; reduce(operator.add, l)
[1, 2, 3, 4, 5, 6, 7, 8, 9]
</code></pre>

<h2>三.列表推导</h2>

<h3>1.在列表推导中使用if else</h3>

<pre><code>&gt;&gt;&gt; l = [22, 13, 45, 50, 98, 69, 43, 44, 1]
&gt;&gt;&gt; [x+1 if x &gt;= 45 else x+10 for x in l]    
# 即  [ (x+1 if x &gt;=45 else x+5)  for x in l ]
[32, 23, 46, 51, 99, 70, 53, 54, 11]

# 还有一种：
 [[x+5,x+1][x &gt;= 45] for x in l]   
</code></pre>

<h3>2.多项列表推导</h3>

<p>对上面列表平摊的解释：</p>

<pre><code>&gt;&gt;&gt;l = [[1, 2, 3], [4, 5, 6], [7], [8, 9]]
&gt;&gt;&gt;print [y for x in l for y in x]
[1, 2, 3, 4, 5, 6, 7, 8, 9]
</code></pre>

<p>流程图如下：</p>

<p><img src="http://images.cnblogs.com/cnblogs_com/BeginMan/486940/o_listshow1.png" alt="" /></p>

<p>程序执行图：演示1.<a href="http://pythontutor.com/visualize.html#code=l+%3D+%5B%5B1,+2,+3%5D,+%5B4,+5,+6%5D,+%5B7%5D,+%5B8,+9%5D%5D%0Aprint+%5By+for+x+in+l+for+y+in+x%5D%0A&amp;mode=display&amp;origin=opt-frontend.js&amp;cumulative=false&amp;heapPrimitives=false&amp;drawParentPointers=false&amp;textReferences=false&amp;showOnlyOutputs=false&amp;py=2&amp;rawInputLstJSON=%5B%5D&amp;curInstr=15">这里</a></p>

<p><img src="http://images.cnblogs.com/cnblogs_com/BeginMan/486940/o_list1.png" alt="" /></p>

<p>更多：</p>

<pre><code>l = [[[1, 2], [3, 4]], [[5, 6], [7, 8]]]
&gt;&gt;&gt; print [y for x in a for c in x for y in c]
[1, 2, 3, 4, 5, 6, 7, 8]
</code></pre>

<p>流程图如下：</p>

<p><img src="http://images.cnblogs.com/cnblogs_com/BeginMan/486940/o_listshow2.png" alt="" /></p>

<p>程序执行图, 演示2.<a href="http://pythontutor.com/visualize.html#code=l+%3D+%5B%5B%5B1,+2%5D,+%5B3,+4%5D%5D,+%5B%5B5,+6%5D,+%5B7,+8%5D%5D%5D%0Aprint+%5By+for+x+in+l+for+c+in+x+for+y+in+c%5D&amp;mode=display&amp;origin=opt-frontend.js&amp;cumulative=false&amp;heapPrimitives=false&amp;drawParentPointers=false&amp;textReferences=false&amp;showOnlyOutputs=false&amp;py=2&amp;rawInputLstJSON=%5B%5D&amp;curInstr=16">这里</a>：</p>

<p><img src="http://images.cnblogs.com/cnblogs_com/BeginMan/486940/o_list2.png" alt="" /></p>

<p>**总结：多个for和if连续使用时，for分开看，if从属性于离它左边最近的那个for，多个 if之间的逻辑关系为 AND;<br />
**</p>

<h3>3.对于字典</h3>

<pre><code>&gt;&gt;&gt; m = {x: x ** 2 for x in range(5)}
&gt;&gt;&gt; m
{0: 0, 1: 1, 2: 4, 3: 9, 4: 16}
</code></pre>

<p>可以通过迭代字典反转字典：</p>

<pre><code>&gt;&gt;&gt; m = {'a': 1, 'b': 2, 'c': 3, 'd': 4}
&gt;&gt;&gt; m
{'d': 4, 'a': 1, 'b': 2, 'c': 3}
&gt;&gt;&gt; {v: k for k, v in m.items()}
{1: 'a', 2: 'b', 3: 'c', 4: 'd'}
</code></pre>

<h2>参考</h2>

<p><a href="http://www.oschina.net/translate/thirty-python-language-features-and-tricks-you-may-not-know">1.你可能不知道的 30 个 Python 语言的特点技巧</a></p>

<p><a href="http://stackoverflow.com/questions/406121/flattening-a-shallow-list-in-python">2.Flattening a shallow list in Python</a></p>
