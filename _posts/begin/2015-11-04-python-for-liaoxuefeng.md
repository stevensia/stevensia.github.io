---
layout: post
title: "看廖雪峰python教程小结"
description: "Python总结"
category: "python"
tags: [python]
---
早听闻廖雪峰大名，今天看下他的[python教程](http://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000)启发了不少，虽然自己从2013年就开始接触python了，但是很多盲点能够在廖雪峰博客中悉知，所以特此总结了下。

# 一.Python解释器
当处理`.py`文件需要解释器，有如下解释器：

- CPython: C语言编写，运行命令行时就启动了CPython解释器
- IPython：基于CPython之上的一个交互式解释器，功能一样但是如果使用命令行则更加方便，CPython用`>>>`作为提示符，而IPython用`In [序号]:`作为提示符。
- PyPy: PyPy采用JIT技术，对Python代码进行动态编译以提高执行速度
- Jython：运行在java平台，直接把Python代码编译成Java字节码执行
- IronPython：同Jython运行在.net平台

# 二.字符编码


