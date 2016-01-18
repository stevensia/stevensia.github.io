---
layout: post
title: "How can I install the Python library 'gevent' on Mac OS X"
description: "python gevent"
category: "python"
tags: [python]
---

在我的Mac OS X下，pip安装`gevent`一直失败：

	pip install gevent
	...
	error: command 'cc' failed with exit status 1

google了一下，说可在下载安装包直接安装，如：

	tar -zxvf gevent-1.0.2.tar.gz
	cd gevent-1.0.2 
	sudo python setup.py install

很不幸，还是失败：

	libev/ev.c:1029:42: error: '_Noreturn' keyword must precede function declarator
  	ecb_inline void ecb_unreachable (void) ecb_noreturn;
                                         ^~~~~~~~~~~~

这时你应该尝试用 [gevent==1.1b5](https://pypi.python.org/pypi/gevent/1.1b5)

![](http://beginman.qiniudn.com/QQ201510131.png)

