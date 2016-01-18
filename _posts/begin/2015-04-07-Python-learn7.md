---
layout: post
title: "Python性能分析工具"
description: "Python性能分析工具"
category: "Python"
tags: [Python]
---

<h1>性能分析</h1>

<p>在编写程序时往往没有考虑性格,只注重了实现,有时会导致运行慢,内存溢出等问题.在<a href="http://zh.wikipedia.org/zh-cn/%E6%80%A7%E8%83%BD%E5%88%86%E6%9E%90">wiki</a> 关于性能分析这样描述:</p>

<blockquote>
  <p>在软件工程中，性能分析（performance analysis也称为profiling），是以收集程序运行时信息为手段研究程序行为的分析方法,性能分析量测像是程序的空间或时间复杂度、特定指令的使用情形、函数调用的频率及运行时间等。性能分析的目的在于决定程序的哪个部分应该被优化，从而提高程序的速度或者内存使用效率。</p>
</blockquote>

<!--more-->

<p>关于Python性能分析,这里推荐阅读:<a href="http://www.oschina.net/translate/python-performance-analysis">Python性能分析指南</a>.</p>

<p><strong>关于如何分析一个程序的性能有以下几点:</strong></p>

<blockquote>
  <p>1.运行时间(基础数据和测试数据来统计)</p>
  
  <p>2.运行速度瓶颈所在(通过细粒统计每行所用的时间来找出瓶颈)</p>
  
  <p>3.运行时所占的内存多少</p>
  
  <p>4.是否有内存泄漏,在哪里?</p>
</blockquote>

<h1>二.Python性能分析工具</h1>

<h2>1.Python标准库提供的cProfile,profile,hotshot</h2>

<p>常用前两者,<a href="https://docs.python.org/2/library/profile.html">文档中</a>描述详尽,用法如下:</p>

<pre><code>import cProfile
def tes():
    return [i for i in range(10000) if i % 2 == 0]

cProfile.run('tes()')    # 终端显示
cProfile.run('tes()', 'result.log')  # 导出数据,不过可读性很差需结合pstats
# 命令行形式
python -m cProfile [-o output_file] [-s sort_order] myscript.py
</code></pre>

<p>不过注意一点,在同一终端下存在缓存,故以第一次执行信息为准.</p>

<p>hotshot是高性能的Profiling数据采集工具，其运行时对程序效率的影响很小，但会产生巨大的运行记录，分析也比较慢. 如:</p>

<pre><code>&gt;&gt;&gt; import hotshot
&gt;&gt;&gt; profiler = hotshot.Profile("hotshot.log")
&gt;&gt;&gt; profiler = hotshot.Profile("/home/beginman/result.log")
&gt;&gt;&gt; profiler.run('tes()')
&lt;hotshot.Profile instance at 0xb65f5a0c&gt;
</code></pre>

<p>还有些数据可视化如<code>Gprof2Dot</code>,<code>Run Snake Run</code>, <code>KCacheGrind</code>等工具,可参考<a href="http://linux-wiki.cn/wiki/zh-hans/Python%E6%80%A7%E8%83%BD%E5%88%86%E6%9E%90_(Profiling)">Python性能分析 (Profiling)</a></p>

<p><img src="http://linux-wiki.cn/images/5/52/Run_snake_run.png" alt="" /></p>

<p><strong>时间统计:使用计时上下文管理器进行细粒度计时</strong> 这段代码给人很大的启迪:</p>

<pre><code>#!/usr/bin/env python
# coding=utf-8
import time

class Timer(object):
    def __init__(self, verbose=True):
        self.verbose = verbose

    def __enter__(self):
        self.start = time.time()
        return self

    def __exit__(self, *args):
        self.end = time.time()
        self.times = (self.end - self.start)*1000
        if self.verbose:
            print u"程序运行时间为:%s" % self.times

def testTime():
    return [i for i in range(10000) if i%2 == 0]

with Timer() as t:
    testTime()
</code></pre>

<p>为了使用它，你需要用Python的with关键字和Timer上下文管理器包装想要计时的代码块。它将会在你的代码块开始执行的时候启动计时器，在你的代码块结束的时候停止计时器。<strong>这是上下文管理对象与with语句的经典运用了.</strong></p>

<p>这里只是简单描述和运用简单的脚本工具来查看程序性能,更多的知识点参考<a href="http://www.oschina.net/translate/python-performance-analysis">Python性能分析指南</a></p>
