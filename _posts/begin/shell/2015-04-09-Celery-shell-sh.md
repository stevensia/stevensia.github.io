---
layout: post
title: "Celery shell服务脚本"
description: "Celery shell服务脚本"
category: "Celery"
tags: [Celery]
---
<p>celery官网貌似没有提供给服务脚本，参照Redis的启动脚本和celery命令，可自行写一个脚本。首先celery配置如下：</p>

<pre><code># coding=utf-8
from __future__ import absolute_import
__author__ = 'fang'
#coding:utf-8
import sys
import os
sys.path.insert(0, os.getcwd())

BROKER_URL = 'amqp://'
CELERY_RESULT_BACKEND = 'redis://:password@localhost:6379/2'


from celery import Celery

app = Celery('service',
             broker=BROKER_URL,
             backend=CELERY_RESULT_BACKEND,
             include=[
                 'service.contact_server',
                 'service.group_server',
                 'service.user_server',
                 'service.tag_server',
                 'service.chatgroup_server',
                 ]
)

# Optional configuration, see the application user guide.
app.conf.update(
    CELERY_TASK_RESULT_EXPIRES=3600,
    )

if __name__ == '__main__':
    #command: run: celery -A celeryconfig worker --loglevel=info --concurrency 10
    #command: stop: ps auxww | grep 'celery worker' | awk '{print $2}' | xargs kill -9
    app.start()
</code></pre>

<!--more-->

<p>接下来新建脚本celeryd.sh：</p>

<pre><code>#!/bin/bash
# ----------------------------
# author:beginman
# function:Celery Task启动脚本
# ----------------------------
CONFIG_NAME='celeryconfig'
CELERY_CONFIG=${CONFIG_NAME}'.py'
TASK_PATH='/home/yunlianxi/project/yunlianxi'

cd ${TASK_PATH}

function startTask(){
    #启动celery
    if [ -f "$CELERY_CONFIG" ]; then
        process=`ps aux | grep rabbitmq_server | grep -v grep`;
        if [ "$process" != " " ]; then
            echo "runing celery task ......."
            export C_FORCE_ROOT="true"
            celery -A celeryconfig worker --loglevel=info --concurrency 10 &amp;
            echo "celery tasks are successful!"

        else
            echo "please run rabbitmq_server!"
        fi
    else
        echo "there[${CELERY_CONFIG}] not exists Celery Task Config!"
    fi
}

function stopTask(){
    #停止task
    if [ checkTaskRuning ] ;then
        ps auxww | grep 'celeryconfig worker' | grep -v grep|awk '{print $2}' | xargs kill -9;
    fi
}

function checkTaskRuning(){
    #检查是否正在运行
    processIDs=`ps auxww | grep 'celeryconfig worker' | awk '{print $2}'`;
    if [ "$processIDs" != " " ]; then
            echo "celery tasks runing!"
            return 1
        else
            echo "celery tasks stoped!"
            return 0
        fi
}

case "$1" in
    start)
        if ! checkTaskRuning ;then
            startTask
        fi
        ;;
    stop)
        stopTask;;
    ''|' ')
        echo 'run with start|stop'
esac
</code></pre>

<p>检查无误后，操作如下：</p>

<pre><code>cp celeryd.sh /etc/init.d/celeryd        # 服务
cp celeryd.sh /usr/local/bin/celeryd     # bash 命令
</code></pre>

<p>使用：</p>

<pre><code>celeryd start        #启动celery task
celeryd stop         #停止该服务
</code></pre>
