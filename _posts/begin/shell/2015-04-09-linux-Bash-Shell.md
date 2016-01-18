---
layout: post
title: "linux Bash Shell 快捷键使用"
description: "linux Bash Shell 快捷键使用"
category: "linux"
tags: [linux基础]
---
<h1>Bash Shell 快捷键</h1>

<p>可以查看这里<a href="https://linuxtoy.org/archives/bash-shortcuts.html"><strong>让你提升命令行效率的 Bash 快捷键</strong></a>,但是有一点的上，复制粘贴快捷上面没有，这里补充下：</p>

<!--more-->

<blockquote>
  <p><code>Shift+Ctrl+C</code>:复制当前光标选择的内容</p>
  
  <p><code>Shift+Ctrl+V</code>:粘贴当前光标选择的内容</p>
  
  <p><code>ctrl+u</code>:剪切光标之前的内容，不包括当前字符</p>
  
  <p><code>ctrl+k</code>:剪切光标之后的内容，包括自身</p>
  
  <p><code>ctrl+w</code>:剪切光标之前的一个词</p>
  
  <p><code>alt+d</code>:剪切光标之后的一个词</p>
  
  <p><code>ctrl+y</code>:粘贴当前剪切数据</p>
</blockquote>

<p><strong>重在自己要多加运用，孰能生巧。</strong></p>

<h2>编辑命令</h2>

<blockquote>
  <p>Ctrl + a ：移到命令行首</p>
  
  <p>Ctrl + e ：移到命令行尾</p>
  
  <p>Ctrl + f ：按字符前移（右向）</p>
  
  <p>Ctrl + b ：按字符后移（左向）</p>
  
  <p>Alt + f ：按单词前移（右向）</p>
  
  <p>Alt + b ：按单词后移（左向）</p>
  
  <p>Ctrl + xx：在命令行首和光标之间移动</p>
  
  <p>Ctrl + u ：从光标处删除至命令行首</p>
  
  <p>Ctrl + k ：从光标处删除至命令行尾</p>
  
  <p>Ctrl + w ：从光标处删除至字首</p>
  
  <p>Alt + d ：从光标处删除至字尾</p>
  
  <p>Ctrl + d ：删除光标处的字符</p>
  
  <p>Ctrl + h ：删除光标前的字符</p>
  
  <p>Ctrl + y ：粘贴至光标后</p>
  
  <p>Alt + c ：从光标处更改为首字母大写的单词</p>
  
  <p>Alt + u ：从光标处更改为全部大写的单词</p>
  
  <p>Alt + l ：从光标处更改为全部小写的单词</p>
  
  <p>Ctrl + t ：交换光标处和之前的字符</p>
  
  <p>Alt + t ：交换光标处和之前的单词</p>
  
  <p>Alt + Backspace：与 Ctrl + w 相同类似，分隔符有些差别 [感谢 rezilla 指正]</p>
</blockquote>

<h2>重新执行命令</h2>

<blockquote>
  <p>Ctrl + r：逆向搜索命令历史</p>
  
  <p>Ctrl + g：从历史搜索模式退出</p>
  
  <p>Ctrl + p：历史中的上一条命令</p>
  
  <p>Ctrl + n：历史中的下一条命令</p>
  
  <p>Alt + .：使用上一条命令的最后一个参数</p>
</blockquote>

<h2>控制命令</h2>

<blockquote>
  <p>Ctrl + l：清屏</p>
  
  <p>Ctrl + o：执行当前命令，并选择上一条命令</p>
  
  <p>Ctrl + s：阻止屏幕输出</p>
  
  <p>Ctrl + q：允许屏幕输出</p>
  
  <p>Ctrl + c：终止命令</p>
  
  <p>Ctrl + z：挂起命令</p>
</blockquote>

<h2>Bang (!) 命令</h2>

<blockquote>
  <p>!!：执行上一条命令</p>
  
  <p>!blah：执行最近的以 blah 开头的命令，如 !ls</p>
  
  <p>!blah:p：仅打印输出，而不执行</p>
  
  <p>!$：上一条命令的最后一个参数，与 Alt + . 相同</p>
  
  <p>!$:p：打印输出 !$ 的内容</p>
  
  <p>!*：上一条命令的所有参数</p>
  
  <p>!<em>:p：打印输出 !</em> 的内容</p>
  
  <p>^blah：删除上一条命令中的 blah</p>
  
  <p>^blah^foo：将上一条命令中的 blah 替换为 foo</p>
  
  <p>^blah^foo^：将上一条命令中所有的 blah 都替换为 foo</p>
</blockquote>

<h2>友情提示：</h2>

<p>以上介绍的大多数 Bash 快捷键仅当在 emacs 编辑模式时有效，若你将 Bash 配置为 vi 编辑模式，那将遵循 vi 的按键绑定。Bash 默认为 emacs 编辑模式。如果你的 Bash 不在 emacs 编辑模式，可通过 set -o emacs 设置。
^S、^Q、^C、^Z 是由终端设备处理的，可用 stty 命令设置。</p>

<h2>参考：</h2>

<p><a href="https://linuxtoy.org/archives/bash-shortcuts.html">让你提升命令行效率的 Bash 快捷键 [完整版]</a></p>
