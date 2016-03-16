---
layout: page
title: Favor
subtitle: Favorites of some articles or books. 
permalink: /favor/
---
>[Economics](http://universus.cn/economics.html)  
*Economics

>[Bash Tips and Tricks](http://www.caliban.org/bash/index.shtml)  
 *Working more productively with bash 2.x/3.x*

>[Peteris Krumins' blog ](http://www.catonmat.net/)  
*About programming, hacking, software reuse, software ideas, computer security, browserling, google and technology.*

>[W3school](http://www.w3school.com.cn/)  
*领先的Web技术教程- 全部免费,在W3school你可以找到你所需要的所有的网站建设教程。*  
*从基础的 HTML 到 CSS，乃至进阶的XML、SQL、JS、PHP 和 ASP.NET。*


>[Pandoc](http://pandoc.org/index.html)
*If you need to convert files from one markup format into another, pandoc is your swiss-army knife. *

>[Ubuntu software](http://egrcc.github.io/2014/05/31/linux-software/) from egrcc  
*来自于[egrcc.github.io](http://egrcc.github.io/)的软件列表，最近转到Ubuntu了，这个应该很有帮助，软件我还没有装，收藏吧.*

>[NodeJS school](http://nodeschool.io/zh-cn/)  
*用cur作公司的网站，发现javascript的代码只能显示不能解析，看来这个需要看看*

>[Beautiful soup 4.2.0](http://www.crummy.com/software/BeautifulSoup/bs4/doc/index.zh.html)  
*这篇文档介绍了BeautifulSoup4中所有主要特性,并且有小例子.让我来向你展示它适合做什么,如何工作,怎样使用,如何达到你想要的效果,和处理异常情况*

>[Requests: HTTP for Humans](http://cn.python-requests.org/zh_CN/latest/#)   
*Requests 支持 HTTP 连接保持和连接池，支持使用 cookie 保持会话，支持文件上传，支持自动确定响应内容的编码，支持国际化的 URL 和 POST 数据自动编码。现代、国际化、人性化。*

>[lxml解析HTML](http://www.cnblogs.com/descusr/archive/2012/06/20/2557075.html) 
*一篇比较通俗易懂的lxml博客，获益匪浅。*

>[lxml官方网站](http://lxml.de/index.html)  
*放着，最近在整它！！！

>[lxml W3School](http://www.w3school.com.cn/xpath/)  
*lxml W3C 教程

>[Xpath W3School](https://www.w3.org/TR/xpath/)  
*W3C Xpath book.  

>[Xpath 2](http://www.zvon.org/comp/m/xpath.html)
*Another xpath book

>[Scrapy example](http://blog.csdn.net/xiantian7/article/details/21518547)
*Scrapy的教程很多，这一个系列的只看了一半，关于Item Loader和FeedExporters 都还没去了解。

>[openpyxl](https://openpyxl.readthedocs.org/en/2.3.3/optimized.html)
*This is online docuemnt for openpyxl which can manipulate Micro Excell 2010

http://playbear.github.io/

http://www.favicon.cc/

http://www.pbccrc.org.cn/ 

http://www.kryogenix.org/code/browser/sorttable/

http://realnicky.iteye.com/
*这个杭州哥们的博客有意思

http://www.pic21.com/bizhi/a/541_1.htm  
*Clock image*



{% for links in site.data.links%}
<blockquote>
  <p><a href="{{links.link}}">"{{links.title}}"</a><br />
 <em>"{{links.subtitle}}"</em></p>
</blockquote>
 {% endfor %}

