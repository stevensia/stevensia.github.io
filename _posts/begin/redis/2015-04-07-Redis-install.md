---
layout: post
title: "Redis安装,部署与应用"
description: "Redis安装,部署与应用"
category: "redis"
tags: [redis]
---
<h1>一.NoSQL</h1>

<p>从<a href="http://zh.wikipedia.org/zh-cn/NoSQL">wiki</a>中我总结如下:</p>

<p>1.NoSQL可以是Not Only SQL的缩写,是非关系型数据库.</p>

<p>2.两大特征:(1).使用硬盘,(2).或使用随机存储器(是与CPU直接交换数据的内部存储器，也叫主存。它可以随时读写，而且速度很快，通常作为操作系统或其他正在运行中的程序的临时数据存储媒介。)作存储载体.</p>

<p>3.产生背景:关系型数据库如mysql,mssql等对大规模数据的读写的力不从心,对于动态快速响应的瓶颈等导致NoSQL的出现</p>

<p>4.NoSQL的优缺点:优点(高性能,高可用,易扩展,低廉等); 缺点(不支持SQL,特性不丰富,不太成熟)</p>

<p>常见的NoSQL数据库有以下八种:</p>

<p><code>Cassandra</code>、<code>Mongodb</code>、<code>CouchDB</code>、<code>Redis</code>、 <code>Riak</code>、<code>Membase</code>、<code>Neo4j</code>,<code>HBase</code>.</p>

<!--more-->

<p>更多内容参考:</p>

<p><a href="http://www.siat.ac.cn/xscbw/xsqk/201010/W020101009553511860572.pdf">1.NoSQL非关系型数据库综述</a></p>

<p><a href="http://blog.jobbole.com/1344/">2.8种Nosql数据库系统对比</a></p>

<h1>二.Redis</h1>

<p><img src="http://images.cnblogs.com/cnblogs_com/BeginMan/486940/o_0.jpg" alt="" /></p>

<p>Redis是一个开源、支持网络、基于内存、键值对存储数据库，使用ANSI C编写。在<a href="http://www.redis.cn/">Redis(中文)官网</a>上这样介绍:</p>

<blockquote>
  <p>Redis 是完全开源免费的，遵守BSD协议，先进的key - value持久化产品。它通常被称为数据结构服务器，因为值（value）可以是 字符串(String), 哈希(Map), 列表(list), 集合(sets) 和 有序集合(sorted sets)等类型。</p>
</blockquote>

<p>原本想接触Mongodb,但一看Redis的图标,于是就选择了她.....</p>

<h1>三.Redis linux下安装,配置与使用</h1>

<h3>安装</h3>

<p>(1).到<a href="http://redis.io/download">http://redis.io/download</a>下载对应版本</p>

<p>(2).解压:<code>tar -zxf redis-2.8.3.tar.gz</code></p>

<p>(3).安装</p>

<pre><code>!/bin/bash
cd redis-2.8.3 
sudo make 
sudo make install
</code></pre>

<p>(4).copy到/usr/bin/和/etc/目录下</p>

<pre><code>!/usr/bin/env bash
sudo cp src/redis-server src/redis-cli /usr/bin/
sudo cp redis.conf /etc/
</code></pre>

<p>(5).修改配置文件</p>

<pre><code>!/bin/bash
sudo vim /etc/redis.conf
./daemonize  # 在vim下执行 `:`然后输入前面查找daemonize 
daemonize yes   # 将no 改成yes 让server以守护进程在后台执行
</code></pre>

<p>(6).测试</p>

<pre><code>make test
# 运行几分钟后直到出现\o/ All tests passed without errors! 表示安装成功
</code></pre>

<h3>2.配置</h3>

<pre><code>cd utils/
sudo ./install_server.sh  
# 出现配置选项,默认回车即可
</code></pre>

<h3>3.运行</h3>

<pre><code>/etc/init.d/redis_6379 start    # 运行   
/etc/init.d/redis_6379 stop     # 结束

ps -ef | grep 6379              # 查看 6379是Redis默认端口
</code></pre>

<h3>4.操作</h3>

<pre><code>!/bin/bash
[beginman@beginman sae]$ redis-cli    # 打开Redis
127.0.0.1:6379&gt; set key 100           # 增
OK
127.0.0.1:6379&gt; get key               # 查
"100"
127.0.0.1:6379&gt; exists key            # 查
(integer) 1
127.0.0.1:6379&gt; set key 200           # 改
OK
127.0.0.1:6379&gt; del key               # 删
(integer) 1
127.0.0.1:6379&gt; 
</code></pre>

<p>参考<a href="http://blog.csdn.net/daniel_ustc/article/details/18099067">linux 下安装、使用 redis</a></p>

<h1>四.学习</h1>

<p><a href="http://www.redis.cn/">1.Redis中文文档</a></p>

<p><a href="http://blog.nosqlfan.com/">2.关注NoSQL相关的新闻与技术</a></p>

<p><a href="http://book.douban.com/subject/24522045/">3.书籍:Redis入门指南</a></p>

<p><a href="http://book.douban.com/subject/25900156/">4.Redis设计与实现</a></p>

<p><a href="http://blog.nosqlfan.com/html/1282.html">5.Redis资料汇总</a></p>

<p><a href="http://blog.nosqlfan.com/html/3202.html">6.十五分钟介绍 Redis数据结构</a></p>
