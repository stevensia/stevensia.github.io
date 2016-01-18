---
layout: post
title: "LAMP+phpAdmin 安装配置"
description: "LAMP+phpAdmin 安装配置"
category: "linux"
tags: [linux服务器]
---

<h2>1.LAMP+phpAdmin 安装配置</h2>

<h3>(1).Apache Web 服务器</h3>

<pre><code>sudo apt-get install apache2  apache2-doc
</code></pre>

<p>检测是否安装成功：</p>

<pre><code>curl 127.0.0.1
#或 curl http://localhost
</code></pre>

<p><strong>注意：ubuntu下安装了apache和nginx，都占用80端口，修改apache的默认端口防止2个程序端口冲突</strong></p>

<!--more-->

<p>修改Apache默认端口：</p>

<blockquote>
  <p><strong>1.修改 <code>/etc/apache2/ports.conf</code> 将</strong></p>
  
  <p>NameVirtualHost *:80</p>
  
  <p>Listen 80</p>
  
  <p>改为自己需要的端口</p>
  
  <p>NameVirtualHost *:8001</p>
  
  <p>Listen 8001</p>
  
  <p><strong>2.修改/etc/apache2/sites-enabled/000-default 将第一行的</strong></p>
  
  <p><VirtualHost *:80></p>
  
  <p>改为自己需要的端口</p>
  
  <p><VirtualHost *:8001></p>
  
  <p><strong>3.修改 /etc/init.d/apache2/httpd.conf 添加</strong></p>
  
  <p>ServerName localhost</p>
  
  <p>重启apache服务</p>
  
  <p>/etc/init.d/apache2 restart  或者 service apache2 restart</p>
  
  <p>然后访问： curl 127.0.0.1:8001 就ok了， 如果部署在服务器上，则本地浏览器打开： webServiceIP:8001 就会出现下面界面：</p>
</blockquote>

<p>It works!</p>

<p>This is the default web page for this server.</p>

<p>The web server software is running but no content has been added, yet.</p>

<h2>2.PHP5和Apache的php模块</h2>

<pre><code>sudo apt-get install php5 libapache2-mod-php5 
</code></pre>

<p>重启Apache服务使php模块生效</p>

<pre><code>sudo service apache2 restart 
</code></pre>

<p>apache启动目录是/var/www/ 所以要测试php5是否安装成功，先编辑一个测试文件在该目录下，</p>

<pre><code>sudo vim /var/www/phpinfo.php
#php
&lt;?php  
   phpinfo();  
?&gt;  
</code></pre>

<p>保存后，在浏览器中打开：http://localhost/phpinfo.php，（服务器部署可在本地打开 http://服务器ip:8001/phpinfo.php  即可，注意这里端口8001是自己修改过的而非默认的80端口）</p>

<p><img src="http://images.cnblogs.com/cnblogs_com/BeginMan/486940/o_%e5%b1%8f%e5%b9%95%e5%bf%ab%e7%85%a7%202014-11-16%20%e4%b8%8a%e5%8d%8811.24.02.png" alt="" /></p>

<h2>3.安装Mysql</h2>

<pre><code>sudo apt-get install mysql-server mysql-client
</code></pre>

<p>然后设置mysql 密码就行了</p>

<h2>4.安装phpmyadmin</h2>

<pre><code>sudo apt-get install phpmyadmin
</code></pre>

<p>安装中选择apache2 就行，然后再设置密码就ok了，<strong>注意：phpmyadmin安装后并不在apache默认路径下，此时要建立个软链接</strong></p>

<pre><code>sudo ln -s /usr/share/phpmyadmin /var/www
</code></pre>

<p>重启Apache服务器，然后打开http://localhost/phpmyadmin 就出现了登陆界面，如果出现了mcrypt错误！终端执行：sudo php5enmod mcrypt，然后重启apache，重新登陆phpmyadmin就行了。</p>

<h2>参考</h2>

<p><a href="http://blog.csdn.net/tecn14/article/details/27515241">1.Ubuntu 14.04 配置 LAMP+phpMyAdmin PHP开发环境！</a></p>

<p><a href="http://www.oecp.cn/hi/wlo_o/blog/1168525">2.ubuntu下更改apache的默认端口</a></p>
