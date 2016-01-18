---
layout: post
title: "理解python序列类型的切片"
description: "理解python序列类型的切片"
category: "python"
tags: [python技巧]
---

<h2>一.理解序列类型</h2>

<p>序列类型是可迭代对象，如 lis = ["a", "b", "c", "d", "e"]它的形成如下：</p>

<pre><code>[shell]
+---+---+---+---+---+
 | a | b | c | d | e |
 +---+---+---+---+---+
 0   1   2   3   4   5
-5  -4  -3  -2  -1
[/shell]
</code></pre>

<p>对序列类型的对象可想象成：一个停车场(lis对象)，里面有5个排列开的车位(lis对象下各元素对象)。这些车位从不同的方向看有不同的编号，正向看编号是0到5，反向看编号是-5到-1。</p>

<!--more-->

<p>需要将车开到正向位置编号为3的车位，那么就需要占用lis[3]的区域（内存），那么从反向看就是lis[-2]的位置。</p>

<pre><code>&gt;&gt;&gt; lis[3]
'd'
&gt;&gt;&gt; lis[-2]
'd'
</code></pre>

<p>本来3号位停的是宝马，现在要换成劳斯莱斯，那么需要寻找地址(寻址)，将宝马赶出车位换成劳斯莱斯。lis[3]='L'.</p>

<pre><code>&gt;&gt;&gt; lis[3]='L'
&gt;&gt;&gt; lis
['a', 'b', 'c', 'L', 'e']
</code></pre>

<p>如果突然发生地震了，将3号位置陷下去了，那么就车毁地陷了，同时停车场管理员必须重新编号了，将后面的补上。</p>

<pre><code>&gt;&gt;&gt; del(lis[3])
&gt;&gt;&gt; lis
['a', 'b', 'c', 'e']
</code></pre>

<h2>二.切片操作</h2>

<p>在<a href="http://jianshu.io/p/J4U6rR#"><strong>Python中list的实现</strong></a>一文中了解：</p>

<blockquote>
  <p>Python中list是用下边的C语言的结构来表示的。ob_item是用来保存元素的指针数组，allocated是ob_item预先分配的内存总容量.</p>
  
  <p>非常重要的是知道list申请内存空间的大小（后文用allocated代替）的大小和list实际存储元素所占空间的大小(ob_size)之间的关系，ob_size的大小和len(L)是一样的，而allocated的大小是在内存中已经申请空间大小。通常你会看到allocated的值要比ob_size的值要大。这是为了避免每次有新元素加入list时都要调用realloc进行内存分配。</p>
</blockquote>

<p><img src="https://raw.github.com/acmerfight/insight_python/master/images/list_insert.png" alt="" /></p>

<p>理解上面序列类型就能够清晰的明白切片操作了，如：</p>

<h3>1.列表切片 (a[start:end])</h3>

<pre><code> &gt;&gt;&gt; lis = ['a', 'b', 'c', 'd', 'e']
&gt;&gt;&gt; lis[2:4]
['c', 'd']
</code></pre>

<p>lis[2:4]取值的范围是[2,4)，前面闭区间，后面开区间，也就是2&lt;=索引值&lt;4这段区间里的元素。 可以理解成获取内存地址编号2到4范围（包括2不包括4）的值 。</p>

<p><strong>扩展: lis[2:2]又代表什么呢，[2, 2),  2&lt;=index&lt;2  内存地址编号是2但不包括2，这样的元素不存在啊，我们执行如下：</strong></p>

<pre><code>&gt;&gt;&gt; lis[2:2]
[]
</code></pre>

<p>由于找不到对应的内存地址，Python会临时开辟一块内存，用完之后回立马释放，如上输出<code>[]</code>。这种情形就如同一辆路虎开到在停车场(lis)找不到对应的停车位(lis[2:2])，于是管理员说“你等会，我找找有没有停车位”会给它一块地让它停一会，没有找到则管理员就立马让它开走了。</p>

<p><strong>从上述得之：面切片出来的值['c','d']。它真是反映的是返回的并不是一个值，而是一个引用，我们能对它进行修改，见下面：</strong>。</p>

<h3>2.使用负索引的列表切片</h3>

<pre><code>&gt;&gt;&gt; lis[-3:-1]
['c', 'd']
</code></pre>

<h3>3.带步进值的列表切片 (a[start:end:step])</h3>

<pre><code>&gt;&gt;&gt; lis[::2]
['a', 'c', 'e']
&gt;&gt;&gt; lis[1:4:2]
['b', 'd']
</code></pre>

