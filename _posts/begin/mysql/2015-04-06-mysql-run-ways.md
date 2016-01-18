---
layout: post
title: "mysql服务器的不同平台不同启动方式"
description: "mysql服务器的不同平台不同启动方式"
category: "Mysql"
tags: [Mysql]
---

<h3>1.windows</h3>

<pre><code>net stop mysql
net start mysql
</code></pre>

<h3>2.linux</h3>

<h4>(1).启动方式</h4>

<p>1.使用<code>service</code>启动：<code>service mysqld start</code></p>

<p>2.<code>mysqld</code>脚本启动：<code>/etc/init.d/mysqld start</code></p>

<p>3.<code>safe_mysqld</code>启动：<code>safe_mysqld&amp;</code></p>

<h4>(2).停止方式</h4>

<p>上面两个都是加<code>stop</code> 参数，对于mysqladmin则<code>mysqladmin shutdown</code></p>

<h4>(3).重启</h4>

<p>后面加<code>restart</code> 参数即可</p>

<blockquote>
  <p>注意：</p>
  
  <p>(1).mysqld是用来启动mysql数据库的命令，而mysql是打开并执行sql语句的命令，它们都在mysql安装文件夹bin目录下</p>
</blockquote>

<h3>3.Mac</h3>

<pre><code>启动Mysql服务
sudo /Library/StartupItems/MySQLCOM/MySQLCOM start

停止Mysql服务
sudo /Library/StartupItems/MySQLCOM/MySQLCOM stop

重启Mysql服务
sudo /Library/StartupItems/MySQLCOM/MySQLCOM restart
</code></pre>

<p><strong>理解/etc/init.d/</strong>:</p>

<blockquote>
  <p>init.d目录包含许多系统各种服务的启动和停止脚本,一般要有root权限或sudo权限，每个脚本都会以<code>/etc/init.d/scriptFile command</code>的形式执行，command往往是<code>stop</code>,    <code>restart</code>,<code>start</code>,<code>reload</code>,<code>force-reload</code>等，如启动mysql，<code>/etc/init.d/mysql restart</code></p>
</blockquote>

<h2>参考：</h2>

<p><a href="http://www.itry.me/?p=10">在 Mac OS X (lion)中启动|停止|重启 mysql</a></p>
