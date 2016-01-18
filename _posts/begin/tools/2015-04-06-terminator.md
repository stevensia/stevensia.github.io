---
layout: post
title: "terminator使用与配置"
description: "terminator使用与配置"
category: "linux"
tags: [linux服务器]
---
<h1>一.安装与配置</h1>

<p><img src="http://blog.nicolargo.com/wp-content/uploads/2012/04/capture_001-580x370.png" alt="" /></p>

<p>图片来源:http://blog.nicolargo.com/wp-content/uploads/2012/04/capture_001-580x370.png</p>

<p>terminator['tɜ:mɪneɪtə']翻译为:"终结者",一款不错的多窗口终端工具.</p>

<pre><code>sudo apt-get install terminator
</code></pre>

<p>安装后可配置让其尽量美化些,terminator配置文件在~/.config/terminator/config 可以通过这个配置文件配置terminator的字体和颜色.</p>

<pre><code>font = Monaco 10  #设置体字
background_color = "#204070" # 背景颜色
foreground_color = "#F0F0F0" # 字体颜色
cursor_blink = True          # 设置光标
scrollbar_position = disabled # 禁用滚动条
titlebars = no # 禁用标题栏
background_darkness = 0.4
background_type = transparent # 背景类型可以设置为图片
</code></pre>

<p>更多配置见:<code>man terminator_config</code></p>

<!--more-->

<h1>二.快捷键</h1>

<p>Ctrl+Shift+E 垂直分割窗口</p>

<p>Ctrl+Shift+O 水平分割窗口</p>

<p>F11 全屏</p>

<p>Ctrl+Shift+C 复制</p>

<p>Ctrl+Shift+V 粘贴</p>

<p>Ctrl+Shift+N 或者 Ctrl+Tab 在分割的各窗口之间切换</p>

<p>Ctrl+Shift+X 将分割的某一个窗口放大至全屏使用</p>

<p>Ctrl+Shift+Z 从放大至全屏的某一窗口回到多窗格界面</p>

<h1>三.分享一个不错的配置</h1>

<pre><code>[global_config]
  title_transmit_bg_color = "#d30102"
  focus = system
  suppress_multiple_term_dialog = True
[keybindings]
[profiles]
  [[default]]
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    copy_on_selection = True
    background_image = None
    background_darkness = 0.85
    background_type = transparent
    use_system_font = False
    cursor_color = "#eee8d5"
    foreground_color = "#839496"
    show_titlebar = False
    font = Ubuntu Mono 14
    background_color = "#002b36"
  [[solarized-dark]]
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    background_color = "#002b36"
    background_image = None
    cursor_color = "#eee8d5"
    foreground_color = "#839496"
  [[solarized-light]]
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    background_color = "#fdf6e3"
    background_image = None
    cursor_color = "#002b36"
    foreground_color = "#657b83"
[layouts]
  [[default]]
    [[[child1]]]
      type = Terminal
      parent = window0
      profile = default
    [[[window0]]]
      type = Window
      parent = ""
[plugins]
</code></pre>

<p>透明高亮很Geek.</p>
