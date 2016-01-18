---
layout: post
title: "shell之read 用法"
description: "shell之read 用法"
category: "Shell"
tags: [Shell]
---
<h1>一.read语法简介</h1>

<p><code>help read</code>之后会蹦出语法简介,如下:</p>

<pre><code>[beginman@beginman myshell]$ help read
read: read [-ers] [-a 数组] [-d 分隔符] [-i 缓冲区文字] [-n 读取字符数] [-N 读取字符数] [-p 提示符] [-t 超时] [-u 文件描述符] [名称 ...]
    Read a line from the standard input and split it into fields.
</code></pre>

<!--more-->

<p>read读取标准输入(或重定向输入).参数如下:</p>

<blockquote>
  <p>-a 后跟一个变量，该变量会被认为是个数组，然后给其赋值，默认是以空格为分割符。</p>
  
  <p>-d 后面跟一个标志符，其实只有其后的第一个字符有用，作为结束的标志，会举例说  明。</p>
  
  <p>-p 后面跟提示信息，即在输入前打印提示信息。</p>
  
  <p>-e 在输入的时候可以时候命令补全功能。</p>
  
  <p>-n 后跟一个数字，定义输入文本的长度，很实用。</p>
  
  <p>-r 屏蔽\，如果没有该选项，则\作为一个转义字符，有的话 \就是个正常的字符了。</p>
  
  <p>-s 安静模式，在输入字符时不再屏幕上显示，例如login时输入密码。</p>
  
  <p>-t 后面跟秒数，定义输入字符的等待时间。</p>
  
  <p>-u 后面跟fd，从文件描述符中读入，该文件描述符可以是exec新开启的。</p>
</blockquote>

<h1>二.应用</h1>

<h2>1.标准输入</h2>

<pre><code># 繁琐版本
echo "your name:"
read name
echo "name:$name"

# 精简版 -p 提示
read -p "your name:" name
echo "name:$name"

#如果不指定变量则放在环境变量REPLY中
read -p "you name:"
echo "name:$REPLY"
</code></pre>

<h2>2.计时输入</h2>

<pre><code># 控制等待输入的时间 -t Second, 超过Second秒则不再等待而继续执行
if read -t 5 -p "Please input your name:" name;
then
    echo "$name,welcome!";
else
    echo "sorry";
fi;
exit 0
</code></pre>

<h2>3.控制字符输入</h2>

<pre><code># 控制输入字符长度 -nNumber Number表示控制字符的长度,超过则read命令立即接受输入并将其传给变量。无需按回车键。
read -n1 -p "Do you agree with me [Y/N]?" ans  # 只运行输入1个字符
case $ans in
Y|y)
    echo "Great!";;
N|n)
    echo "Oh No!";;
*)
    echo "Please choice Y or N";;
esac;
</code></pre>

<h2>4.读取文件</h2>

<pre><code># 读取文件,通过cat file 配合管道处理,如 cat file | while read line
count=1   # 行数统计
if read -p "choice your file:" yourfile;then
    cat $yourfile|while read line
    do
        echo "Line $count:$line"
        let count++
    done
    exit 0
else
    echo "None"
    exit 0
fi;
exit 0
</code></pre>

<h2>5.输入不显示</h2>

<pre><code>#密码 read -s (输入不显示在监视器上,实则改变背景色)
read -s -p "your pwd:"
</code></pre>

<p><img src="http://photocdn.sohu.com/20110429/Img306684641.jpg" alt="" /></p>

<p>参考:<a href="http://www.cnblogs.com/iloveyoucc/archive/2012/04/16/2451328.html">http://www.cnblogs.com/iloveyoucc/archive/2012/04/16/2451328.html</a></p>

<h1>三.案例</h1>

<p>对于个人git用户,如github,基本上就应用一个分支,经常输入git命令执行,不如简之以shell脚本,如下:</p>

<pre><code>#!/bin/bash
echo "初始化中....."
git pull origin master;
git add -A;
read -p "输入日志,按Enter键跳过 :" log
if  [ ! -n "$log" ] ;then
    git ci -m "自动生成";
else git ci -m "${log}";
fi;
git push origin master;
echo "远程推送完成"
</code></pre>
