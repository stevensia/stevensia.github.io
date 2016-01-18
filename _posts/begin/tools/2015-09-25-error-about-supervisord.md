---
layout: post
title: "supervisord entered FATAL state, too many start retries too quickly错误处理"
description: "supervisord entered FATAL state, too many start retries too quickly"
category: "linux"
tags: [linux服务器]
---

在服务器中删除东西，删的太得劲了，突然把后端服务给删掉了，幸好托管在github私有仓库，本想着clone一份到服务器就ok的。虽知道服务一直不启动。看了下supervisord错误日志，发现如下：


    cat /tmp/supervisord.log
    event_worker entered FATAL state, too many start retries too quickly


意思就是：“进入了致命状态(FATAL), 一直重启重启重启...”.

[网上查了下](http://xingqiba.sinaapp.com/?p=240)，说是：

>http://blog.gmane.org/gmane.comp.sysutils.supervisor.general/page=3 （Daemons not monitored properly） 发现有人也遇到我一样的我问题，出现这样的错误时原来是redis启动使用了守护模式，修改redis.conf的daemonize为no,重新测试一切OK，由此猜想supervisor启动command是应该监控的是启动command对应的进程编号，一般守护进程的做法就是fork一个子进程，父进程马上退出，以致于supervisor无法得到子进程的ID

这也是经验，但是之前我的程序就能运行，并且没有什么守护模式。 想到的解决办法就是**重启supervisord**, 步骤如下：

1. supervisorctl -c /etc/supervisor.conf, 进入它终端后 `stop all`, 先关掉所有的进程， 因为supervisord相当于父进程，Supervisor作为主进程，Supervisor下管理的时一些子进程，当某一个子进程异常退出时，Supervisor会立马对此做处理，通常会守护进程，重启该进程。如果让子进程变多可控，最好先stop。
2. ps -ef | grep 你的服务， 这是在第一步后，剩余的一些不可控(没有supervisord管理的)的进程， 然后一个个的 kill掉
3. 重启supervisord. kill supervisord的进程， 然后再启动,/usr/local/bin/supervisord -c /etc/supervisor.conf


这样应该就ok了。

一些supervisord相关的知识可参考[**Supervisor学习**](http://beginman.cn/linux/2015/04/06/Supervisor/)

谨记：**不要随随便便的在服务器上乱删乱搞!**
