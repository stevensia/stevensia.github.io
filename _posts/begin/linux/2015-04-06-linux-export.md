---
layout: post
title: "linux export命令，设置环境变量"
description: "linux export命令，设置环境变量"
category: "linux"
tags: [linux基础]
---

<p><code>export</code>显示或设置（增删改）环境变量，参数如下：</p>

<p>语法：export [-fnp][变量名称]=[变量设置值]</p>

<p><code>-f</code> 　代表[变量名称]中为函数名称。</p>

<p><code>-n</code> 　删除指定的变量。变量实际上并未删除，只是不会输出到后续指令的执
行环境中。</p>

<p><code>-p</code> 　列出所有的shell赋予程序的环境变量。(同 export)</p>

<p>如把mysql启动路径加入环境变量中，可以这样：</p>

<pre><code>export PATH="/usr/local/mysql/bin:$PATH"
#或
export PATH=$PATH:/usr/local/mysql/bin
</code></pre>

<p>通过<code>export</code>或<code>export -p</code> 来查看shell中所有的环境变量，或者通过直接查看环境变量<code>echo $PATH</code>,一般都会输出一些启动文件如：/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:</p>

<!--more-->

<p>当然还可以直接编辑环境变量文件，如：</p>

<pre><code>#vim /etc/profile
export PATH="$PATH:/ opt/build_tools/bin "

#or :vim .bashrc
export PATH="$PATH:/ opt/build_tools/bin "

#or vim /etc/re.load
export PATH="$PATH:/ opt/build_tools/bin "
</code></pre>

<p>需要重新注销系统才能生效</p>

<blockquote>
  <p>“/bin”、“/sbin”、“/usr/bin”、“/usr/sbin”、“/usr/local/bin”等路径已经在系统环境变量中了，如果可执行文件在这几个标准位置，在终端命令行输入该软件可执行文件的文件名和参数(如果需要参数)，回车即可。</p>
  
  <p>如果不在标准位置，文件名前面需要加上完整的路径。不过每次都这样跑就太麻烦了，一个“一劳永逸”的办法是把这个路径加入环境变量。命令 <code>PATH=$PATH:路径</code>,可以把这个路径加入环境变量，但是退出这个命令行就失效了。要想永久生效，需要把这行添加到环境变量文件里。有两个文件可 选：“/etc/profile”和用户主目录下的“.bash_profile”，“/etc/profile”对系统里所有用户都有效，用户主目录下 的“.bash_profile”只对这个用户有效。</p>
</blockquote>

<p>　　<code>PATH=$PATH:路径1:路径2:...:路径n</code>，意思是可执行文件的路径包括原先设定的路径，也包括从“路径1”到“路径n”的所有路径。当用户输入一个一串字符并按回车后，shell会依次在这些路径里找对应的可执行文件并交给系统核心执行。“$PATH”表示原先设定的路径仍然有效，注意不要漏掉。某些软件可能还有“PATH”以外类型的环境变量需要添加，但方法与此相同，并且也需要注意“$”。</p>

<p>　　注意，<strong>与DOS/Window不同，UNIX类系统环境变量中路径名用冒号分隔，不是分号</strong>。另外，软件越装越多，环境变量越添越多，为了避免造成混乱，建议所有语句都添加在文件结尾，按软件的安装顺序添加。</p>

<pre><code>格式如下()：
# 软件名-版本号
PATH=$PATH:路径1:路径2:...:路径n
其他环境变量=$其他环境变量:...
</code></pre>

<p>　　设置完毕，注销并重新登录，设置就生效了。如果不注销，直接在shell里执行这些语句，也能生效，但是作用范围只限于执行了这些语句的shell。</p>

<p>　　相关的环境变量生效后，就不必老跑到软件的可执行文件目录里去操作了。
　　
参考：<a href="http://www.cnblogs.com/amboyna/archive/2008/03/08/1096024.html">在Linux里设置环境变量的方法（export PATH)</a>
　　</p>
