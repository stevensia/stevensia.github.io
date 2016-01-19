---
layout: post
title:  Learning Python BeautifulSoup
date:   2015-12-11 07:18:03
categories: Python
tags: python
excerpt: 
---

#### Soup examples:

    for i in soup.find_all('body'):print (i)  
    for i in soup.find_all(re.compile('^body')):print (i)  
    for i in soup.find_all(re.compile('^t')):print (i.name)  
    for i in soup.find_all(["title","body"]):print (i.name)  

>基本上来说， BeautifulSoup是一个用来解析或者转换html格式文件的python库，功能十分强大，在学习过程中能了解到html的一些基础知识，上面的几个例子是find_all方法的 一些示例，按照tag，正则打印出搜索到的内容，十分有用。  
[文档](http://www.crummy.com/software/BeautifulSoup/bs4/doc/index.zh.html)很快的过了一遍，大概的了解一下结构， 只是暂时还不能用到特别多的功能，暂且放下，等后面需要解析文档或者转换文档的时候再回来仔细看一遍，继续补充这篇文档。  
接下来要研究Requests 。  

Another CN BS4 guide is [here](http://cuiqingcai.com/1319.html)

Come on!!!

