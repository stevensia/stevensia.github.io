---
layout: post
title: "git 批量删除文件&amp;find 多文件的使用"
description: "git 批量删除文件&amp;find 多文件的使用"
category: "linux基础"
tags: [linux基础]
---

<p>最近遇到一个问题就是git忽略文件被跟踪了,想批量删除,使用<code>git rm --cached *.pyc</code>肯定不行的.于是就想到了<code>find</code>命令.find查找多个文件或者排除文件该如何操作呢?这里总结如下:</p>

<h2>1.<code>-name</code>&amp;<code>-o</code>配合使用</h2>

<p><code>-o</code>意思就是<code>or</code>, 那么多个配合就难检索多个文件,命令如下:</p>

<pre><code>find . -name "*.pyc" -o -name "*.html"
</code></pre>

<p>或者是这样:</p>

<pre><code>find ./ -type f \( -iname \*.pyc -o -iname \*.html\)
</code></pre>

<h2>2.使用正则</h2>

<pre><code>find . -regex '.*\.txt\|.*\.log\|.*\.pyc'
</code></pre>

<p>或者是:</p>

<pre><code>find -iregex '.*\.\(jpg\|gif\|png\|jpeg\)$'   
</code></pre>

<h2>3.排除某些文件</h2>

<p>排除的时候需要<code>! -name</code>进行排除.如下排除所有html文件:</p>

<pre><code>find . -type f ! -name "*.html"    
</code></pre>

<p>批量排除的话就不用带<code>or</code>了,如下:</p>

<pre><code>find . -type f ! -name "*.html" ! -name "*.log"
</code></pre>

<p><strong>那么批量删除git被跟踪文件解决方案就是:</strong></p>

<pre><code>find . -regex '.*\.txt\|.*\.log\|.*\.pyc' -exec git rm --cached {} \;
</code></pre>
