---
layout: post
title: "django缓存系统之web缓存的理解"
description: "django缓存系统之web缓存的理解"
category: "django"
tags: [django]
---

<h1>一.web缓存概念</h1>

<p>web缓存就是将静态资源(page,css,js,datas)等存储在特定区域作为<strong>副本</strong>,当相同请求时通过后台程序策略(如是否需要访问副本,是否到来过期时间等)来访问.</p>

<p><img src="http://www.richwan.com/seo/wp-content/uploads/2012/07/web-cache-architecture.jpg" alt="" /></p>

<p>图片来源:http://www.richwan.com/seo/seo-definitions/web-cache/</p>

<!--more-->

<h1>二.web缓存种类</h1>

<h2>1,数据库数据缓存</h2>

<p>Web应用，特别是SNS类型的应用，往往关系比较复杂，数据库表繁多，如果频繁进行数据库查询，很容易导致数据库不堪重荷。为了提供查询的性能，会将查询后的数据放到内存中进行缓存，下次查询时，直接从内存缓存直接返回，提供响应效率。比如常用的缓存方案有memcached,Redis等。</p>

<h2>2.服务器端缓存</h2>

<h3>2.1代理服务器缓存</h3>

<p>代理服务器是浏览器和源服务器之间的中间服务器，浏览器先向这个中间服务器发起Web请求，经过处理后（比如权限验证，缓存匹配等），再将请求转发到源服务器。代理服务器缓存的运作原理跟浏览器的运作原理差不多，只是规模更大。可以把它理解为一个共享缓存，不只为一个用户服务，一般为大量用户提供服务，因此在减少相应时间和带宽使用方面很有效，同一个副本会被重用多次。常见代理服务器缓存解决方案有Squid等，这里不再详述。</p>

<h3>2.2 CDN缓存</h3>

<p>CDN（Content delivery networks）缓存，也叫网关缓存、反向代理缓存。CDN缓存一般是由网站管理员自己部署，为了让他们的网站更容易扩展并获得更好的性能。浏览器先向CDN网关发起Web请求，网关服务器后面对应着一台或多台负载均衡源服务器，会根据它们的负载请求，动态将请求转发到合适的源服务器上。虽然这种架构负载均衡源服务器之间的缓存没法共享，但却拥有更好的处扩展性。从浏览器角度来看，整个CDN就是一个源服务器，从这个层面来说，本文讨论浏览器和服务器之间的缓存机制，在这种架构下同样适用。</p>

<h2>3.浏览器端缓存</h2>

<p>浏览器缓存根据一套与服务器约定的规则进行工作，在同一个会话过程中会检查一次并确定缓存的副本足够新。如果你浏览过程中，比如前进或后退，访问到同一个图片，这些图片可以从浏览器缓存中调出而即时显现。</p>

<h2>4.Web应用层缓存</h2>

<pre><code>应用层缓存指的是从代码层面上，通过代码逻辑和缓存策略，实现对数据，页面，图片等资源的缓存，可以根据实际情况选择将数据存在文件系统或者内存中，减少数据库查询或者读写瓶颈，提高响应效率。
</code></pre>

<h1>三.浏览器缓存策略</h1>

<p><code>Fiddler</code>能够跟踪缓存.Web服务器通过2种方式来判断浏览器缓存是否是最新的。</p>

<p>第一种， 浏览器把缓存文件的最后修改时间通过 header ”If-Modified-Since“来告诉Web服务器。</p>

<p>第二种， 浏览器把缓存文件的ETag, 通过header "If-None-Match", 来告诉Web服务器。</p>

<p><code>Ctrl+F5</code>进行强制刷新的时候，只是所有的缓存机制都将失效.更多内容参考:<a href="http://www.alloyteam.com/2012/03/web-cache-2-browser-cache/">这里</a></p>

<p><img src="http://pic002.cnblogs.com/images/2012/263119/2012111910592554.png" alt="" /></p>

<p>图片来源:http://www.cnblogs.com/TankXiao/archive/2012/11/28/2793365.html</p>

<h1>参考资料</h1>

<p><a href="http://www.alloyteam.com/2012/03/web-cache-1-web-cache-overview/">1.Web缓存机制系列</a></p>

<p><a href="http://rdc.taobao.org/?p=1481">2.应用系统数据缓存设计</a></p>

<p><a href="http://www.cnblogs.com/TankXiao/archive/2012/11/28/2793365.html">3.HTTP协议 (四) 缓存</a></p>
