---
layout: post
title: "linux shell 基础总结"
description: "linux shell 基础总结"
category: "shell"
tags: [shell]
---

# 总结下

## 一.shell内建命令
**就是bash自身提供的命令，而不是某个可执行文件**

	➜  ~  which cd  
	cd: shell built-in command
	➜  ~  which more
	/usr/bin/more

**内建命令比外部命令执行的更快，执行外部命令时不但会触发磁盘I/O,还需要fork出一个单独的进程来执行，执行完毕后在退出。而执行内建命令相当于调用当前shell进程中的一个函数。**

可以通过`type`判断是否是内建命令：

	➜  ~  type cd
	cd is a shell builtin
	➜  ~  type more
	more is /usr/bin/more

## source 和点号

与点号类似，`source`命令执行脚本，同时返回脚本中最后一个命令的返回状态

	source myshell.sh

