---
layout: post
title: "django简单邮件系统"
description: "django简单邮件系统"
category: "django"
tags: [django]
---

<p>总结如下：
1、首先这份文档看三两遍是不行的，很多东西再看一遍就通顺了。
2、send_mail()、send_mass_mail()都是对EmailMessage类使用方式的一个轻度封装，所以要关注底层的EmailMessage。
3、异常处理防止邮件头注入。
4、一定要弄懂Email backends 邮件发送后端
5、多线程的邮件发送。
个人简单配置如下：
首先是settings.py文件</p>

<pre><code>#settings.py

#邮件配置
EMAIL_HOST = 'smtp.gmail.com'                   #SMTP地址
EMAIL_PORT = 25                                 #SMTP端口
EMAIL_HOST_USER = 'pythonsuper@gmail.com'       #我自己的邮箱
EMAIL_HOST_PASSWORD = '******'                  #我的邮箱密码
EMAIL_SUBJECT_PREFIX = u'[Python社区]'            #为邮件Subject-line前缀,默认是'[django]'
EMAIL_USE_TLS = True                             #与SMTP服务器通信时，是否启动TLS链接(安全链接)。默认是false
#管理员站点
SERVER_EMAIL = 'xinxinyu2011@163.com'            #The email address that error messages come from, such as those sent to ADMINS and MANAGERS.
</code></pre>

<!--more-->

<p>这里推荐：各大型邮箱smtp服务器及端口收集</p>

<p>各大型邮箱smtp服务器及端口收集：</p>

<p>新浪邮箱smtp服务器</p>

<p>外发服务器:smtp.vip.sina.com</p>

<p>收件服务器:pop3.vip.sina.com</p>

<p>新浪免费邮件</p>

<p>外发服务器:smtp.sina.com.cn</p>

<p>收件服务器:pop3.sina.com.cn</p>

<p>163邮箱smtp服务器</p>

<p>pop： pop.163.com</p>

<p>smtp： smtp.163.com</p>

<p>QQ邮箱smtp服务器及端口</p>

<p>接收邮件服务器：imap.exmail.qq.com，使用SSL，端口号993</p>

<p>发送邮件服务器：smtp.exmail.qq.com，使用SSL，端口号465或587</p>

<p>yahoo邮箱smtp服务器</p>

<p>接：pop.mail.yahoo.com.cn</p>

<p>发：smtp.mail.yahoo.com</p>

<p>126邮箱smtp服务器</p>

<p>pop： pop.126.com</p>

<p>smtp： smtp.126.com</p>

<p>新浪免费邮箱</p>

<p>POP3：pop.sina.com</p>

<p>SMTP：smtp.sina.com</p>

<p>SMTP端口号：25</p>

<p>新浪VIP邮箱</p>

<p>POP3：pop3.vip.sina.com</p>

<p>SMTP：smtp.vip.sina.com</p>

<p>SMTP端口号：25</p>

<p>新浪企业邮箱</p>

<p>POP3：pop.sina.com</p>

<p>SMTP：smtp.sina.com</p>

<p>SMTP端口号：25</p>

<p>雅虎邮箱</p>

<p>POP3：pop.mail.yahoo.cn</p>

<p>SMTP：smtp.mail.yahoo.cn</p>

<p>SMTP端口号：25</p>

<p>搜狐邮箱</p>

<p>POP3：pop3.sohu.com</p>

<p>SMTP：smtp.sohu.com</p>

<p>SMTP端口号：25</p>

<p>TOM邮箱</p>

<p>POP3：pop.tom.com</p>

<p>SMTP：smtp.tom.com</p>

<p>SMTP端口号：25</p>

<p>Gmail邮箱</p>

<p>POP3：pop.gmail.com</p>

<p>SMTP：smtp.gmail.com</p>

<p>SMTP端口号：587 或 25</p>

<p>QQ邮箱</p>

<p>POP3：pop.exmail.qq.com</p>

<p>SMTP：smtp.exmail.qq.com</p>

<p>SMTP端口号：25</p>

<p>263邮箱</p>

<p>域名：263.net</p>

<p>POP3：263.net</p>

