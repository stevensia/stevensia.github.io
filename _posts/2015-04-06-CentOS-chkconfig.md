---
layout: post
title: "CentOS 开机启动设置与chkconfig命令学习"
description: "CentOS 开机启动设置与chkconfig命令学习"
category: "linux"
tags: [linux基础]
---

<h2>一.关于Linux自启动过程</h2>

<p>在读阮一峰<a href="http://www.ruanyifeng.com/blog/2013/08/linux_boot_process.html">《Linux 的启动流程》</a>这篇文章后，可总结如下：</p>

<p><img src="http://image.beekka.com/blog/201308/bg2013081701.png" alt="" /></p>

<p>进入操作系统后的执行流程：</p>

<ol>
<li>首先读入 /boot 目录下的内核文件</li>
<li>启动初始化进程(init),是开始运行第一个程序 /sbin/init，它的进程编号（pid）就是1。其他所有进程都从它衍生，都是它的子进程。</li>
<li>确定运行级别。Linux允许为不同的场合，分配不同的开机启动程序。</li>
<li>加载开机启动程序。就是七个 /etc/rcN.d 目录里列出的程序，都设为链接文件，指向另外一个目录 /etc/init.d ，真正的启动脚本都统一放在这个目录中。init进程逐一加载开机启动程序，其实就是运行这个目录里的启动脚本。</li>
<li>登录</li>
</ol>

<p>那么整个流程如下图：(图片来源：http://image.beekka.com/blog/201308/bg2013081708.png)</p>

<p><img src="http://image.beekka.com/blog/201308/bg2013081708.png" alt="" /></p>

<!--more-->

<p>在第3，4步骤中我们知道Linux预置七种运行级别（0-6）。一般来说，0是关机，1是单用户模式（也就是维护模式），6是重启。运行级别2-5，各个发行版不太一样，对于Debian来说，都是同样的多用户模式（也就是正常模式）。init进程首先读取文件 /etc/inittab，它是运行级别的设置文件,如显示<code>id:3:initdefault:</code>表示系统启动时的运行级别为3（可手动修改）</p>

<pre><code>/etc/rc.d/rc0.d  
/etc/rc.d/rc1.d  
/etc/rc.d/rc2.d  
/etc/rc.d/rc3.d  
/etc/rc.d/rc4.d  
/etc/rc.d/rc5.d  
/etc/rc.d/rc6.d  
/etc/rc.d/init.d

#上面目录名中的"rc"，表示run command（运行程序），最后的d表示directory（目录） 

# Default runlevel. The runlevels used are:
#   0 - halt (Do NOT set initdefault to this)
#   1 - Single user mode
#   2 - Multiuser, without NFS (The same as 3, if you do not have networking)
#   3 - Full multiuser mode
#   4 - unused
#   5 - X11
#   6 - reboot (Do NOT set initdefault to this)
</code></pre>

<p>其中/etc/init.d 是系统服务的集合地，如果我们想启动或停止某一个不太熟悉的服务，可以在/etc/init.d文件中查询。</p>

<pre><code>sudo /etc/init.d/apache2 restart
</code></pre>

<p><strong>/etc/init.d 这个目录名最后一个字母d，是directory的意思，表示这是一个目录，用来与程序 /etc/init 区分。</strong></p>

<h2>二.CentOS设置程序开机启动的方法：</h2>

<p><strong>1.启动命令添加到/etc/rc.d/rc.local 文件中, 如：</strong></p>

<pre><code>vim /etc/rc.d/rc.local
#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.

touch /var/lock/subsys/local

#后面添加要开机启动的程序命令如httpd
/usr/local/apache/bin/apachectl start
</code></pre>

<p><strong>2.把写好的启动脚本添加到目录/etc/rc.d/init.d/，然后使用命令chkconfig设置开机启动。</strong></p>

<pre><code>#把httpd的脚本写好后放进/etc/rc.d/init.d/目录
chkconfig --add httpd    #增加所指定的系统服务
chkconfig httpd on
</code></pre>

<h2>三.chkconfig命令</h2>

<p><code>chkconfig</code>:更新(启动或停止)和查询运行级别(runlevel)信息对于系统服务.</p>

<p>语法如下：</p>

<p><code>chkconfig --list [name]</code>:显示所有运行级系统服务的运行状态信息（on或off）。如果指定了name，那么只显示指定的服务在不同运行级的状态。</p>

<p><code>chkconfig --add name</code>:增加一项新的服务。chkconfig确保每个运行级有一项启动(S)或者杀死(K)入口。如有缺少，则会从缺省的init脚本自动建立。</p>

<p><code>chkconfig --del name</code>：删除服务，并把相关符号连接从/etc/rc[0-6].d删除</p>

<p><code>chkconfig [--level levels] name &lt;on|off|reset&gt;</code>:指定读系统服务要在哪一个执行等级中开启或关毕。</p>

<pre><code>chkconfig --level httpd 2345 on        #设置httpd在运行级别为2、3、4、5的情况下都是on（开启）的状态
chkconfig --level 35 mysqld on        #设定mysqld在等级3和5为开机运行服务，--level 35表示操作只在等级3和5执行，on表示启动，off表示关闭
chkconfig mysqld on        #设定mysqld在各等级为on，“各等级”包括2、3、4、5等级
</code></pre>

<p><code>chkconfig [--level levels] name</code> :</p>

<h2>四.参考</h2>

<p><a href="http://www.ruanyifeng.com/blog/2013/08/linux_boot_process.html">1. 阮一峰:Linux 的启动流程</a></p>

<p><a href="http://www.cnblogs.com/panjun-donet/archive/2010/08/10/1796873.html">2.Linux下chkconfig命令详解</a></p>
