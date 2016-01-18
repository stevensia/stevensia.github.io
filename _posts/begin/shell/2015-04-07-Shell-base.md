---
layout: post
title: "Shell 一小时快速入门"
description: "Shell 一小时快速入门"
category: "Shell"
tags: [Shell]
---
<h1>一.Shell简介</h1>

<h2>1.认识</h2>

<p><img src="http://s6.51cto.com/wyfs01/M00/44/47/wKioOVKysnyy_LZMAABIynSCG1Y538.jpg" alt="" /></p>

<blockquote>
  <p>Unix操作系统下的shell既是用户交互的界面(命令语言)，也是控制系统的脚本语言,Shell本身是一个用C语言编写的程序，它是用户使用Linux的桥梁。当然在这点也有别于Windows下的命令行，虽然也提供了很简单的控制语句。在Windows操作系统下，可能有些用户从来都不会直接的使用shell，然而在Unix系列操作系统下，shell仍然是控制系统启动、X Window启动和很多其他实用工具的脚本解释程序。</p>
</blockquote>

<p><strong>Shell脚本是解释型的，不需要编译，从脚本中一行行的读取并执行命令。</strong></p>

<!--more-->

<h2>2.解释器</h2>

<p>要区分Shell与Shell脚本解释器，Shell是一门脚本语言，而Shell解释器就是shell脚本的实现，linux有好几种Shell解释器但不能说有好几种shell。</p>

<p>Shell解释器有:<code>bash</code>，<code>sh</code>,<code>csh</code>等，linux默认使用<code>bash</code>.</p>

<h2>3.编译型 VS 解释型</h2>

<p><strong>编译型:预先将源代码,转换成目标代码，这个过程称为编译。运行时直接读取目标代码且接近计算机底层，所以其执行较快。由于接近底层所以考虑的因素也多，开发周期长。</strong></p>

<p><strong>解释型：源代码通过解释器转换成字节码，再解释给计算机，由于每次运行都需要编译解释，所以执行效率低，但开发周期短。</strong></p>

<p><img src="http://f.dataguru.cn/farattach/forum/201406/18/1334546u16u7vb61b12rkk.jpg" alt="" /></p>

