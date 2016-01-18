---
layout: post
title: "理解python __name__"
description: "理解python __name__"
category: "Python"
tags: [Python]
---

<p>初学python的时候不知道<code>__name__=="__main__"</code>是什么意思，这里总结下。这里需要明白以下几点：</p>

<ol>
<li><p>python中一切皆对象，模块，类等都是对象，是对象就一定有<strong>属性</strong></p></li>
<li><p>python文件有两种执行方式，一则import 模块调用，二则直接执行</p></li>
<li><p>每个对象都有<code>__name__</code>属性，<code>__name__</code>，如果是放在Modules模块中，就表示是模块的名字；如果是放在Classs类中，就表示类的名字；</p></li>
<li><p>import模块时，<code>__name__</code> 的值通常为模块文件名；当直接执行py时候不被模块调用时，则<code>__name__</code>就等于'<code>__main__</code>'</p></li>
</ol>

<p>校验如下：</p>

<pre><code>#a.py
#coding=utf8
if __name__=='__main__':
    print 'aaa'
else:
    print 'bbbbb'
</code></pre>

<p>我们直接运行时 会输出 'aaa'</p>

<p>然后试着import</p>

<pre><code>#b.py
import a    # 将a导入，以模块的形式调用
print 'sss'
</code></pre>

<p>此时运行会输出 'bbb','sss'</p>
