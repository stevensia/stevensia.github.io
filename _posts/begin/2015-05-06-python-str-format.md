---
layout: post
title: "python格式化字符串小结"
description: "python格式化字符串小结"
category: "Python"
tags: [Python]
---
<h2>方式1.%</h2>

<p><strong>使用<code>%</code>格式符为真实值预留位置，呈现格式</strong>。格式符如下所示：</p>

<pre><code>%s    字符串 (采用str()的显示)
%r    字符串 (采用repr()的显示)
%c    单个字符
%b    二进制整数
%d    十进制整数
%i    十进制整数
%o    八进制整数
%x    十六进制整数
%e    指数 (基底写为e)
%E    指数 (基底写为E)
%f    浮点数
%F    浮点数，与上相同
%g    指数(e)或浮点数 (根据显示长度)
%G    指数(E)或浮点数 (根据显示长度)

%%    字符"%"
</code></pre>

<p>语法如下：</p>

<pre><code>%[(name)][flags][width].[precision]typecode
</code></pre>

<!--more-->

<ol>
<li><p>(name)为命名</p></li>
<li><p>flags为装换标记，可以是<code>+</code>,<code>-</code>,<code>' '</code>或<code>0</code>。<code>+</code>表示右对齐。<code>-</code>表示左对齐。<code>' '</code>为一个空格，<strong>表示在正数的左侧填充一个空格，从而与负数对齐。0表示使用0填充。</strong></p></li>
<li><p>width表示显示宽度</p></li>
<li><p>precision表示小数点后精度</p></li>
</ol>

<p>实例如下：</p>

<pre><code>&gt;&gt;&gt;print "your score is %06.1f" % 9.5
    your score is 0009.5

&gt;&gt;&gt;print "%03d" % 1 # 0表示用0填充，3表示宽度为3
001

&gt;&gt;&gt;print("%6.3f" % 2.3)     # 宽度6 ，保留小数点后3位，此时用''填充
2.300

&gt;&gt;&gt;print("%06.3f" % 2.3)    #宽度6 保留小数点后3位，此时用0填充
02.300
</code></pre>

<p><strong>还可以用字典的形式，<code>%(key)typecode</code></strong>,如下：</p>

<pre><code>&gt;&gt;&gt; dic_format_str = {'name':'beginman','age':24}
&gt;&gt;&gt; print "my name is %(name)s ,i am %(age)d year old" % dic_format_str
my name is beginman ,i am 24 year old
</code></pre>

<h2>format()函数</h2>

<p>如下实例：</p>

<h3>1.通过位置符号</h3>

<p>通过位置符号，0表示format第一个参数，1表示第二个参数，以此类推</p>

<pre><code>&gt;&gt;&gt;print "number {0:,} in hex is:{0:#x},the number {1} in oct is {1:#o}".format(4746, 45)
&gt;&gt;&gt;print "the number{0} is {0:0.3f}, not equal number:{1}".format(12.3,12)

#输出：
number 4,746 in hex is:0x128a,the number 45 in oct is 0o55
the number12.3 is 12.300, not equal number:12
</code></pre>

<p>注意：</p>

<ol>
<li>以花括号<code>{}</code>包起</li>
<li>{num}表示位置符号</li>
<li><code>:</code>冒号代表对元素的操作，如":.3"小数点三位, ":8"占8个字符空间等</li>
</ol>

<p><code>:</code>的形式如下：</p>

<pre><code>'b' - 二进制. 将数字以2为基数进行输出.
'c' - 字符. 在打印之前将整数转换成对应的Unicode字符串.
'd' - 十进制整数. 将数字以10为基数进行输出.
'o' - 八进制. 将数字以8为基数进行输出. 
'x' - 十六进制. 将数字以16为基数进行输出, 9以上的位数用小写字母.
'e' - 幂符号. 用科学计数法打印数字, 用'e'表示幂. 
'g' - 一般格式. 将数值以fixed-point格式输出. 当数值特别大的时候, 用幂形式打印. 
'n' - 数字. 当值为整数时和'd'相同, 值为浮点数时和'g'相同. 不同的是它会根据区域设置插入数字分隔符. 
'%' - 百分数. 将数值乘以100然后以fixed-point('f')格式打印, 值后面会有一个百分号. 
</code></pre>

<h3>2.通过名称</h3>

<pre><code>&gt;&gt;&gt;print "the number{num1} is {num1:0.3f}, not equal number:{num2}".format(num1=12.3, num2=12)
the number12.3 is 12.300, not equal number:12
</code></pre>

<h3>3.通过属性</h3>

<p><strong>自定义<code>__str__</code>方法，通过<code>str()函数返回格式化的结果</code></strong></p>

<pre><code>class Cus(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def __str__(self):
        return 'my name is {self.name},{self.age:#o} year old'.format(self=self)



print str(Cus('beginman',24))
#my name is beginman,0o30 year old
</code></pre>

<h3>4.使用元祖</h3>

<pre><code>print "{0[0]} * {0[1]} * {1[0]}".format((100,200),(1,2))
#{0}表示第一个参数(100,200),{0[0]}则表示第一个参数(元祖)的下标0

#输出
100 * 200 * 1
</code></pre>

<h2>取舍</h2>

<ol>
<li>在较为简单的格式化中可使用%</li>
<li>推荐使用format,且会慢慢取代%</li>
<li>使用format更加方便灵活</li>
</ol>

<h2>注意事项</h2>

<p>1.关于mysql中<code>%</code>的使用，如mysql <code>in</code>操作，这里可参考<a href="http://beginman.cn/python/2015/05/06/python-mysql-in/"><strong>python mysql in % 遇到的坑</strong></a>
2.注意元祖的使用</p>

<pre><code>tup = (123,21,34)
print "%s" %(tup)   # TypeError: not all arguments converted during string formatting
print "%s" %(tup,)    #注意后面的逗号, (123, 21, 34)
print '{}'.format(tup)  # 使用format不会出现错误，(123, 21, 34)
</code></pre>
