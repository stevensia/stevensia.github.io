---
layout: post
title: "nginx 常见问题汇总"
description: "nginx 常见问题汇总"
category: "Nginx"
tags: [Nginx]
---

<p>nginx常见问题汇总：</p>

<blockquote>
  <p>1.<a href="http://blog.51yip.com/apachenginx/1512.html">nginx 403 forbidden</a></p>
</blockquote>

<ol>
<li><p>此类问题，大多数是权限问题，nginx的启动用户（默认是nginx）对项目所在目录没有读的权限；可以把权限改大些，或者启动用户改成目录的所属用户或root。（要重启nginx服务）</p></li>
<li><p>还有一点就是<code>server</code>项下<code>index</code>缺失，导致无法找到该文件。</p></li>
<li><p><code>location ...</code>下目录保证可读</p></li>
</ol>

<!--more-->

<blockquote>
  <p>2.nginx 414 Request-URI Too Large</p>
</blockquote>

<p><strong>当http 的URI太长或者request header过大时会报414 Request URI too large或400 bad request错误。</strong></p>

<p>当请求头过大时，超过large_client_header_buffer时才会出现这样的错误。</p>

<p>客户端请求头缓冲区大小，如果请求头总长度大于小于128k，则使用此缓冲区，</p>

<pre><code>client_header_buffer_size 128k; # 设置的缓存区
</code></pre>

<p>请求头总长度大于128k时使用large_client_header_buffers</p>

<pre><code>large_client_header_buffers 4 128k; # 指令参数4为个数，128k为大小，默认是8k。申请4个128k。
</code></pre>

<p>可能原因</p>

<ol>
<li><p>cookie中写入的值太大造成的，因为header中的其他参数的size一般比较固定，只有cookie可能被写入较大的数据</p></li>
<li><p>请求参数太长</p></li>
</ol>

<p><strong>决办法：这时可以调大上述两个值。</strong></p>

<pre><code>client_header_buffer_size 512k;
large_client_header_buffers 4 512k;
</code></pre>
