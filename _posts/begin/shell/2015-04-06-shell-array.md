---
layout: post
title: "shell数组"
description: "shell数组"
category: "Shell"
tags: [Shell]
---

<p>shell array.分为基础数组和关联数组,基础数组就是只能以整数为索引,关联数组则可以用字符串为索引.注意点,shell中数组元素可不是以<code>,</code>分割,而是<code></code>空格分割.</p>

<!--more-->

<h1>一.基础数组</h1>

<p>基础数组比较简单,这里就以代码形式展现吧.</p>

<pre><code>#!/bin/bash
#type1
array_var=(1 2 3 4 5 6)

#type2
array_foo[0]='My'
array_foo[1]='name'
array_foo[2]='is'
array_foo[3]='Jack'

#specify elem
echo ${array_var[0]}  #1
echo ${array_var}     #1
index=3
echo ${array_foo[$index]} #Jack

#print all elem
echo ${array_var[*]}
echo ${array_foo[@]}

#print length
echo ${#array_var[*]}
echo ${#array_foo[@]}
</code></pre>

<h1>二.关联数组</h1>

<p>关联数组要先定义,在Bash4.0版本后才被引用</p>

<pre><code>declare -A ass_array
</code></pre>

<p>声明后以两种方式添加元素</p>

<pre><code>#方式1
ass_array=([index1]=var1 [index2]=var2 ...)

#方式2
ass_array[index1]=var1
ass_array[index2]=var2
</code></pre>

<p>实例展示如下:</p>

<pre><code>#!/bin/bash 
declare -A values
values=([name]='beginman' [age]=23 [like]='coding')
echo ${values[*]}    # 输出 coding beignman 23

echo "My name is ${values[name]}, i am ${values[age]} years old and like ${values[like]}"
# 输出 My name is beginman, i am 23 years old and like coding

#获取索引列表, 只能对于关联数组
echo ${!values[*]} 
echo ${!values[@]}
# 输出 like name age
</code></pre>
