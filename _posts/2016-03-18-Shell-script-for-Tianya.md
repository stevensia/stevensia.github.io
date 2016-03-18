---
layout: post
title:  Shell script for Tianya
date:   2016-03-18 11:57:41
categories: Misc
tags: Misc
---

抓取天涯论坛楼主贴的shell脚本：


    for i in `seq 1 70`
    do
    wget http://bbs.tianya.cn/post-enterprise-101309-$i.shtml --timeout=5
    done
    for i in `seq 1 70`
    do 
    echo "Working on $i"
    cat post-enterprise-101309-$i.shtml |awk 'BEGIN{a=0;b=0;c=0}/class="host">楼主/{a=1;print}/时间/&&a{print;b=1}/bbs-content/&&a&&b{c=1}a&&b&&c{print}/\/div/&&a&&b&&c{print;a=0;b=0;c=0}' |uniq >>economics.txt
    done
