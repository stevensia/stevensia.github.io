---
layout: post
title: "Mac 安装mysql 提示mysql: command not found的解决方案"
description: "Mac 安装mysql 提示mysql: command not found的解决方案"
category: "Mysql"
tags: [Mysql]
---

<p>mac下配置mysql还是没linux下方便，对于配置这块，参考<a href="http://2484055.blog.51cto.com/2474055/1335382">MySQL for Mac 安装和基本操作(包含后期的环境变量设置)</a></p>

<p>当重启后，突然在终端无法使用mysql，如<code>mysql -uroot -p</code> 则会提示‘"mysql: command not found"’的错误，这是因为没有写入mac的环境变量中，尝试这样执行：</p>

<pre><code>/usr/local/mysql/bin/mysql # 则会启动mysql
</code></pre>

<p>解决办法就是写入环境变量中，有如下方法：</p>

<pre><code>#方式1
#sh即bash ,若用－c参数，则bash从字符串中读入命令
sudo sh -c 'echo /usr/local/mysql/bin &gt; /etc/paths.d/mysql'
#方式2 (推荐)
export PATH="/usr/local/mysql/bin:$PATH"
</code></pre>

<p>in .bashrc or .bash_profile file (cd ~/.bash_profile)</p>
