---
layout: post
title: "ubuntu 常见错误"
description: "ubuntu 常见错误"
category: "linux"
tags: [linux服务器]
---

<h2>1.apt-get install &lt;'Unable to locate package'></h2>

<p>The error info like this:</p>

<pre><code>E: Unable to locate package mysql-server
E: Unable to locate package mysql-client
</code></pre>

<p>当用apt-get更新软件包时常出现错误提示Unable to locate package update, 尤其是在ubuntu server上,解决方法是：</p>

<pre><code>    先更新apt-get
    #sudo apt-get update

    继续更新：
    #sudo apt-get upgrade
</code></pre>

<p><a href="http://jingyan.baidu.com/article/1876c852aa8c8c890b1376aa.html"><strong>ubuntu更新源</strong></a></p>

<h2>2.E: Package 'fcitx' has no installation candidate</h2>

<p>candidate: 候选人</p>

<p>解决方法如下：</p>

<pre><code>apt-get update
apt-get upgrade
apt-get install &lt;packagename&gt;
</code></pre>
