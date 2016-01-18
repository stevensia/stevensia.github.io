---
layout: post
title: "域名带端口的解决办法"
description: "域名带端口的解决办法"
category: "windows"
tags: [windows服务器]
---

<p>比如原来访问xxx.cn:888，而改成xxx.cn也可以访问。上网查找了一些资料，看到一种解决办法，正好服务器上也安装了apache和IIS两种软件。这台服务器上apache监听的是80端口，网站是放在IIS上面运行占用888端口。</p>

<p>将apache作为IIS的代理</p>

<p>在<code>httpd.conf</code>里面，取消下面四行的注释：</p>

<pre><code>LoadModule proxy_module modules/mod_proxy.so 
LoadModule proxy_connect_module modules/mod_proxy_connect.so 
LoadModule proxy_http_module modules/mod_proxy_http.so 
LoadModule proxy_ftp_module modules/mod_proxy_ftp.so
</code></pre>

<p>然后建立一个虚拟主机，将该域名的所有访问转向81端口。</p>

<pre><code>&lt;VirtualHost *:80&gt;
  ServerName xxx.cn
  ProxyPass / http://localhost:888/
  ProxyPassReverse / http://localhost:888/
  SetEnv force-proxy-request-1.0 1
  SetEnv proxy-nokeepalive 1
&lt;/virtualHost&gt;
</code></pre>

<p>重启apache服务,OK.</p>
