---
layout: post
title: "python操作linux"
description: "python操作linux"
category: "Python"
tags: [Python]
---
<h1>一.Python执行*nix命令</h1>

<p>有好几种方式,如:<code>os.system()</code>和'subprocess','commands模块',<code>os.system()</code>将会调用标准的C函数<code>system()</code>返回进程或命令的退出状态(一般用0表示)和执行的信息.用于执行简单的命令,对于<code>subprocess</code>而言提供的功能更加强悍.</p>

<!--more-->

<h2>1.os.system()</h2>

<p>语法:</p>

<pre><code>import os
os.system("command")
</code></pre>

<p>示例:</p>

<pre><code>&gt;&gt;&gt; import os
&gt;&gt;&gt; os.system("date")
2014年 07月 21日 星期一 13:23:50 CST
0
</code></pre>

<p>如下脚本统计常用的命令:</p>

<pre><code>#!/bin/bash 
printf "%-32s %-10s\n" 命令 次数
cat ~/.bash_history | awk '{ list [$1] ++; } \
    END {
    for (i in list)
    {
    printf ("%-30s %-10s\n", i, list [i]); }
}' | sort -nrk 2 | head
</code></pre>

<p>可以通过os.system()执行指定的脚本</p>

<pre><code>&gt;&gt;&gt; os.system("/home/beginman/learn/1.sh")
命令                           次数    
cd                             382       
ls                             264       
git                            242       
vim                            100       
gld                            76        
svn                            69        
sudo                           56        
pyrun                          53        
cat                            51        
python                         49        
0
</code></pre>

<p>通过<code>os.popen()</code>存储标准输出到一个变量中:</p>

<pre><code>&gt;&gt;&gt; stringDate = os.popen("date")
&gt;&gt;&gt; print stringDate
&lt;open file 'date', mode 'r' at 0xb73f4440&gt;
&gt;&gt;&gt; sDate = stringDate.read()
&gt;&gt;&gt; print sDate
2014年 07月 21日 星期一 13:25:09 CST
</code></pre>

<h2>2.subprocess</h2>

<p>语法如下:</p>

<pre><code>import subprocess
subprocess.call("command1")
subprocess.call(["command1", "arg1", "arg2"])
</code></pre>

<p>实例:</p>

<pre><code>import subprocess
subprocess.call("date")

# 带参数
import subprocess
subprocess.call(["ls", "-l", "/etc/resolv.conf"])
</code></pre>

<p><code>subprocess.Popen()</code>存储标准输出:</p>

<pre><code>import subprocess
p = subprocess.Popen("date", stdout=subprocess.PIPE, shell=True)
(output, err) = p.communicate()
print output    
2014年 07月 21日 星期一 13:32:50 CST
</code></pre>

<h2>3.commands模块</h2>

<p>commands.getstatusoutput(cmd)返回（status,output)</p>

<p>commands.getoutput(cmd)只返回输出结果</p>

<p>commands.getstatus(file)返回ls -ld file 的执行结果字符串，调用了getoutput，不建议使用这个方法。</p>

<pre><code>&gt;&gt;&gt; import commands
&gt;&gt;&gt; print commands.getstatusoutput('date')
(0, '2014\xe5\xb9\xb4 07\xe6\x9c\x88 21\xe6\x97\xa5 \xe6\x98\x9f\xe6\x9c\x9f\xe4\xb8\x80 13:38:33 CST')
&gt;&gt;&gt; print commands.getoutput('date')
2014年 07月 21日 星期一 13:38:20 CST
&gt;&gt;&gt; print commands.getstatus('tty.sh')
-rwxrwxr-x 1 beginman beginman 361  7月 14 17:22 tty.sh
</code></pre>

<h1>二.Python 获取 Linux 系统信息</h1>

<p>注意使用<a href="https://docs.python.org/2/library/platform.html">platform模块</a>,提供一些接口信息.如:</p>

<pre><code>&gt;&gt;&gt; import platform
&gt;&gt;&gt; platform.uname()
('Linux', 'beginman', '3.13.0-30-generic', '#55-Ubuntu SMP Fri Jul 4 21:43:42 UTC 2014', 'i686', 'athlon')
&gt;&gt;&gt; platform.system()
'Linux'
&gt;&gt;&gt; 
</code></pre>

<p>在Python 2上，它会返回一个包含系统类型(或者内核版本)，主机名，版本，发布版本，机器的硬件以及处理器信息元组(tuple).还可以查看位数:</p>

<pre><code>&gt;&gt;&gt; platform.architecture()
('32bit', 'ELF')
</code></pre>

<p>这个模块能够提供访问系统的<code>基本信息</code>,<code>cpu信息</code>,<code>内存信息</code>,<code>网络统计信息</code>,<code>进程信息</code>,<code>块设备</code>等. 具体内容参考:<a href="http://www.oschina.net/translate/linux-system-mining-with-python">使用 Python 获取 Linux 系统信息</a></p>

<h1>参考</h1>

<p><a href="http://www.cyberciti.biz/faq/python-execute-unix-linux-command-examples/">1.Python Execute Unix / Linux Command Examples</a></p>

<p><a href="http://www.oschina.net/translate/linux-system-mining-with-python">2.使用 Python 获取 Linux 系统信息</a></p>
