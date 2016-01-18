---
layout: post
title:  Python module paramiko
date:   2015-12-21 14:19:40
categories: python
excerpt: 
---
* content
{:toc}

上周学习了正则表达式， 能大概了解基本的使用，回想之前学习perl时好像对正则掌握的还可以， 可惜一年过去了， 已基本忘光， 技术这个东西， 一段时间不用真的会失忆。 这次好好学习python， 坚持用下去，毕竟有那么多能结合实际工作和生活的库可用， 而且不会像perl一样， 写过之后几天自己就看不懂了。

今天写了一个ssh的程序，用的paramiko库， 网上找了一个现成的例子， 自己改了改， 记下来主要是为了不会忘记在写的过程中用到的一些语法， 毕竟还是入门阶段， 语法和标准库的不熟悉是硬伤。

主要功能：
多线程ssh登录主机，执行hostname指令（可以自定义其他指令）， 执行成功的输出主机名和对应的IP地址，用户名，密码。

下面是代码：

    #!/usr/bin/python
    #-*- coding: utf-8 -*-
    import paramiko
    import threading
    import re
    def ssh2(ip,username,passwd,cmd):
        try:
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(ip,22,username,passwd,timeout=5)
            for m in cmd:
                stdin, stdout, stderr = ssh.exec_command(m)
                #stdin.write("Y")   #简单交互，输入 ‘Y’
                out = stdout.readlines()
                #屏幕输出
                #for o in out:
                #    print o,
            print '%-20s OK\t%-10s\t%s:%s'%(ip,out[0].strip(),username,passwd)
            ssh.close()
        except:
            print '%-20s Error'%(ip)
    
    if __name__=='__main__':
        cmd = ['hostname']#你要执行的命令列表
        threads = []   #多线程
        print "Begin......"
        with open('hosts','r') as HOST:
          for i in HOST:
            if re.search(r'#',i):
                continue
            ip = str(i.strip('\n'))
            with open('passdb','r') as FH:
              for x  in FH:
                if re.search(r'#',x):
                    continue
                upair=x.split()
                username=upair[0].strip('\n')
                passwd= upair[1]
                a=threading.Thread(target=ssh2,args=(ip,username,passwd,cmd))
                a.start()

			

其中需要调用两个文件，用来存放主机IP地址和密码：

    #cat hosts
    10.32.196.15
    192.168.1.1
    
    
    #cat passdb
    #steven *****
    steven *****

文件中#号注释内容不会被执行， 执行后输出如下：

    ./ssh_auto_net.py
    Begin......
    10.32.196.15         OK steven-laptop   steven:*********
    10.32.196.15         Error
    192.168.1.1          Error
    192.168.1.1          Error





