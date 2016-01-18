---
layout: post
title: "windows进程管理及脚本编写"
description: "windows进程管理及脚本编写"
category: "windows"
tags: [windows服务器]
---
<p>windows 守护进程类软件很多，如果原理都一样，如果一个进程死掉后那么检测出来后就重启该进程，自己也可编写批处理脚本，如对YaoYanMemRelease.exe检测，如果该进程死掉就里面启动它并发送邮件给自己。</p>

<pre><code>[shell]
@echo off

set _task=YaoYanMemRelease
set _svr=D:\work\YaoYanMemFree\YaoYanMemRelease.exe

:x
tasklist /nh|find /i &amp;quot;%_task%&amp;quot;
if ERRORLEVEL 1 (
    echo %username% &amp;quot;%_task%&amp;quot; is not exists!!! 
    start %_svr%
    call sendmail.vbs
    ) else (ping -n 7200 127.1&amp;gt;nul)
goto x 
[/shell]
</code></pre>

<p>保存为start.bat,上面每7200s执行一次检测。那接下来编写发送邮件的VB脚本</p>

<pre><code>NameSpace = "http://schemas.microsoft.com/cdo/configuration/"
Set Email = CreateObject("CDO.Message")
Email.From = "xinxinyu2011@163.com"
Email.To = "1565208411@qq.com"
Email.Subject = "yaoyan service feedback"
Email.Textbody = "Yaoyan Service on 58.68.234.138 gone away Please Manual reset it"
With Email.Configuration.Fields
.Item(NameSpace&amp;"sendusing") = 2
.Item(NameSpace&amp;"smtpserver") = "smtp.163.com" 
.Item(NameSpace&amp;"smtpserverport") = 25
.Item(NameSpace&amp;"smtpauthenticate") = 1
.Item(NameSpace&amp;"sendusername") = "xinxinyu2011"
.Item(NameSpace&amp;"sendpassword") = "******"
.Update
End With
Email.Send
</code></pre>

<p>保存在start.bat同目录下，起名为sendmail.vbs</p>

<p>当然最好推荐使用<a href="http://www.d9soft.com/soft/87975.htm">风林进程守护</a></p>

<!--more-->

<p>该软件简述如下：</p>

<p>因工作需要，用VB编写的一个进程守护程序，自动检测守护进程的运行状态（运行,未激活,无响应），再根据你的设置来重启未激活及无响应的进程。可根据需要来设置定时启动进程和系统的时间。定时启动进程时，自动结束守护列表中所有进程，再启动列表中的进程。因部分软件运行后会调用另外的进程来执行，本程序支持关联功能，即守护的进程退出或无响应时，对守护的进程做结束处理，再运行指定的关联文件，而不是正在守护的进程。</p>

<p>功能特点：</p>

<ol>
<li>重启时,自动结束重名的所有进程</li>
<li>拥有定时启动功能,防止被守护的进程假死后而无法检测</li>
<li>对守护的进程没有限制,只要是EXE/COM的程序均可守护</li>
<li>定时重启系统功能(用户名及密码)，可按指定的时间重启系统 </li>
<li>检测进程是否响应,并根据设定来决定是否自动重启</li>
<li>守护的进程运行后,可自动发送按键信息完成部分操作</li>
<li>支持关联运行功能,运行时不是运行守护的进程,而是关联的文件,关联的文件可以是BAT EXE COM等类型的文件 </li>
<li>可以手动指定进程运行时的窗口状态，解决部分BAT运行后无法查看的问题</li>
</ol>

<p><img src="http://www.d9soft.com/upload/2011/5/13/2011051348035921.jpg" alt="" /></p>

<p>在下载完成后要把一下OCX文件拷到C:\Windows\SysWOW64目录下并以管理员身份运行DOS,将下面的一一注册进去。</p>

<pre><code>C:\WINDOWS\system32&gt;regsvr32 c:\Windows\SysWOW64\comdlg32.ocx

C:\WINDOWS\system32&gt;regsvr32 c:\Windows\SysWOW64\MSCOMCTL.OCX

C:\WINDOWS\system32&gt;regsvr32 c:\Windows\SysWOW64\MSWINSCK.OCX
</code></pre>

<p>注册完后才能打开风林进程守护.exe，点击添加，把相应位置的可执行文件添加进去即可。</p>
