---
layout: post
title: "shell脚本监控celery异常日志并发邮件"
description: "shell脚本监控celery异常日志并发邮件"
category: "celery"
tags: [celery]
---

first:

    yum install ncurses-devel

download mutt and msmtp, then install:

    cd mutt-1.5.21
    ./configure --prefix=/usr/local/mutt
    make && make install

    cd msmtp-1.4.21
    ./configure --prefix=/usr/local/msmtp
    make && make install

安装成功后执行如下脚本设置邮件账户和环境:

    #!/bin/bash
    Mail_SMTP='smtp.163.com'          #这里以163为例
    Mail_USER='xinxinyu2011@163.com'  #你的163地址
    Mail_PWD='****'               #邮箱密码
    Mail_Port='25'                

    home=`echo $HOME`
    mkdir -p /usr/local/msmtp/etc || fail_echo 'mkdir -p /usr/local/msmtp/etc ERROR'
    mkdir -p /usr/local/msmtp/log || fail_echo 'mkdir -p /usr/local/msmtp/log ERROR'

    cat > /etc/Muttrc << EOF
    set sendmail="/usr/local/msmtp/bin/msmtp"
    set use_from=yes
    set realname="${Mail_USER}"
    set editor="vim"
    EOF

    NAME=`echo ${Mail_USER%@*}`
    cat >  ${home}/.msmtprc  << EOF
    host ${Mail_SMTP}
    tls off
    auth plain
    from ${Mail_USER}
    user ${NAME}
    password ${Mail_PWD}
    EOF

    cat >  ${home}/.muttrc  << EOF
    set sendmail="/usr/local/msmtp/bin/msmtp"
    set use_from=yes
    set from=${Mail_USER}
    set envelope_from=yes
    EOF

    cat > /usr/local/msmtp/etc/msmtprc << EOF
    defaults 
    account ${NAME}
    host ${Mail_SMTP}
    from ${Mail_USER}
    auth login
    port ${Mail_Port}
    tls off
    user ${Mail_USER}
    password ${Mail_PWD}
    account default : ${NAME}
    logfile /usr/local/msmtp/log/msmtp.log
    EOF

    test -f /usr/bin/msmtp || ln -s /usr/local/msmtp/bin/msmtp /usr/bin/
    test -f /usr/bin/mutt  || ln -s /usr/local/mutt/bin/mutt   /usr/bin/
    test -f /usr/local/mutt/bin/mutt && secho 'Install success \n Try: echo "thanks liks"|mutt -s "test mail" you@mail.com'

执行完： `chmod +x install.sh;./install.sh`成功后就ok了，这里测试下：

     echo "这是邮件内容"|mutt -s "test for email" 1373763906@qq.com

一会儿我的qq邮箱就能收到邮件了。

监控Celery服务是否有异常的shell脚本如下：

    #!/bin/bash
    # -------------------------------------------------------------------------------
    # Revision:    1.0
    # Date:        2015/09/28
    # Author:      fangpeng
    # Website:     www.beginman.cn
    # Description: Celery 错误日志监控通知
    # -------------------------------------------------------------------------------
    OBJPATH="/mnt/log/celery/"              #日志路径       
    LOGPATH="celery.log"                #日志名称
    MAILTO="1373763906@qq.com"              #收件人
    DATE="celery_errlogs-`date +'%Y%m%d-%H:%M:%S'`"   #当前时间
    MAILTITLE=DATE                    #邮件主题
    BACKFILE=$DATE.txt                  #备份的异常日志

    cd ${OBJPATH}

    # 将celery错误日志内容以附件的形式发email
    function sendEmail(){
      mutt -s ${MAILTITLE} ${MAILTO} <${LOGPATH} -a ${LOGPATH}
      cp ${LOGPATH} ${BACKFILE}
      :>${LOGPATH}
    }

    # 判断celery日志文件是否为空
    function checkCeleryLog(){
      if test -s ${LOGPATH}; then
        cat ${LOGPATH}
        echo "正在发送异常处理邮件给管理员...."
        sendEmail
        echo "邮件发送成功!"
      else
        echo "empty"
      fi
    }

    echo "Celery异常日志检查中...."
    checkCeleryLog


做个定时，每小时执行：

	* */1 * * * /bin/sh /home/team/project/ylx/ylx/shell/check_celecr_log.sh




