---
layout: post
title: "nodejs版本升级"
description: "nodejs版本升级"
category: "nodeJs"
tags: [nodeJs]
---

<p>node的<code>n</code>模块是专门用来管理node.js的版本。</p>

<p>全局安装n模块：</p>

<pre><code>npm install -g n
</code></pre>

<p>然后升级node.js到最新稳定版</p>

<pre><code>n stable

# 加版本号
n v0.10.26

#或
n 0.10.26
</code></pre>

<p>终端输入<code>n -h</code> 查看更多命令</p>

<p><code>npm</code>常用命令如下：</p>

<p><code>npm -v</code>:显示版本，检查npm 是否正确安装。</p>

<p><code>npm install express</code>:安装express模块</p>

<p><code>npm install -g express</code>:全局安装express模块</p>

<p><code>npm list</code> :列出已安装模块</p>

<p><code>npm show express</code> :显示模块详情</p>

<p><code>npm update</code> :升级当前目录下的项目的所有模块</p>

<p><code>npm update express</code> :升级当前目录下的项目的指定模块</p>

<p><code>npm update -g express</code>:升级全局安装的express模块</p>

<p><code>npm uninstall express</code> :删除指定的模块</p>
