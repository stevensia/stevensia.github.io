---
layout: post
title: "Windows下PHP，Apache搭建"
description: "Windows下PHP，Apache搭建"
category: "windows"
tags: [windows服务器]
---

<h2>一.安装</h2>

<p><strong>千万不要一个个的去下载安装，直接下载个XAMPP套件安装就行</strong>, <a href="https://www.apachefriends.org/download_success.html">XAMPP</a></p>

<h2>二.Apache端口占用无法启动解决方案：</h2>

<p><strong>一、修改端口法：</strong></p>

<pre><code>1.到这个目录下\ xampp\apache\conf  ，打开httpd.conf，将里边的80端口全部改成一个未被占用的端口，比如8001
2.到这个目录 \ xampp\apache\conf\extra ，打开httpd-ssl.conf ，将文件里的443端口全部换成一个未被占用的端口，比如4433
</code></pre>

<p>结论：这个方法不适合我</p>

<!--more-->

<p><strong>二、停止运行占用端口程序法</strong></p>

<p>1、运行-cmd，然后输入netstat -ano，回车；</p>

<p>2、查看本地地址中包含xx.xx.xx.xx:80的那一行的pid，为几个数字，把这几个数字记下来；</p>

<p>3、启动“任务管理器”——“进程”，在工具栏——“选择列”前面的框打上勾；</p>

<p>4、然后查看与刚才那个pid对应的是哪个程序，很容易就会找到，就是它占用了80端口；</p>

<p>5、直接将其停止或者使用优化大师等工具使之开机不启动。</p>

<h2>三、Win7解决Apache2.2的80端口被PID=4的进程占用</h2>

<p>输入命令：<code>netstat -ano</code></p>

<p>查看占用80端口的pid, 如果是发现占用80端口的是system</p>

<p>解决方案：</p>

<p>打开管理工具-服务</p>

<p>找到：World Wide Web Publishing Service 服务 停止就行了。</p>

<p>该服务win7、win8系统下默认的是开机启动，更改为手动启动，然后继续安装我们需要的程序就OK了</p>

<p>然后再重启电脑就ok，如果不行这参考这篇博客<a href="http://www.singlex.net/2467.html">Win7解决Apache2.2的80端口被PID=4的进程占用</a></p>
