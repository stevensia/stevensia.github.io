---
layout: post
title: "CentOS 端口操作"
description: "CentOS 端口操作"
category: "linux"
tags: [linux基础]
---

<h2>1.使用介绍</h2>

<p>linux 防火墙 <code>iptables</code>服务 在CentOS中默认没有加入启动项中，这里我们需要：</p>

<pre><code>chkconfig iptables on   #永久
service iptables start  #启动该服务
</code></pre>

<p>iptables服务常用命令：</p>

<pre><code>service iptables save|status|stop|start|restart
</code></pre>

<!--more-->

<p>如，查看目前防火墙状态：</p>

<pre><code>[root@fang sync]# service iptables status
Table: filter
Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination
1    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:2812
2    fail2ban-SSH  tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:22

Chain FORWARD (policy ACCEPT)
num  target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
num  target     prot opt source               destination

Chain fail2ban-SSH (1 references)
num  target     prot opt source               destination
1    RETURN     all  --  0.0.0.0/0            0.0.0.0/0
</code></pre>

<h2>2.开启或关闭某个端口</h2>

<p>对端口开放方式有两种：</p>

<ol>
<li>vim /etc/sysconfig/iptables   编辑</li>
<li>命令添加，如：iptables -I INPUT -p tcp --dport 80 -j ACCEPT</li>
</ol>

<p><strong>步骤如下：</strong></p>

<ol>
<li>开启或关闭某一个端口(见上)</li>
<li>保存对防火墙的设置  <code>serivce iptables save</code></li>
<li>重启防火墙    <code>service iptables restart</code></li>
</ol>

<p>关闭所有的INPUT FORWARD（转发） OUTPUT的所有端口</p>

<pre><code>iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
</code></pre>

<p>只打开22端口</p>

<pre><code>iptables -A INPUT -p tcp –dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp –sport 22 -j ACCEPT
</code></pre>

<h2>3.参数讲解：</h2>

<p><code>–A</code> 参数就看成是添加一条规则</p>

<p><code>–p</code> 指定是什么协议，我们常用的tcp 协议，当然也有udp，例如53端口的DNS</p>

<p><code>–dport</code> 就是目标端口，当数据从外部进入服务器为目标端口</p>

<p><code>–sport</code> 数据从服务器出去，则为数据源端口使用</p>

<p><code>–j</code> 就是指定是 ACCEPT -接收 或者 DROP 不接收</p>

<p>如禁止某个IP访问：</p>

<pre><code>iptables -A INPUT -p tcp -s 192.168.1.2 -j DROP
</code></pre>

<p>–s 参数是来源（即192.168.1.2）后面拒绝就是DROP</p>

<p>删除规则：iptables -D INPUT 2   删除INPUT链编号为2的规则</p>

<h2>4参考：</h2>

<p>1.<a href="http://www.oicto.com/linux-iptables/">LINUX关闭防火墙、开放特定端口等常用操作</a></p>
