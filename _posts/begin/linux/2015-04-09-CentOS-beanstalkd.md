---
layout: post
title: "CentOS安装配置beanstalkd"
description: "CentOS安装配置beanstalkd"
category: "linux"
tags: [linux基础]
---

<p>在CentOS安装：</p>

<pre><code>su -c 'yum install beanstalkd'
默认安装路径 ：/usr/bin/beanstalkd

#查看版本
beanstalkd -v
beanstalkd 1.9 
</code></pre>

<p>启动，添加启动脚本，放入 /etc/init.d/ 目录下：</p>

<pre><code>chmod 755 /etc/init.d/beanstalkd 

#加入开机启动：

chkconfig beanstalkd  on

#启动：

service beanstalkd start 
</code></pre>

<p>默认端口是11300.</p>

<!--more-->

<p>最后附一个管理beanstalkd的脚本：</p>

<pre><code>#!/bin/sh
#
# beanstalkd - a simple, fast workqueue service
#
# chkconfig:   - 57 47
# description: a simple, fast workqueue service
# processname:  beanstalkd
# config:       /etc/sysconfig/beanstalkd
#              

### BEGIN INIT INFO
# Provides: beanstalkd
# Required-Start: $local_fs $network $remote_fs
# Required-Stop: $local_fs $network $remote_fs
# Default-Stop: 0 1 2 6
# Short-Description: start and stop beanstalkd
# Description: a simple, fast work-queue service
### END INIT INFO

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "$NETWORKING" = "no" ] &amp;&amp; exit
exec="/usr/local/bin/beanstalkd"
prog=$(basename $exec)

# default options, overruled by items in sysconfig
BEANSTALKD_ADDR=127.0.0.1
BEANSTALKD_PORT=11300
BEANSTALKD_USER=beanstalkd

[ -e /etc/sysconfig/beanstalkd ] &amp;&amp; . /etc/sysconfig/beanstalkd

lockfile=/var/lock/subsys/beanstalkd

start() {
    [ -x $exec ] || exit 5
    echo -n $"Starting $prog: "
    # if not running, start it up here, usually something like "daemon $exec"
    options="-l ${BEANSTALKD_ADDR} -p ${BEANSTALKD_PORT} -u ${BEANSTALKD_USER}"
    if [ "${BEANSTALKD_MAX_JOB_SIZE}" != ""  ]; then
        options="${options} -z ${BEANSTALKD_MAX_JOB_SIZE}"
    fi

    if [ "${BEANSTALKD_BINLOG_DIR}" != "" ]; then
        if [ ! -d "${BEANSTALKD_BINLOG_DIR}" ]; then
            echo "Creating binlog directory (${BEANSTALKD_BINLOG_DIR})"
            mkdir -p ${BEANSTALKD_BINLOG_DIR} &amp;&amp; chown ${BEANSTALKD_USER}:${BEANSTALKD_USER} ${BEANSTALKD_BINLOG_DIR}
        fi
        options="${options} -b ${BEANSTALKD_BINLOG_DIR}"
        if [ "${BEANSTALKD_BINLOG_FSYNC_PERIOD}" != "" ]; then
            options="${options} -f ${BEANSTALKD_BINLOG_FSYNC_PERIOD}"
        else
            options="${options} -F"
        fi
        if [ "${BEANSTALKD_BINLOG_SIZE}" != "" ]; then
            options="${options} -s ${BEANSTALKD_BINLOG_SIZE}"
        fi
    fi

    daemon $exec -d $options
    retval=$?
    echo
    [ $retval -eq 0 ] &amp;&amp; touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $prog: "
    # stop it here, often "killproc $prog"
    killproc $prog -INT
    retval=$?
    echo
    [ $retval -eq 0 ] &amp;&amp; rm -f $lockfile
    return $retval
}

restart() {
    stop
    start
}

reload() {
    restart
}

force_reload() {
    restart
}

rh_status() {
    # run checks to determine if the service is running or use generic status
    status $prog
}

rh_status_q() {
    rh_status &gt;/dev/null 2&gt;&amp;1
}


case "$1" in
    start)
        rh_status_q &amp;&amp; exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
        exit 2
esac
exit $?
</code></pre>

<p>保存为runBeanstalkd.sh， 使用方式：</p>

<pre><code>./runBeanstalkd.sh {start|stop|status|restart|condrestart|try-restart|reload|force-reload}
</code></pre>

<p><strong>for python:</strong></p>

<p><a href="https://github.com/earl/beanstalkc">A simple beanstalkd client library for Python</a></p>

<p><strong>参考：</strong></p>

<p><a href="http://kr.github.io/beanstalkd/download.html">1.官网：beanstalkd在各个平台上的安装方式</a></p>

<p><a href="http://my.oschina.net/jsk/blog/77652">2.CentOS下安装beanstalkd服务</a></p>