<p>图片来源(http://f.dataguru.cn/thread-304291-1-1.html)</p>

<h1>2.一个完成的Shell脚本流程</h1>

<p>(1).新建脚本文件以<code>.sh</code>后缀： <code>vim test.sh</code></p>

<p>(2).文件头标明：<code>#!/bin/bas</code></p>

<p>(3).赋予执行权限: <code>chmod +x test.sh</code></p>

<p>(4).执行脚本: <code>./test.sh</code></p>

<p><strong>注意：运行二进制程序，一定要保证有可执行的权限，然后运行的时候一定要以 <code>./executable file</code>，如果写成executable file，则linux会去PATH里寻找有没有对应的文件。如果非要这样写，那么就必须在前面加上PATH环境变量存在的执行程序(解释器参数)，如下：</strong></p>

<pre><code># 运行一个py脚本
[beginman@bm learn]$ ./1.py
bash: ./1.py: 权限不够
[beginman@bm learn]$ chmod +x 1.py
[beginman@bm learn]$ ./1.py
(['123'], 1)
[beginman@bm learn]$ python 1.py    # python已存在PATH中
(['123'], 1)

# 运行一个Shell脚本
[beginman@bm learn]$ ./test.sh 
hello world
[beginman@bm learn]$ /bin/sh test.sh
hello world
[beginman@bm learn]$ /bin/bash test.sh
hello world
</code></pre>

<h2>3.help</h2>

<p>(1).<code>help</code>:能查看所有Shell列表。</p>

<pre><code>[beginman@bm learn]$ help 
.....
</code></pre>

<p>(2).<code>help 名称</code>：查看有关函数名称的更多信息</p>

<pre><code>[beginman@bm learn]$ help for
for: for 名称 [in 词语 ... ] ; do 命令; done
    为列表中的每个成员执行命令。

    `for' 循环为列表中的每个成员执行一系列的命令。如果没有
    `in WORDS ...;'则假定使用 `in "$@"'。对于 WORDS 中的每
     个元素，NAME 被设定为该元素，并且执行 COMMANDS 命令。

    退出状态：
    返回最后执行的命令的状态。    
</code></pre>

<h2>4.注释</h2>

<p>以“#”开头的行就是注释，会被解释器忽略。</p>

<h1>三.变量</h1>

<h2>1.定义变量</h2>

<p>语法：</p>

<pre><code>variableName="value"
</code></pre>

<p>规则：
-- <code>=</code>前后不能有空格
-- 变量名首字符以字母或下划线开头，中间不能有空格</p>

<pre><code>[beginman@bm learn]$ name="jack"
[beginman@bm learn]$ echo $name
jack
[beginman@bm learn]$ __name="jack"
[beginman@bm learn]$ echo $__name
</code></pre>

<p>-- 变量名不能是Shell关键字
-- 大小写敏感
-- 有用户创建的变量和shell专用变量</p>

<h2>2.使用变量</h2>

<p><img src="http://pic002.cnblogs.com/images/2012/397138/2012102200180475.png" alt="" /></p>

<p><img src="http://pic002.cnblogs.com/images/2012/397138/2012102200182063.png" alt="" /></p>

<p><img src="http://pic002.cnblogs.com/images/2012/397138/2012102200184126.png" alt="" /></p>

<h2>3.环境变量</h2>

<p>环境变量的定义方法如下：</p>

<pre><code>var=value
export var
</code></pre>

<p>shell在初始化的时候会在执行profile等初始化脚本，脚本中定义了一些环境变量，这些变量会在创建子进程时传递给子进程,用<code>env</code>命令可以查看当前的环境变量。</p>

<h2>4.数值变量</h2>

<p>shell中默认把变量值当作字符串如：</p>

<pre><code>[beginman@bm learn]$ num=1
[beginman@bm learn]$ num=$num+1
[beginman@bm learn]$ echo $num
1+1
</code></pre>

<p>返回的是'1'+'1'并不是 2，使用<code>let</code>命令进行数学运算：</p>

<pre><code>[beginman@bm learn]$ num=1
[beginman@bm learn]$ let num=$num+1
[beginman@bm learn]$ echo $num
2
</code></pre>

<blockquote>
  <p>bash中执行整数算术运算的命令是let; 其语法格式为：<code>let arg ....</code></p>
  
  <p>其中，arg是单独的算术表达式。这里的算术表达式使用C语言中表达式的语法、优先级和结合性。除++、--和逗号(，)之外，所有整型运算符都得到支持。此外，还提供了方幂运算符“**”。命名的参数可以在算术表达式中直接利用名称访问，不要前面带有“$”符号。当访问命名参数时，就作为算术表达式计算它的值。算术表达式按长整数进行求值，并且不检查溢出。当然，用0作除数就产生错误。 参考<a href="http://www.douban.com/group/topic/2825821/">shell let 算术运算</a></p>
</blockquote>

<pre><code>[beginman@bm learn]$ let a=5+3 b=9-5
[beginman@bm learn]$ echo $a $b
8 4

[beginman@bm learn]$ b=5
[beginman@bm learn]$ let "t1 = ((a = 5 + 3, b = 7 - 1, c = 15 - 4))"
[beginman@bm learn]$ echo "t1 = $t1, a = $a, b = $b"
t1 = 11, a = 8, b = 6

[beginman@bm learn]$ a=10
[beginman@bm learn]$ let x=a++ y=a-- z=a**2
[beginman@bm learn]$ echo $x $y $z
10 11 100
</code></pre>

<p>或者使用<code>declare -i</code>命令将字符型变量转换成整型</p>

<pre><code>[beginman@bm learn]$ declare -i num=1
[beginman@bm learn]$ num=$num+1
[beginman@bm learn]$ echo $num
2
</code></pre>

<h2>5.特殊变量名</h2>

<p>(1).<code>$0</code>：当前脚本的文件名,在shell命令行下则显示/bin/bash</p>

<pre><code>[beginman@bm learn]$ echo $0
/bin/bash
</code></pre>

<p>(2).<code>$num</code>：num为从1开始的数字，$1是第一个参数，$2是第二个参数，${10}是第十个参数</p>

<p>(3).<code>$#</code>：传入脚本的参数的个数</p>

<p>(4).<code>$*</code>：所有的位置参数(作为单个字符串)</p>

<p>(5).<code>$@</code>：所有的位置参数(每个都作为独立的字符串)。</p>

<p>(6).<code>$?</code>：当前shell进程中，上一个命令的返回值，如果上一个命令成功执行则$?的值为0，否则为其他非零值，常用做if语句条件</p>

<p>(7).<code>$$</code>：当前shell进程的pid</p>

<p>(8).<code>$!</code>：后台运行的最后一个进程的pid</p>

<p>(9).<code>$-</code>：显示shell使用的当前选项</p>

<p>(10).<code>$_</code>：之前命令的最后一个参数</p>

<h1>三.数组</h1>

<p>bash支持一维数组（不支持多维数组），类C，下标从0开始。</p>

<h2>1.定义数组</h2>

<h3>(1).方式1：</h3>

<pre><code># ()界定，元素用空格隔开
array=(value1 value2 value3 ... valueN)  
可写成：
array=(
    value0
    value1
    value2
    ...
    valueN
)
</code></pre>

<h3>(2).方式2：</h3>

<pre><code># 单个
array[0]=value1
array[1]=value2
array[2]=value3
....
array[n]=valueN
</code></pre>

<h2>2.读取数组</h2>

<pre><code>value=${array[index]}  # 读取索引为index的单个元素

value=${array[@]} #读取所有

value=${array[*]}  # 读取所有

count=${#array[*]}  # 数组的元素个数

value=${array[*]:0:2}   # 第一个和第二个元素组成的串，0表示开始的位置，2表示要返回的元素个数，开始位置可以为0-2(0减去2)之类的，表示从倒数第二个元素开始。
</code></pre>

<h2>3.实战</h2>

<p>编写一个简单的shell脚本用于创建并输出数组</p>

<pre><code>#!/bin/bash 
for ((i=0; i&lt;10; i++)) do
    array[$i]=$i
done
echo "输出元素……"
for ((i=0; i&lt;10; i++)) do
    echo ${array[$i]}

# 运行结果：
[beginman@bm learn]$ ./test.sh 
输出元素……
0
1
2
3
4
5
6
7
8
9
</code></pre>

<h1>四.test命令</h1>

<p><code>test</code> 命令用于检查某个条件是否成立，它可以进行数值、字符和文件三个方面的测试。</p>

<h2>1.数值测试</h2>

<h3>(1). <code>-eq</code>:等于则为真</h3>

<pre><code>#!/bin/bash
a=1 b=1
if test $a -eq $b 
then
    echo "等于"
else
    echo "不等于"
</code></pre>

<h3>(2).<code>-ne</code>: not equal不等于则为真</h3>

<h3>(3).<code>-gt</code>: great than 大于则为真</h3>

<h3>(4).<code>-ge</code>: great equal 大于等于则为真</h3>

<h3>(5).<code>-lt</code>: less than 小于则为真</h3>

<h3>(6).<code>-le</code>: less equal 小于等于则为真</h3>

<h2>2.字符串测试</h2>

<h3>(1).<code>=</code> : test str1 = str2 判定 str1 是否等于 str2 ，若相等，则回传 true</h3>

<h3>(2).<code>!=</code> : test str1 != str2 判定 str1 是否不等于 str2 ，若相等，则回传 false</h3>

<h3>(3).<code>-z string</code> : test -z string 判定字符串是否为 0 ？若 string 为空字符串，则为 true</h3>

<h3>(4).<code>-n string</code>：test -n string 判定字符串是否非为 0 ？若 string 为空字符串，则为 false。</h3>

<p>注： -n 亦可省略</p>

<h2>3.文件测试</h2>

<p><code>-e 文件名</code>     如果文件存在则为真</p>

<p><code>-r 文件名</code>     如果文件存在且可读则为真</p>

<p><code>-w 文件名</code>     如果文件存在且可写则为真</p>

<p><code>-x 文件名</code>     如果文件存在且可执行则为真</p>

<p><code>-s 文件名</code>     如果文件存在且至少有一个字符则为真</p>

<p><code>-d 文件名</code>     如果文件存在且为目录则为真</p>

<p><code>-f 文件名</code>     如果文件存在且为普通文件则为真</p>

<p><code>-c 文件名</code>     如果文件存在且为字符型特殊文件则为真</p>

<p><code>-b 文件名</code>     如果文件存在且为块特殊文件则为真</p>

<p>更多内容参考:<a href="http://bhanv.blog.51cto.com/729282/285104">Linux的 test 命令使用</a></p>

<h1>五.if else语句</h1>

<h2>if else 语法：</h2>

<pre><code>if condition
then
    doSomething
else
    doOtherthing
fi
</code></pre>

<h2>if else-if else 语法：</h2>

<pre><code>if condition1
then
    command1
elif condition2
    command2
else
    commandN
fi
</code></pre>

<h2>单行</h2>

<pre><code>if test -e 1.py; then echo "ok"; else "none"; fi; 
</code></pre>

<h1>六.case语句</h1>

<h2>1.语法</h2>

<pre><code> case "$variable" in

    "$condition1" )
    command...
    ;;

    "$condition2" )
    command...
    ;;
    *)
     默认
    ;;