<p>SMTP：smtp.263.net</p>

<p>SMTP端口号：25</p>

<p>域名：x263.net</p>

<p>POP3：pop.x263.net</p>

<p>SMTP：smtp.x263.net</p>

<p>SMTP端口号：25</p>

<p>域名：263.net.cn</p>

<p>POP3：263.net.cn</p>

<p>SMTP：263.net.cn</p>

<p>SMTP端口号：25</p>

<p>域名：炫我型</p>

<p>POP3：pop.263xmail.com</p>

<p>SMTP：smtp.263xmail.com</p>

<p>SMTP端口号：25</p>

<p>21CN 免费邮箱</p>

<p>POP3：pop.21cn.com</p>

<p>SMTP：smtp.21cn.com</p>

<p>IMAP：imap.21cn.com</p>

<p>SMTP端口号：25</p>

<p>21CN 经济邮邮箱</p>

<p>POP3：pop.21cn.com</p>

<p>SMTP：smtp.21cn.com</p>

<p>SMTP端口号：25</p>

<p>21CN 商务邮邮箱</p>

<p>POP3：pop.21cn.net</p>

<p>SMTP：smtp.21cn.net</p>

<p>SMTP端口号：25</p>

<p>21CN 快感邮箱</p>

<p>POP3：vip.21cn.com</p>

<p>SMTP：vip.21cn.com</p>

<p>SMTP端口号：25</p>

<p>21CN Y邮箱</p>

<p>POP3：pop.y.vip.21cn.com</p>

<p>SMTP：smtp.y.vip.21cn.com</p>

<p>SMTP端口号：25</p>

<p>中华网任我邮邮箱</p>

<p>POP3：rwpop.china.com</p>

<p>SMTP：rwsmtp.china.com</p>

<p>SMTP端口号：25</p>

<p>中华网时尚、商务邮箱</p>

<p>POP3：pop.china.com</p>

<p>SMTP：smtp.china.com</p>

<p>SMTP端口号：25</p>

<p>那么发送邮件如下：</p>

<pre><code>def setEmail(request):

    if request.method == "POST":
#        方式一：
#         send_mail('subject', 'this is the message of email', 'pythonsuper@gmail.com', ['1565208411@qq.com','1373763906@qq.com'], fail_silently=True)

#        方式二：
#         message1 = ('subject1','this is the message of email1','pythonsuper@gmail.com',['1565208411@qq.com','xinxinyu2011@163.com'])
#         message2 = ('subject2','this is the message of email2','pythonsuper@gmail.com',['1373763906@qq.com','xinxinyu2011@163.com'])
#         send_mass_mail((message1,message2), fail_silently=False)

#        方式三：防止邮件头注入
#         try:
#             send_mail(subject, message, from_email, recipient_list, fail_silently, auth_user, auth_password, connection)
#         except BadHeaderError:
#             return HttpResponse('Invaild header fount.')

#        方式四：EmailMessage()
        #首先实例化一个EmailMessage()对象
#         em = EmailMessage('subject','body','from@example.com',['1565208411@qq.com'],['xinxinyu2011@163.com'],header={'Reply-to':'another@example.com'})
        #调用相应的方法

#         方式五：发送多用途邮件
        subject,form_email,to = 'hello','from@example.com','1565208411@qq.com'
        text_content = 'This is an important message'
        html_content = u'&lt;b&gt;激活链接：&lt;/b&gt;&lt;a href="http://www.baidu.com"&gt;http:www.baidu.com&lt;/a&gt;'
        msg = EmailMultiAlternatives(subject,text_content,form_email,[to])
        msg.attach_alternative(html_content, 'text/html')
        msg.send()

#       发送邮件成功了给管理员发送一个反馈
#         mail_admins(u'用户注册反馈', u'当前XX用户注册了该网站', fail_silently=True)
        return HttpResponse(u'发送邮件成功')
    return render_to_response('common/test.html')
</code></pre>

<p>截图如下：</p>

<p><img src="http://images.cnitblog.com/blog/476998/201311/26134657-5840c32957b94a45beb17176e7f37464.png" alt="" /></p>
