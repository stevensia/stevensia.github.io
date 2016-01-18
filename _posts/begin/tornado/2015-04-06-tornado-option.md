---
layout: post
title: "tornado源码分析(1).option模块"
description: "tornado源码分析(1).option模块"
category: "tornado"
tags: [tornado]
---

<p>在使用tornado时，我们用到<code>option</code>模块来定义或解析命令，如下：</p>

<pre><code>from tornado.options import define, options, parse_command_line

define('port', default=8080, type=int, help='run this port', group='system')
define('mysql',default='127.0.0.1:3306', type=str, help='use this mysql', group='system')


def connect():
    db = database.Connection(options.mysql_host)
    ...
</code></pre>

<p><code>option</code>命令行解析模块,让模块定义自己的选项，源码分析地址:<a href="https://github.com/BeginMan/tornadoDOC/blob/master/options.py"><strong>tornadoDOC/options.py</strong></a></p>

<!--more-->

<p>文档地址：<a href="http://www.tornadoweb.org/en/stable/options.html"><strong>tornado.options — Command-line parsing</strong></a></p>

<p>在看完其源码后，我们可以仿照它来自定义异常类，如下需求：</p>

<pre><code>#定义全局异常类
errcode_define("GroupNotFound", 10001, desc=u"没有权限访问", group="Group", help="errorException-Help...")
</code></pre>

<p>定义完成后在全局范围内使用：</p>

<pre><code>#使用
raise ServiceException(errorcodes.GroupNotFound.code, errorcodes.GroupNotFound.message)
</code></pre>

<p>造轮子如下：</p>

<pre><code>    # coding=utf-8
"""
@name:      tornado自定义异常类
@author:    beginman
@desc:      仿照Tornado options定义异常.
@Date:      2015-03-02 09:55:14
"""
__author__ = 'fang'

class MyException(Exception): pass

class ExceptionServer(MyException):
    def __init__(self, code, message, expression=None):
        super(ExceptionServer, self).__init__(message)
        self.code = code
        self.message = message
        self.expression = expression

    def __str__(self):
        return repr("code:%s msg:%s  (expression:%s)" % (self.code,self.message, self.expression))

class OptionsParse(object):
    """
    object-like的字典
    通常情况下，通过静态函数的`errOptions`访问，其中引用的全局实例
    """
    def __init__(self):
        self.__dict__['_options'] = {}      #定义全局_options

    def __getattr__(self, name):
        if isinstance(self._options.get(name), ErrorOption):
            return self._options.get(name)
        raise AttributeError("Unrecognized error option %r" % name)

    def __setattr__(self, name, value):
        if isinstance(self._options.get(name), ErrorOption):
            return self._options.get(name).set(value)
        raise AttributeError("Unrecognized error option %r" % name)

    def __iter__(self):
        return iter(self._options)

    def __getitem__(self, item):
        return self._options[item].value()

    def define(self, name, code, message,group=None, help=None, callback=None):
        """定义异常类选项
            name:全局唯一，异常名字
            code:异常类代码
            message:异常的描述
            group:异常分组
            help:异常帮助提示
            callback:如果存在则调用callback函数
        """
        if name in self._options:
            raise MyException("ErrorOption %r already defined in %s" % (name, self._options[name].name))

        self._options[name] = ErrorOption(name, code, message, group, help=help, callback=callback)


class ErrorOption(object):
    def __init__(self, name, code, message,group=None, help=None, callback=None):
        self.name = name
        self.code = code
        self.message = message
        self.group = group
        self.help = help
        self.callback = callback

    def value(self):
        return self.code

    def set(self, code):
        self.code = code
        if self.callback is not None:
            self.callback(self.code)

erroptions = OptionsParse()

def defineException(name, code, message, group=None, help=None,callback=None):
    """在全局空间中定义选项
    See `OptionParser.define`.
    """
    return erroptions.define(name, code, message, group, help=help, callback=callback)


if __name__ == '__main__':
    # raise ExceptionServer(400, 'error', 'ExpressionValue')
    defineException("TestRaise",1001,"ExceptionMessage",group="User")

    print erroptions.TestRaise.code
    print erroptions.TestRaise.message
    raise ExceptionServer(erroptions.TestRaise.code, erroptions.TestRaise.message)
</code></pre>
