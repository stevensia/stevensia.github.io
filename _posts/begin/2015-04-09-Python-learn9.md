---
layout: post
title: "Python多线程编程(1)：基础知识"
description: "Python多线程编程(1)：基础"
category: "Python"
tags: [Python]
---

# 一.多线程(multithreaded, MT)
应用场景:Task本质异步，运行顺序是不确定性，随机性，不可预测，每个Task流都有一个要完成的目标，这些子任务可能会计算出一个中间结果，用于合并最后的结果。

# 二.理解线程与进程
## 2.1 进程(process)

进程是计算机中已运行程序的实体，是程序的基本执行实体，是线程的容器。它有两种运行方式：同步（循序）和异步（平行).

>每个进程都有自己的地址空间，内存，数据栈等数据，so,能使用进程间通讯(interprocess communication, IPC)而不能直接共享信息。

## 2.2 进程与程序的关系
程序本身只是指令、数据及其组织形式的描述，进程才是程序（那些指令和数据）的真正运行实例。若干进程有可能与同一个程序相关系，计算机以进程的形式加载多个程序到存储器中。

以下参考可能会更加清晰了解程序与进程的关系：

>程序只是一个普通文件，是一个机器代码指令和数据的集合，这些指令和数据存储在磁盘上的一个可执行映象（Executable Image）中，所以，程序是一个静态的实体。这里，对可执行映象做进一步解释，可执行映象就是一个可执行文件的内容，例如，你编写了一个C源程序，最终这个源程序要经过编译、连接成为一个可执行文件后才能运行。源程序中你要定义许多变量，在可执行文件中，这些变量就组成了数据段的一部分；源程序中的许多语句，例如“ i++; for(i=0; i&lt;10; i++);”等，在可执行文件中，它们对应着许多不同的机器代码指令，这些机器代码指令经CPU执行，就完成了你所期望的工作。可以这么说：程序代表你期望完成某工作的计划和步骤，它还浮在纸面上，等待具体实现。而具体的实现过程就是由进程来完成的，进程可以认为是运行中的程序，它除了包含程序中的所有内容外，还包含一些额外的数据。程序和进程的组成如图所示。


![](http://oss.org.cn/kernel-book/ch04/4.1.files/image002.gif)

## 2.3 线程
线程有时称为**轻量级进程**跟进程相似，**不同的是，所有的线程运行在同一进程中，共享运行环境。***

**是操作系统能够进行运算调度的最小单位**。它被包含在进程之中，是进程中的实际运作单位。一条线程指的是进程中一个单一顺序的控制流，一个进程中可以并发多个线程，每条线程并行执行不同的任务。

>线程一般是并发执行的，正是由于这种并行和数据共享机制使得多任务更容易合作，**在实际的单CPU系统中，真正的并发是不可能的，每个线程会被安排每次只运行一会儿，然后就把CPU让出来让其他线程去执行。**

线程有四种状态：

- 产生（spawn)
- 中断（block)
- 非中断（unblock)
- 退出（finish)

![](http://ww2.sinaimg.cn/mw690/aa213e02jw1ew4833e3ldj20e004yt95.jpg) 

图片来源：http://python.jobbole.com/82105/

线程共享是很easy，但是也存在多个线程共同访问同一数据的问题，由于访问的顺序不一致，可能导致结果也不一致，这叫**竞态条件(race condition)**

## 2.4多线程

线程是程序中一个**单一的顺序控制流程**.在单个程序中同时运行多个线程完成不同的工作,称为多线程。

为什么要引入多线程，目的就是为了**改进性能和并发,对于某些应用程序,可以提高性能和并发性通过使用多线程。**

三. Python多线程概述

这节重点掌握：

- 全局解释器锁(GIL)的概念
- 退出进程的动作
- 为什么推荐使用threading

首先要清楚python解释器和虚拟机:

- python解释器, 将源代码转换为字节码然后执行的过程，这里的解释执行是相对于编译执行而言。更多内容参考<a href="http://www.wangyuxiong.com/archives/51258"><strong>Python解释执行原理</strong></a></p>
- python虚拟机, Python代码执行是由python虚拟机控制，在python虚拟机中**同时只有一个线程执行，相当于单CPU运行多个进程，但是任意时刻只用一个进程在CPU中运行。**

那我们常听到的全局解释器锁(GIL)是个什么东西呢？

## 3.1 python全局解释器锁(GIL)

对python虚拟机访问是通过python全局解释器锁(global interpreter lock , GIL)控制，实现相当于一把锁，在进程与线程概念中，存在着共享内存，其他线程必须等它结束，才能使用这一块内存。GIL就是锁住然后打开的不断循环的过程，用以防止多个线程同时读写某一块内存区域。

![](http://deliveryimages.acm.org/10.1145/960000/959339/7124f1.png)

在多线程环境中，Python虚拟机按如下方式运行：

1. 设置GIL
2. 切换到一个线程去执行
3. 运行：
    - 指定数量的字节码的指令，或
    - 线程主动让出控制(可以调用time.sleep(0))
4. 把线程设置为睡眠状态
5. 解锁GIL
6. 再次重复以上步骤

我们将会在下面的系列学习**GIL的局限性**

## 3.2 线程的退出
目前为止我们可以以如下方式让线程退出：

1. threading的join() （五颗星☆☆☆☆☆)
2. thread.exit() （四颗星☆☆☆☆）
3. sys.exit() (三颗星☆☆☆)
4. 抛出SystemExit异常(两颗星 ☆☆)
5. kill命令(一颗星☆)
6. 关闭电脑。。（没有星）

如上的推荐顺序一定要注意了，因为**当主线程退出后，其他子线程会被清除掉，一个负责任的主线程应该了解每个线程在做什么，怎么做，以及做得如何(结果)，然后再汇总小弟们的成果组合成一个有意义的最后结果。**

## 3.3 为什么推荐使用threading
原因如下：

- threading更加高级，更加安全
- thread同步原语很少
- thread对线程的控制不太好，相反threading可保证子线程都退出后进程才退出（江湖大哥，让小弟先走）
- thread不支持守护线程

参考：

《Python核心编程》

更新于：2015/11/29