esac    
</code></pre>

<h2>2.注意</h2>

<blockquote>
  <p>(1).取值后面必须为单词in</p>
  
  <p>(2).对变量使用""并不是强制的, 因为不会发生单词分割.</p>
  
  <p>(3).每一模式必须以右括<code>)</code>号结束</p>
  
  <p>(4).每个条件判断语句块都以一对分号结尾 <code>;;</code></p>
  
  <p>(5).<code>*</code>表示无一匹配模式的默认</p>
  
  <p>(6).case块以esac (case的反向拼写)结尾</p>
</blockquote>

<h2>3.实战</h2>

<h3>1.检验输入</h3>

<pre><code>#!/bin/bash
echo "you number(1-4) is:\c "
read aNum
case $aNum in
    1) echo "select 1"
    ;;
    2) echo "select 2"
    ;;
    3) echo "select 3"
    ;;
    *) echo "between 1 to 3"
    ;;
esac
</code></pre>

<p>更多例子参考：<a href="http://hlee.iteye.com/blog/577628">shell脚本和case 使用相关的例子</a></p>

<h1>七. for循环</h1>

<h2>1.语法</h2>

<pre><code>for 变量名 in 列表
do
    command1
    command2
    ...
    commandN
done
</code></pre>

<p>如：</p>

