---
layout: post
title: "siege webSite 测压工具"
description: "siege webSite 测压工具"
category: "linux"
tags: [linux服务器]
---
<p><a href="http://www.joedog.org/siege-home/">siege</a>比较有名的web测压工具，在<a href="http://www.joedog.org/siege-manual/">siegu指南(manual)</a>中有较全的文档，siege模拟请求，<strong>对站点进行多用户的并发访问或重复访问</strong></p>

<p><img src="http://coolshell.cn//wp-content/uploads/2010/07/get_more_web_traffic.jpg" alt="" /></p>

<p>图片来源：<a href="http://coolshell.cn//wp-content/uploads/2010/07/get_more_web_traffic.jpg">CoolShell.十个免费的Web压力测试工具
</a></p>

<!--more-->

<p>安装方式：</p>

<pre><code>wget http://download.joedog.org/siege/siege-3.0.8.tar.gz
tar -zxvf siege-3.0.8.tar.gz
cd siege-3.0.8
./configure
make
sudo make install
</code></pre>

<p>它有很多参数，具体参考文档，常见的有：</p>

<p><code>-v</code>: 运行时能看到详细信息</p>

<p><code>-c</code>: 连接数 如 -c 100表示模拟100个用户并发访问</p>

<p><code>-i</code>,–internet 随机访问urls.txt中的url列表项,以此模拟真实的访问情况(随机性),当urls.txt存在是有效</p>

<p><code>-d</code> n,–delay=n hit每个url之间的延迟,在0-n之间</p>

<p><code>-r</code> n,–reps=n 重复运行测试n次,不能与 -t同时存在</p>

<p><code>-t</code> n,–time=n 持续运行siege ‘n’秒(如10S),分钟(10M),小时(10H)</p>

<p><code>-l</code> 运行结束,将统计数据保存到日志文件中siege .log,一般位于/usr/local/var/siege .log中,也可在.siegerc中自定义</p>

<p><code>-R</code> SIEGERC,–rc=SIEGERC 指定用特定的siege 配置文件来运行,默认的为$HOME/.siegerc</p>

<p><code>-f</code> FILE, –file=FILE 指定用特定的urls文件运行siege ,默认为urls.txt,位于siege 安装目录下的etc/urls.txt</p>

<p><code>-u</code> URL,–url=URL 测试指定的一个URL,对它进行”siege “,此选项会忽略有关urls文件的设定</p>

<p>urls.txt文件：是很多行待测试URL的列表以换行符断开,格式为:</p>

<pre><code>[protocol://]host.domain.com[:port][path/to/file]   
</code></pre>

<p>如下操作：</p>

<pre><code># 对百度进行并发重复100次访问
siege -c 300 -r 100 -f baidu.com

# 对url.txt里的ulr进行随机访问
vim url.txt
#添加多个url路径
siege -c 300 -r 100 -f url.txt
</code></pre>

<p>结果说明：</p>

<blockquote>
  <p>** SIEGE 2.72</p>
  
  <p>** Preparing 300 concurrent users for battle.
  The server is now under siege.. done.</p>
  
  <p>Transactions: 30000 hits //完成30000次处理</p>
  
  <p>Availability: 100.00 % //100.00 % 成功率</p>
  
  <p>Elapsed time: 68.59 secs //总共使用时间</p>
  
  <p>Data transferred: 817.76 MB //共数据传输 817.76 MB</p>
  
  <p>Response time: 0.04 secs //响应时间，显示网络连接的速度</p>
  
  <p>Transaction rate: 437.38 trans/sec //平均每秒完成 437.38 次处理</p>
  
  <p>Throughput: 11.92 MB/sec //平均每秒传送数据</p>
  
  <p>Concurrency: 17.53 //实际最高并发连接数</p>
  
  <p>Successful transactions: 30000 //成功处理次数</p>
  
  <p>Failed transactions: 0 //失败处理次数</p>
  
  <p>Longest transaction: 3.12 //每次传输所花最长时间</p>
  
  <p>Shortest transaction: 0.00 //每次传输所花最短时间</p>
</blockquote>

<p>我们也能用<code>siege</code> 对Tornado项目进行模拟，如下：</p>

<pre><code>$ siege http://localhost:8000/?q=pants -c10 -t10s
</code></pre>

<p>Siege对我们的应用在10秒内执行大约10个并发请求。</p>

<p>还有一些其他的测压工具，如Apache下自带的<code>ab</code>, 如<code>ab -c 100 -n 1000 http://www.baidu.com/</code> 对百度每次并发发送100个请求，共发送1000的请求。</p>

<p><a href="http://www.ha97.com/4663.html"><strong>参考:（总结）Web性能压力测试工具之Siege详解</strong></a></p>
