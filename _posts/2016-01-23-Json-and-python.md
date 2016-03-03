---
layout: post
title:  Json and Python
date:   2016-01-23 21:22:18
categories: Python
tags: Python
---

#### 什么是json：

JSON(JavaScript Object Notation) 是一种轻量级的数据交换格式。易于人阅读和编写。同时也易于机器解析和生成。它基于JavaScript Programming Language, Standard ECMA-262 3rd Edition - December 1999的一个子集。JSON采用完全独立于语言的文本格式，但是也使用了类似于C语言家族的习惯（包括C, C++, C#, Java, JavaScript, Perl, Python等）。这些特性使JSON成为理想的数据交换语言。

JSON建构于两种结构：

“名称/值”对的集合（A collection of name/value pairs）。不同的语言中，它被理解为对象（object），纪录（record），结构（struct），字典（dictionary），哈希表（hash table），有键列表（keyed list），或者关联数组 （associative array）。 
值的有序列表（An ordered list of values）。在大部分语言中，它被理解为数组（array）。 
这些都是常见的数据结构。事实上大部分现代计算机语言都以某种形式支持它们。这使得一种数据格式在同样基于这些结构的编程语言之间交换成为可能。

jso官方说明参见：http://json.org/

Python操作json的标准api库参考：http://docs.Python.org/library/json.html

对简单数据类型的encoding 和 decoding：

使用简单的json.dumps方法对简单数据类型进行编码，例如：

    import json
    obj = [[1,2,3],123,123.123,'abc',{'key1':(1,2,3),'key2':(4,5,6)}]
    encodedjson = json.dumps(obj)
    print repr(obj)
    print encodedjson

输出：

[[1, 2, 3], 123, 123.123, 'abc', {'key2': (4, 5, 6), 'key1': (1, 2, 3)}] 
[[1, 2, 3], 123, 123.123, "abc", {"key2": [4, 5, 6], "key1": [1, 2, 3]}]

通过输出的结果可以看出，简单类型通过encode之后跟其原始的repr()输出结果非常相似，但是有些数据类型进行了改变，例如上例中的元组则转换为了列表。在json的编码过程中，会存在从Python原始类型向json类型的转化过程，具体的转化对照如下：

![image](http://images.cnblogs.com/cnblogs_com/coser/201112/201112141621131652.png)

json.dumps()方法返回了一个str对象encodedjson，我们接下来在对encodedjson进行decode，得到原始数据，需要使用的json.loads()函数：

    decodejson = json.loads(encodedjson)
    print type(decodejson)
    print decodejson[4]['key1']
    print decodejson

输出：

    <type 'list'> 
    [1, 2, 3]
    
    [[1, 2, 3], 123, 123.123, u'abc', {u'key2': [4, 5, 6], u'key1': [1, 2, 3]}]

loads方法返回了原始的对象，但是仍然发生了一些数据类型的转化。比如，上例中‘abc’转化为了unicode类型。从json到Python的类型转化对照如下：

![image](http://images.cnblogs.com/cnblogs_com/coser/201112/201112141621146178.png)

json.dumps方法提供了很多好用的参数可供选择，比较常用的有sort_keys（对dict对象进行排序，我们知道默认dict是无序存放的），separators，indent等参数。

排序功能使得存储的数据更加有利于观察，也使得对json输出的对象进行比较，例如：

    data1 = {'b':789,'c':456,'a':123}
    data2 = {'a':123,'b':789,'c':456}
    d1 = json.dumps(data1,sort_keys=True)
    d2 = json.dumps(data2)
    d3 = json.dumps(data2,sort_keys=True)
    print d1
    print d2
    print d3
    print d1==d2
    print d1==d3
输出：

{"a": 123, "b": 789, "c": 456} 
{"a": 123, "c": 456, "b": 789} 
{"a": 123, "b": 789, "c": 456} 
False 
True

上例中，本来data1和data2数据应该是一样的，但是由于dict存储的无序特性，造成两者无法比较。因此两者可以通过排序后的结果进行存储就避免了数据比较不一致的情况发生，但是排序后再进行存储，系统必定要多做一些事情，也一定会因此造成一定的性能消耗，所以适当排序是很重要的。

indent参数是缩进的意思，它可以使得数据存储的格式变得更加优雅。

data1 = {'b':789,'c':456,'a':123}
d1 = json.dumps(data1,sort_keys=True,indent=4)
print d1
输出：

    { 
        "a": 123, 
        "b": 789, 
        "c": 456 
    }

输出的数据被格式化之后，变得可读性更强，但是却是通过增加一些冗余的空白格来进行填充的。json主要是作为一种数据通信的格式存在的，而网络通信是很在乎数据的大小的，无用的空格会占据很多通信带宽，所以适当时候也要对数据进行压缩。separator参数可以起到这样的作用，该参数传递是一个元组，包含分割对象的字符串。

    print 'DATA:', repr(data)
    print 'repr(data)             :', len(repr(data))
    print 'dumps(data)            :', len(json.dumps(data))
    print 'dumps(data, indent=2)  :', len(json.dumps(data, indent=4))
    print 'dumps(data, separators):', len(json.dumps(data, separators=(',',':')))

输出：

    DATA: {'a': 123, 'c': 456, 'b': 789} 
    repr(data)             : 30 
    dumps(data)            : 30 
    dumps(data, indent=2)  : 46 
    dumps(data, separators): 25

通过移除多余的空白符，达到了压缩数据的目的，而且效果还是比较明显的。

另一个比较有用的dumps参数是skipkeys，默认为False。 dumps方法存储dict对象时，key必须是str类型，如果出现了其他类型的话，那么会产生TypeError异常，如果开启该参数，设为True的话，则会比较优雅的过度。

    data = {'b':789,'c':456,(1,2):123}
    print json.dumps(data,skipkeys=True)

输出：

    {"c": 456, "b": 789}

check from here [source](http://www.cnblogs.com/coser/archive/2011/12/14/2287739.html)
