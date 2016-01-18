---
layout: post
title: "shell return"
description: "shell return"
category: "Shell"
tags: [Shell]
---

<pre><code>#!/bin/bash
# ----------------------------
# author:beginman
# function: shell return
# ----------------------------

function test(){
    if [ $1 == '1' ]; then
        return 1
    else
        return 0
    fi
}
test 1
echo $?     #$?输出上次结果

#way 1:
if [ test ]; then
    echo "test return 1"
fi

#way 2:
if [ test==1 ]; then
    echo 'only return 0 or 1'
fi

#shell false &amp; true
if false ; then
    echo "shell false."
else
    echo "shell true"
fi

#return only int
if [ $?==true ]; then
    echo "with true"
fi


#全局变量
argv_name=

function setArgv(){
    #修改全局变量
    argv_name=$1
    return 0
}

setArgv 100
echo "argv_name=${argv_name}"
</code></pre>
