---
layout: post
title: "Python 实现有道翻译命令行版"
description: "Python 实现有道翻译命令行版"
category: "python"
tags: [python技巧]
---

<h2>一、个人需求</h2>

<p>由于一直用Linux系统，对于词典的支持特别不好，对于我这英语渣渣的人来说，当看英文文档就一直卡壳，之前用惯了有道词典，感觉很不错，虽然有网页版的但是对于全站英文的网页来说并不支持。索性自己实现一个，基于Python编写的小工具实现有道词典，同时还可以将不认识的生词写入生词本中（xml格式），然后定期批量导入有道词典、沪江英语、金山词霸等。需要申请有道api</p>

<!--more-->

<h2>二、代码</h2>

<p>由于程序过于简单就不再分析了，一些功能还尚在完善中。代码如下：</p>

<pre><code>#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2014-04-03 21:12:16
# @Function: 有道翻译命令行版
# @Author  : BeginMan

import os
import sys
import urllib
import urllib2
reload(sys)
sys.setdefaultencoding("utf-8")
import simplejson as json
import platform
import datetime

API_KEY = '你的'
KEYFORM = '你的'


def GetTranslate(txt):
    url = 'http://fanyi.youdao.com/openapi.do'
    data = {
    'keyfrom': KEYFORM,
    'key': API_KEY,
    'type': 'data',
    'doctype': 'json',
    'version': 1.1,
    'q': txt
    }
    data = urllib.urlencode(data)
    url = url+'?'+data
    req = urllib2.Request(url)
    response = urllib2.urlopen(req)
    result = json.loads(response.read())
    return result

def Sjson(json_data):
    query = json_data.get('query','')               # 查询的文本
    translation = json_data.get('translation','')   # 翻译
    basic = json_data.get('basic','')               # basic 列表
    sequence = json_data.get('web',[])              # 短语列表
    phonetic,explains_txt,seq_txt,log_word_explains = '','','',''

    # 更多释义
    if basic:
        phonetic = basic.get('phonetic','')         # 音标
        explains = basic.get('explains',[])         # 更多释义 列表
        for obj in explains:
            explains_txt += obj+'\n'
            log_word_explains += obj+','    
    # 句子解析
    if sequence:
        for obj in sequence:
            seq_txt += obj['key']+'\n'
            values = ''
            for i in obj['value']:
                values += i+','
            seq_txt += values+'\n'

    print_format = '*'*40+'\n'
    print_format += u'查询对象:  %s [%s]\n' %(query,phonetic)   
    print_format += explains_txt
    print_format += '-'*20+'\n'+seq_txt
    print_format += '*'*40+'\n'
    print print_format
    choices = raw_input(u'是否写入单词本,回复（y/n）:')
    if choices in ['y','Y']:
        filepath = r'/home/beginman/pyword/%s.xml' %datetime.date.today()
        if (platform.system()).lower() == 'windows':
            filepath = r'E:\pyword\%s.xml' %datetime.date.today()
        fp = open(filepath,'a+')
        file = fp.readlines()
        if not file:
            fp.write('&lt;wordbook&gt;\n')
            fp.write(u"""    &lt;item&gt;\n    &lt;word&gt;%s&lt;/word&gt;\n    &lt;trans&gt;&lt;![CDATA[%s]]&gt;&lt;/trans&gt;\n    &lt;phonetic&gt;&lt;![CDATA[[%s]]]&gt;&lt;/phonetic&gt;\n    &lt;tags&gt;%s&lt;/tags&gt;\n    &lt;progress&gt;1&lt;/progress&gt;\n    &lt;/item&gt;\n\n""" %(query,log_word_explains,phonetic,datetime.date.today()))
        fp.close()
        print u'写入成功.'




def main():
    while True:
        txt = raw_input(u'请输入要查询的文本：\n')
        if txt:
            Sjson(GetTranslate(txt))

if __name__ == '__main__':
    main()
</code></pre>

<h2>三、效果图</h2>

<p><img src="http://images.cnblogs.com/cnblogs_com/BeginMan/480086/o_2.0.jpg" alt="" /></p>

<p><img src="http://images.cnblogs.com/cnblogs_com/BeginMan/480086/o_3.0.jpg" alt="" /></p>

<p><img src="http://images.cnblogs.com/cnblogs_com/BeginMan/480086/o_1.0.jpg" alt="" /></p>
