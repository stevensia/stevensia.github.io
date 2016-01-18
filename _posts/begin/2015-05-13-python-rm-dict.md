---
layout: post
title: "移除python字典元素的几种方式"
description: "移除python字典元素的几种方式"
category: "python"
tags: [python奇技淫巧]
---

<p>对字典元素的删除通常有两种办法<code>del</code>和<code>pop</code>, 推荐使用<code>del</code>,因为它更高效些。</p>

<pre><code>mydict.pop(key)

del mydict[key]
</code></pre>

<p>pop方法删除键，并且返回键对应的值, del内置方法直接删除元素.</p>

<p>在forloop中，有以下几种方法删除key：</p>

<pre><code>&gt;&gt;&gt; mydict = {'one': 1, 'two': 2, 'three': 3, 'four': 4}
</code></pre>

<p><strong>way 1:使用keys(),items()</strong></p>

<pre><code>&gt;&gt;&gt; for k in mydict.keys():    # 换成items()也可，但是如果换成
...    if k == 'two':
...        del mydict[k]
...
&gt;&gt;&gt; mydict
{'four': 4, 'three': 3, 'one': 1}
</code></pre>

<p><strong>way 2:类列表推导</strong></p>

<pre><code>mydict = {k:v for k,v in mydict.iteritems() if k != 'one'}
mydict
{'four': 4, 'three': 3}

mydict = {k:v for k,v in mydict.items() if k != 'four'}

mydict
{'three': 3}
</code></pre>

<p>这里iteritems()对于大的dict性能方面是有很大的提升，所以这种方式推荐使用<code>iteritems()</code></p>

<p><strong>way 3.dict()</strong></p>

<pre><code>mydict = dict((k,v) for k,v in mydict.iteritems() if k != 'three')
</code></pre>