<h3>4. 负步进值得列表切片</h3>

<pre><code>&gt;&gt;&gt; lis[::-1]
['e', 'd', 'c', 'b', 'a']
&gt;&gt;&gt; list(reversed(lis))   # lis[::-1]等效reversed
['e', 'd', 'c', 'b', 'a']
&gt;&gt;&gt; lis[-4:-1:2]
['b', 'd']
</code></pre>

<h3>5.列表切片赋值</h3>

<pre><code>&gt;&gt;&gt; lis[2:2] = 'B'
&gt;&gt;&gt; lis
['a', 'b', 'B', 'c', 'd', 'e']
&gt;&gt;&gt; lis[1:3] = [1,2,3]
&gt;&gt;&gt; lis
['a', 1, 2, 3, 'c', 'd', 'e']
&gt;&gt;&gt;lis[1:-1]
[1, 2, 3, 'c', 'd']
&gt;&gt;&gt; lis[1:-1] = []
&gt;&gt;&gt; lis
['a', 'e']
</code></pre>

<p>好玩吧，这就是上面说的,我们可以一个个的分析：</p>

<pre><code>lis[2:2] = 'B'
由于没有这个位置，只存在内存编号（索引）为2的位置，这个时候Python会在其后空出一个位置，安排给'B'。

lis[1:3] = [1,2,3]
lis[1:3]取[1,3)的内存编号，其值为'b,B',然后将[1,2,3]对象所占的内存地址赋过去，那么原先的[1:3]地址就被[1,2,3]对应的地址所替代，当然值也引用过去了。于是就变成了 ['a', 1, 2, 3, 'c', 'd', 'e']
lis[1:-1] 同理 将[1,6)地址替换成了[]内存地址，值也被替换成了空值，于是就剩下['a', 'e']了
</code></pre>

<h3>6.命名切片 (slice(start, end, step))</h3>

<p>调用Python内置函数<code>slice()</code>来实现切片，它实现切出[start, end, setp)这块蛋糕，<code>slice</code>返回slice对象。</p>

<pre><code>&gt;&gt;&gt; lis = ['a', 'b', 'c', 'd', 'e']
&gt;&gt;&gt; LAS = slice(-3, None)
&gt;&gt;&gt; LAS
slice(-3, None, None)
&gt;&gt;&gt; LAS
slice(-3, None, None)
&gt;&gt;&gt; lis[LAS]
['c', 'd', 'e']

&gt;&gt;&gt; a = [1, 2, 3, 4, 5]
&gt;&gt;&gt; sliceObj = slice(1, 3) 
&gt;&gt;&gt; a[sliceObj]
[2, 3]
</code></pre>

<h3>7.itertools的切片</h3>

<p>参考<a href="https://docs.python.org/2/library/itertools.html#itertools.islice">https://docs.python.org/2/library/itertools.html#itertools.islice</a>:</p>

<pre><code>itertools.islice(iterable, start, stop[, step])
</code></pre>

<p>创建一个迭代器，生成项的方式类似于切片返回值： iterable[start : stop : step]，将跳过前start个项，迭代在stop所指定的位置停止，step指定用于跳过项的步幅。与切片不同，负值不会用于任何start，stop和step，如果省略了start，迭代将从0开始，如果省略了step，步幅将采用1.</p>

<pre><code>&gt;&gt;&gt; from itertools import  islice
&gt;&gt;&gt; lis = ['a', 'b', 'c', 'd', 'e']
&gt;&gt;&gt; islice(lis, 2)
&lt;itertools.islice object at 0xb69c72d4&gt;
&gt;&gt;&gt; list(islice(lis, 2))   # 取前两个[0, 2)
['a', 'b']
&gt;&gt;&gt; list(islice(lis, 4))
['a', 'b', 'c', 'd']
&gt;&gt;&gt; list(islice(lis, 1))
['a']
&gt;&gt;&gt; list(islice(lis, 0))
[]
&gt;&gt;&gt; list(islice(lis, 2, 4))
['c', 'd']
&gt;&gt;&gt; list(islice(lis, 2, None))
['c', 'd', 'e']
&gt;&gt;&gt; list(islice(lis, 0, None, 2))
['a', 'c', 'e']
</code></pre>

<p>其生成方式如下：</p>

<pre><code>it = iter(xrange(s.start or 0, s.stop or sys.maxint, s.step or 1))
# 这段代码值得我们品味哦
</code></pre>
