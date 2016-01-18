---
layout: post
title:  "Linux bash environment setting and bashrc file"
date:   2015-12-05 12:15:22
categories: Linux
excerpt: 
---
* content
{:toc}


###Before
关于Linux下的bash环境问题一直没搞明白，今天在自己的系统中加了个用户，然后copy了.bashrc到home目录下，结果不生效。  
网上找了些文档整理出来。

---

####启动过程

在登录Linux时要执行文件的过程如下：

    #!/bin/sh
    /etc/profile -> (~/.bash_profile | ~/.bash_login | ~/.profile) -> 
         ~/.bashrc -> /etc/bashrc -> ~/.bash_logout


在刚登录Linux时:  


1. 首先启动 /etc/profile 文件;  

2. 然后再启动用户目录下的 ~/.bash_profile、 ~/.bash_login或 ~/.profile文件中的其中一个，

    如果 ~/.bash_profile文件存在的话,一般还会执行 ~/.bashrc文件。

    因为:
     ~/.bash_profile文件中一般会有下面的代码：
    if [ -f ~/.bashrc ] ; then
    . ./bashrc
    fi
    
    ~/.bashrc中，一般还会有以下代码：
    if [ -f /etc/bashrc ] ; then
    . /bashrc
    fi

    所以，~/.bashrc会调用 /etc/bashrc文件。 

3. 最后，在退出shell时，还会执行 ~/.bash_logout文件。  


>用户目录下的 ~/.bash_profile、 ~/.bash_login或 ~/.profile文件 任何一个存在，而其中没有load其他配置文件，那么加载终止。  
>Ubuntu默认只包含/etc/profile, ~/.profile, ~/.bashrc, 其中~/.profile 中包含加载~/.bashrc

---

####文件说明


/etc/profile:此文件为系统的每个用户设置环境信息,当用户第一次登录时,该文件被执行.并从/etc/profile.d目录的配置文件中搜集shell的设置.  
/etc/bashrc: 为每一个运行bash shell的用户执行此文件.当bash shell被打开时,该文件被读取。  
~/.bashrc:该文件包含专用于你的bash shell的bash信息,当登录时以及每次打开新的shell时,该文件被读取.（每个用户都有一个.bashrc文件，在用户目录下)  
~/.bash_logout:当每次退出系统(退出bash shell)时,执行该文件.  

**~/.bash_profile** 是交互式、login 方式进入 bash 运行的  
每个用户都可使用该文件输入专用于自己使用的shell信息,当用户登录时,该文件仅仅执行一次!默认情况下,他设置一些环境变量,执行用户的.bashrc文件.  
**~/.bashrc** 是交互式 non-login 方式进入 bash 运行的   
该文件包含专用于你的bash shell的bash信息,当登录时以及每次打开新的shell时,该该文件被读取。   

>通常二者设置大致相同，所以通常前者会调用后者。××

####示例
网上看到一个比较全的设置[示例](http://blog.csdn.net/bangemantou/article/details/7682272)，之前从来没认真研究过，等空下来再好好看看。

>参考： [linux中.bashrc文件](http://my.oschina.net/wxfvm/blog/332726)


