---
layout: post
title: "linux 命令后台运行方式"
description: "linux 命令后台运行方式"
category: "operation"
tags: [运维]
---

<p>终端与linux系统连接方式如下图：</p>

<p><img src="http://beginman.qiniudn.com/terminal&amp;OS.png" alt="" /></p>

<p>上图，就像打电话一样，只要一方挂断(hangup)则就无法再通讯。对于当用户注销（logout）或者网络断开时，终端会收到 <code>HUP</code>（hangup）信号从而<strong>关闭其所有子进程</strong>。因此，我们的<strong>解决办法就有两种途径：要么让进程忽略 HUP 信号，要么让进程运行在新的会话里从而成为不属于此终端的子进程。</strong></p>

<blockquote>
  <p>Modem亲昵地称之为“猫”， 又叫调制解调器，是一种计算机硬件，它能把计算机的数字信号翻译成可沿普通电话线传送的脉冲信号，而这些脉冲信号又可被线路另一端的另一个调制解调器接收，并译成计算机可懂的语言。这一简单过程完成了两台计算机间的通信。</p>
</blockquote>

<p>根据上面的方案，我们制定如下方案：</p>

<h2>1.nohup</h2>

<p><code>nohup</code>命令，即no hangup,忽略HUP信号，格式如下：</p>

<pre><code>nohup command
nohup command &amp;     # terminal（终端）关闭
</code></pre>

<p>它把标准输出（STDOUT）(<strong>1表示</strong>)，和标准错误（STDERR）(<strong>2表示</strong>)， 结果输出到nohup.txt文件.</p>

<pre><code>root@pvcent107 ~]# nohup ping www.ibm.com &amp;
[1] 3059
nohup: appending output to `nohup.out'
[root@pvcent107 ~]# ps -ef |grep 3059
root      3059   984  0 21:06 pts/3    00:00:00 ping www.ibm.com
root      3067   984  0 21:06 pts/3    00:00:00 grep 3059
[root@pvcent107 ~]#
</code></pre>

<p>如果更改输出，则可如下操作：</p>

<pre><code>nohup ./command.sh &gt; output 2&gt;&amp;1 &amp;
</code></pre>

<p>意思就是将标准输出到output文件中(其中省略了<code>1</code>),后面的<code>2&gt;&amp;1</code>表示<strong>标准错误（2）重定向到标准输出中（1），而标准输出又导入文件output里面，所以结果是标准错误和标准输出都导入文件output里面了。</strong></p>

<blockquote>
  <p>至于为什么需要将标准错误重定向到标准输出的原因，那就归结为标准错误没有缓冲区，而stdout有。
  这就会导致 >output 2>output 文件output被两次打开，而stdout和stderr将会竞争覆盖，这肯定不是我门想要的.这就是为什么有人会写成：<code>nohup ./command.sh &gt;output 2&gt;output</code>, 出错的原因了.</p>
</blockquote>

<p>如果不想输出，则可如下操作：</p>

<pre><code>nohup ./command.sh &gt; /dev/null 2&gt;&amp;1 &amp;
</code></pre>

<!--more-->

<h2>2.setsid</h2>

<p>setsid的原理是让进程运行在新的会话里从而成为不属于此终端的子进程.格式：</p>

<pre><code>setsid commmand
</code></pre>

<p><strong>新生成的进程其父进程ID（PPID）为1（即为 init 进程 ID），并不是当前终端的进程 ID</strong></p>

<h2>3. &amp;</h2>

<p>结合()产生一个新的子shell并在这个子shell中将任务放置到后台运行，从而不受当前shell终端的HUP信号影响。格式如下：</p>

<pre><code>(COMMAND [ARG]... &amp;)
</code></pre>

<p><strong>提交的进程的父 ID（PPID）为1（init 进程的 PID），并不是当前终端的进程 ID。因此并不属于当前终端的子进程，从而也就不会受到当前终端的 HUP 信号的影响了。</strong></p>

<h2>4.控制进程</h2>

<p>通过以下命令，我们可以对放入到后台的命令进行控制</p>

<ol>
<li><p>查看当前终端下的后台进程：<code>jobs</code></p></li>
<li><p>将查看到的某个后台进程放回到前台：<code>fg {jobid}</code> //这里的{jobid}是通过jobs命令中看到的进程前[]中的数字。</p></li>
<li><p>将当前正在前台运行的进程放到后台运行:先敲下快捷键：<code>ctrl +z</code> //暂停当前正在运行的进程。再执行：<code>bg</code></p></li>
<li><p>终止当前正在前台运行的进程：<code>ctrl +c</code></p></li>
</ol>

<p>如下操作：</p>

<pre><code>root@ubuntu-svr:~/project/sync# node server.js
info  - socket.io started

^Z
[1]+  Stopped                 node server.js

root@ubuntu-svr:~/project/sync# bg
[1]+ node server.js &amp;

root@ubuntu-svr:~/project/sync# disown -h %1

root@ubuntu-svr:~/project/sync# jobs
[1]+  Running                 node server.js &amp;
</code></pre>

<h2>5.disown</h2>

<p>如果只是普通执行一个命令而未加上nohup,setsid， 那么如何亡羊补牢呢。这里就用到了<code>disown</code></p>

<ul>
<li>用disown -h jobspec来使某个作业忽略HUP信号。</li>
<li>用disown -ah 来使所有的作业都忽略HUP信号。</li>
<li>用disown -rh 来使正在运行的作业忽略HUP信号</li>
</ul>

<h2>6.screen</h2>

<p>screen能够大规模的实现稳定的后台运行，而不是每个命令都加上<code>nohup</code>或<code>setsid</code>，<strong>screen是建立一个新的全屏虚拟会话终端，这个会话只有在手动输入exit的时候才会退出，在这个会话里执行的命令不用担心HUP信号会对我们的进程造成影响</strong></p>

<p>使用方法：</p>

<ul>
<li>screen //立即创建并进入一个会话。</li>
<li>screen -dmS {name} //建立一个处于挂起模式下的会话，并根据我们的需要指定其会话名称。</li>
<li>screen -dmS {name} {script} //在建立会话时同时执行指定的命令或脚本</li>
<li>screen -list //列出所有会话。</li>
<li>screen -r {name} //以独占方式进入指定会话。</li>
<li>screen -x {name} //以并行方式进入指定会话。</li>
<li>ctrl +ad //输入快捷键ctrl +a和d，可暂时退出当前会话。</li>
<li>exit //进入指定会话后执行exit即可关闭该会话。</li>
</ul>

<h2>参考</h2>

<p><a href="http://www.ibm.com/developerworks/cn/linux/l-cn-nohup/">1.Linux 技巧：让进程在后台可靠运行的几种方法</a></p>

<p><a href="http://heylinux.com/archives/1282.html">2.Linux运行与控制后台进程的方法：nohup, setsid, &amp;, disown, screen</a></p>
