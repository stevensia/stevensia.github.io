---
layout: post
title: "python if else 多种写法"
description: "python if else 多种写法"
category: "python"
tags: [python技巧]
---

<p>For example:</p>

<pre><code>a, b, c = 1, 2, 3
</code></pre>

<p><strong>1. Common:</strong></p>

<pre><code>if a &gt; b:
    c =  a
else:
    c = b
</code></pre>

<p><strong>2.Expression:</strong></p>

<pre><code>c = a if a&gt;b else b
</code></pre>

<p><strong>3.二维列表:</strong></p>

<pre><code>c = [b,a][a&gt;b]
</code></pre>

<p><strong>4.Other:</strong></p>

<pre><code>c = (a&gt;b and [a] or [b])[0]
</code></pre>

<p><a href="http://www.open-open.com/lib/view/open1346511811678.html">From Here</a></p>
