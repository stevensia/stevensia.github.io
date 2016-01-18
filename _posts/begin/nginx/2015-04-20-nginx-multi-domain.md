---
layout: post
title: "nginx多域名处理"
description: "nginx多域名处理"
category: "Nginx"
tags: [Nginx]
---

<p>由于网站需要接入备案</p>

<blockquote>
  <p>为什么要做接入？ 按照工信部要求，如果您的域名首先在接入商A处提交备案并获取备案号，在此之后，您将域名指向的IP由接入商A转换至接入商B，那么您需要使用接入商B的备案系统提交接入的备案申请。</p>
  
  <p>特殊的，您使用顶级域名abc.com指向接入商A的主机并获取备案号，进而您再使用二级域名xyz.abc.com解析至接入商B的主机，那么也须使用B的备案系统提交接入申请。</p>
  
  <p>如果您是接入的用户，建议您尽快办理接入申请，否则将无法使用阿里云服务器。</p>
</blockquote>

<p>这样就导致了通过域名访问网站提醒备案的情况，想到的办法就是nginx多域名，转向到IP，而不是直接通过域名访问。</p>

<h2>Nginx多域名问题</h2>

<p>多个域名对应同一端口，如80端口。可用添加多个域名的规则。</p>

<pre><code>    server { 
    listen 80; 
    server_name www.a.com; #绑定域名 
    index index.htm index.html index.php; #默认文件 
    root /home/www/a.com; #网站根目录 
    include location.conf; #调用其他规则，也可去除 
} 

server { 
    listen 80; 
    server_name www.b.com; #绑定域名 
    index index.htm index.html index.php; #默认文件 
    root /home/www/b.com; #网站根目录 
    include location.conf; #调用其他规则，也可去除 
} 

#如果不带www的域名要加301跳转，那也是和绑定域名一样 
server { 
    listen 80; 
    server_name a.com; 
    rewrite ^/(.*) http://123.58.11.34/$1 permanent; 
} 

#同时也可以添加404 [c] 
server { 
    listen 80; 
    server_name www.a.com; #绑定域名 
    index index.htm index.html index.php; #默认文件 
    root /home/www/a.com; #网站根目录 
    include location.conf; #调用其他规则，也可去除 
    error_page 404 /404.html; 
}
</code></pre>

<p>参考:<a href="http://blog.itblood.com/nginx-same-ip-multi-domain-configuration.html">nginx同一iP多域名配置方法</a></p>