<pre><code>[beginman@bm learn]$ for loop in 1 2 3 4 5;do echo "Value is $loop";done;
Value is 1
Value is 2
Value is 3
Value is 4
Value is 5

[beginman@bm learn]$ for loop in "hello world";do echo "$loop";done;
hello world
</code></pre>

<h1>八. while循环</h1>

<h2>1.语法</h2>

<pre><code>while 命令
do
    command1
    command2
    ...
    commandN
done
</code></pre>

<p>如：</p>

<pre><code>#!/bin/bash 
num=0
while [ $num -lt 5 ]
do
    let num++
    echo $num
done
</code></pre>

<h1>九.until循环</h1>

<p><code>until</code>与<code>while</code>相反，while是当条件为真执行否则就不执行，而untile是当条件为真才停止执行。</p>

<h2>1.语法</h2>

<pre><code>until 条件
    command1
    command2
    ...
    commandN
done    
</code></pre>

<p>如：</p>

<pre><code>  #!/bin/bash 
    num=0
    until [ $num -gt 5 ]
    do
        let num++
        echo $num
    done
    # 输出 1到6
</code></pre>

<h1>十.break和continue命令</h1>

<p>同C语言，break命令允许跳出所有循环（终止执行后面的所有循环）;continue命令仅仅跳出当前循环.例子参考这里<a href="http://see.xidian.edu.cn/cpp/view/7010.html">http://see.xidian.edu.cn/cpp/view/7010.html</a></p>

<h1>十一.函数</h1>

<p>Shell函数就是将一系列命令包装起来，方便重用或阅读。</p>

<h2>1.语法</h2>

<pre><code>[function] 函数名(){
    command1
    command2
    ...
    commandN
    [ return value ]
}
</code></pre>

<p><code>function</code>和<code>return</code>可有可无，如果不写<code>return</code>则返回最后一条命令运行结果一般为0，如果执行失败则返回错误代码。如</p>

<h2>2.使用</h2>

<p>(1).<strong>函数的调用 可以直接写函数名</strong> ,如:</p>

<pre><code>#!/bin/bash  
#!/bin/bash
function demoFun(){
     echo "hello world"
}
demoFun
# 运行脚本输出hello world
</code></pre>

<p>(2).**函数返回值在调用该函数后通过 <code>$?</code> 来获得。 **</p>

<pre><code>#!/bin/bash  
#!/bin/bash
function demoFun(){
    a=1;b=2
    return $(($a+$b))
}
demoFun
echo "function result:$?"
# 运行脚本输出3
</code></pre>

<h2>3.传参</h2>

<p><strong><code>$n</code> 的形式来获取参数的值，当n>10 则用${n}来获取参数，更多参数见上面（二之2.5：特殊变量名）</strong></p>

<pre><code>#!/bin/bash  
#!/bin/bash
function demoFun(){
    echo $1 $2 $5 $11
}
demoFun 1 2 3 4 5 6 7 8 9 10 11 12
# 执行脚本输出 1 2 5 11
</code></pre>

<h1>十二.学习资源</h1>

<p><a href="http://bbs.chinaunix.net/forum-24-1.html">1.ChinaUinx Shell 论坛</a></p>

<p><a href="http://kodango.com/useful-documents-about-shell">2.学习Shell的一些实用资料</a></p>

<p><a href="http://www.linuxeden.com/forum/index.php">3.Linux伊甸园论坛</a></p>

<h1>十三.参考</h1>

<p><a href="http://zh.wikipedia.org/wiki/Unix_shell">1.Unix shell</a></p>

<p><a href="http://see.xidian.edu.cn/cpp/shell/">2.Linux Shell脚本教程：30分钟玩转Shell脚本编程</a></p>

<p><a href="http://www.cnblogs.com/barrychiao/archive/2012/10/22/2733210.html">3.shell变量详解</a></p>
