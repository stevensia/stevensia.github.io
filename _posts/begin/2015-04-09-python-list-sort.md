---
layout: post
title: "python list 排序"
description: "python list 排序"
category: "python"
tags: [python技巧]
---

<p>具体实例可参考：<a href="http://wangwei007.blog.51cto.com/68019/1100742"><strong>python的排序函数sort,sorted在列表排序和字典排序中的应用详解和举例</strong></a></p>

<p>现在有这种情况，排序中排序。如大题号排序，然后大题对应的小题号也排序，如下：
    [python]
    lis = [{'Big':3, 'small':2},{'Big':3, 'small':4},{'Big':2, 'small':2}, {'Big':3, 'small':1},{'Big':2, 'small':1},{'Big':1, 'small':1}]</p>

<pre><code># 大题号排序
li = sorted(lis, key=lambda s: s['Big'])

# 输出：
#[{'small': 1, 'Big': 1}, {'small': 2, 'Big': 2}, {'small': 1, 'Big': 2}, {'small': 2, 'Big': 3}, {'s
mall': 4, 'Big': 3}, {'small': 1, 'Big': 3}]

# 小题号排序：
sort_ff = []
no = set([i['Big'] for i in li])
for obj in no:
    li_ = []
    for i in ff:
        if i['Big'] == obj:
            li_.append(i)
    l = sorted(li_, key=lambda s: s['small'])
    for j in l:
        sort_ff.append(j)

# 输出结果：
[{'small': 1, 'Big': 1}, {'small': 1, 'Big': 2}, {'small': 2, 'Big': 2}, {'small': 1, 'Big': 3}, {'small': 2, 'Big': 3}, {'small': 4, 'Big': 3}]
[/python]
</code></pre>

<p><strong>善用sort() 或 sorted(),  a.sort() 已改变其结构，b = a.sort() 是错误的写法! 而 sorted(a, ...)并没有改变a的结构。</strong></p>
