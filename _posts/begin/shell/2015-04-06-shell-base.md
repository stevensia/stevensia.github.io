---
layout: post
title: "shell算术运算汇总"
description: "shell算术运算汇总"
category: "Shell"
tags: [Shell]
---

<p>在shell中,所有变量都是字符串形式,不能直接进行算术运算,<strong>可利用<code>let</code>, <code>(())</code>, <code>[]</code>执行基本的算术操作,<code>expr</code>,<code>bc</code>执行高级的算术运算</strong>.</p>

<!--more-->

<h1>一.let</h1>

<p>使用let 变量无需在添加$前缀</p>

<pre><code>a=4;
b=5;
let result=a+b
echo $result

let a++
echo $a

let a--
echo $a

let a+=100
echo $a
</code></pre>

<h1>二.$[ operation ]</h1>

<p>在引用变量的时候，可以在变量名前面加"$"符号，也可以不加。</p>

<pre><code>r=$[a+b]
r1=$[$a+100]
</code></pre>

<h1>三.$(( operation  ))</h1>

<p>形式同上.</p>

<pre><code>r2=$((a+b))
</code></pre>

<h1>四.expr</h1>

<p>expr使用是要注意格式,空格隔开</p>

<pre><code>r3=`expr 4 + 100`  # 格式要留有空格
r4=$(expr $a + 1)
</code></pre>

<h1>五.bc</h1>

<p><strong>注意:上述都不能用于浮点数计算,可以使用bc工具.</strong></p>

<pre><code>[beginman@beginman]$ echo "4 * 0.56"
4 * 0.56
[beginman@beginman]$ echo "4 * 0.56"|bc
2.24
</code></pre>

<h1>六.精度,二进制,平方,平方根</h1>

<pre><code>#scale设定小数精度
echo "scale=2; 8/3"|bc  #2.66

#obase转换二进制
n=100
echo "obase=2; $n"|bc   #1100100
n=1010
echo "obase=10;ibase=2; $n"|bc   #10

#平方及平方根
echo "sqrt(100)"|bc   #10
echo "10^2"|bc        #100
</code></pre>

<h1>七.实例:99乘法</h1>

<pre><code>#!/bin/bash
#shell 版本99乘法口诀
for((i=1;i&lt;10;i++))
   do
        for((j=1;j&lt;=i;j++))
        do
        echo -n $j*$i=$(($i*$j)) " "
          if [ $j -eq $i ];then
            echo
          fi
        done
done

1*1=1  
1*2=2  2*2=4  
1*3=3  2*3=6  3*3=9  
1*4=4  2*4=8  3*4=12  4*4=16  
1*5=5  2*5=10  3*5=15  4*5=20  5*5=25  
1*6=6  2*6=12  3*6=18  4*6=24  5*6=30  6*6=36  
1*7=7  2*7=14  3*7=21  4*7=28  5*7=35  6*7=42  7*7=49  
1*8=8  2*8=16  3*8=24  4*8=32  5*8=40  6*8=48  7*8=56  8*8=64  
1*9=9  2*9=18  3*9=27  4*9=36  5*9=45  6*9=54  7*9=63  8*9=72  9*9=81  
</code></pre>

<p>其他的算术运算还有<code>awk</code>,<code>sed</code></p>

<p>参考&lt;<linux shell脚本攻略>></p>
