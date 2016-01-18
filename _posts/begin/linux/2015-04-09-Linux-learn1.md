---
layout: post
title: "Linux命令流程，重定向与管道"
description: "Linux命令流程，重定向与管道"
category: "linux"
tags: [linux基础]
---

<h2>一.概述</h2>

<p>在学习linux重定向与管道的时候，事先要明了linux命令的执行过程。这里有以下几个概念。</p>

<h3>1.linux IO 与文件描述符(File Descriptor)</h3>

<p><img src="http://img.ddvip.com/2013_0912/16291378923988.jpg" alt="" /></p>

<blockquote>
  <p>linux文件描述符：可以理解为linux跟踪打开文件，而分配的一个数字，这个数字有点类似c语言操作文件时候的句柄，通过句柄就可以实现文件的读写操作。 用户可以自定义文件描述符范围是：3-num,这个最大数字，跟用户的：ulimit –n 定义数字有关系，不能超过最大值。</p>
  
  <p>linux启动后，会默认打开3个文件描述符，分别是：标准输入standard input 0,正确输出standard output 1,错误输出：error output 2</p>
  
  <p>以后打开文件后。新增文件绑定描述符 可以依次增加。 一条shell命令执行，都会继承父进程的文件描述符。因此，所有运行的shell命令，都会有默认3个文件描述符。</p>
</blockquote>

<!--more-->

<h3>2.命令运行流程</h3>

<p><img src="http://img.blog.csdn.net/20140329135415640?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvaGp4NTIwMA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" alt="" /></p>

<p><a href="http://blog.csdn.net/hjx5200/article/details/22487683">图文参考： Linux命令运行的基本过程</a></p>

<blockquote>
  <p>上图展示了ls命令的执行过程，下面进行简单分析：</p>
  
  <p>1、shell不断询问是否有键盘输入，用户以enter结束键盘输入后，shell程序以空格为分隔符，得到"ls"，"-l"，"*.c"，三个字符串。</p>
  
  <p>2、shell发现第三个字符串包含"*"通配符，就会在当前路径(或指定路径)下搜索满足这个通配符的文件。有bar.c和foo.c两个文件，然后展开成{"ls"，"-l"，"bar.c"，"foo.c"}四个字符串，并保存在argv这个二维字符数组中，并赋值argc为4。</p>
  
  <p>3、shell然后搜索PATH这个全局变量保存的路径，寻找一个叫"ls"的命令。如果存在，则fork()一个子进程，调用exec()加载运行ls命令。ls的main(int argc, string ** argv)函数的参数就是从shell那里得来的。若不存在就会提示用户"command not found"。</p>
  
  <p>4、ls程序执行后，会分析argc和argv，"-l"表示这是一个选项开关，表明用户想得到文件的详细信息，并把这个开关量保存，以便最后输出的时候选择信息的格式。</p>
  
  <p>5、ls执行完既定的步骤后，退出并返回退出码，若成功则返回0，否则根据错误的不同返回不同的非零数字。</p>
  
  <p>6、shell在得到成功退出码后，继续等待用户输入。如此不断的循环。</p>
</blockquote>

<h2>二.重定向与管道</h2>

<p>以下参考讲的十分好：</p>

<p><a href="http://www.cnblogs.com/chengmo/archive/2010/10/20/1855805.html">1.<strong>linux shell数据重定向（输入重定向与输出重定向）详细分析</strong></a></p>

<p><a href="http://www.cnblogs.com/chengmo/archive/2010/10/21/1856577.html">2.<strong>linux shell 管道命令(pipe)使用及与shell重定向区别</strong></a></p>
