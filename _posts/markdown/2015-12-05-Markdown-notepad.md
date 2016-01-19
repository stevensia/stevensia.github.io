---
layout: post
title:  Markdown在Notepad++中的使用体验
date:   2015-12-05 20:14:14
categories: tools
excerpt: 
---
* content
{:toc}

Notepad++本身除了作为一款强大的编辑器外，主要魅力还有由NPP社区和开发人员贡献的种类众多的插件，这些插件几乎可以满足我们各种各样的需求，解决大大小小的问题。找到适合自己的插件，并且灵活使用，将有效提高我们的开发和写作效率。

Notepad++安装插件的两个方法：一个是通过软件自带的Plugin Manager来查找可用插件，勾选安装；还有个就是直接下载插件的dll文件，复制到Notepad++安装目录的plugins目录下，再重启软件即可。

Markdown作为一种日渐流行的轻量级标记语言，日常使用自然是少不了的，而到目前为止，Notepad++上还没有一个称得上完美的方法来支持Markdown，只能自己动手改善，这里总结目前找到的优化Markdown在Notepad++中使用体验的两个方面。

####第一、实现Markdown语法高亮

---
首先下载Markdown规则文件，然后可以通过Notepad++中的 语言 -> 自定义语言格式 -> 导入 来实现；也可以通过手动操作实现，点击 开始菜单 -> 运行(或者直接按 Win+R) -> 输入 %APPDATA%\Notepad++，将userDefineLang.xml放置到此目录（如果已有同名文件存在，则将下载文件的内容增加进去，方法参考[这里](https://github.com/Edditoria/markdown_npp_zenburn)，重启软件。

![示例](http://upload-images.jianshu.io/upload_images/22576-b7b2c862397842c0.jpg?imageMogr2/auto-orient/strip%257CimageView2/2/w/1240)


####第二、实现Markdown实时预览

---
这个比较简单，看这篇文章[写了一个Notepad++的markdown插件](http://blog.gclxry.com/%25E5%2586%2599%25E4%25BA%2586%25E4%25B8%2580%25E4%25B8%25AAnotepad%25E7%259A%2584markdown%25E6%258F%2592%25E4%25BB%25B6/)，下载里面的NppMarkdown插件（也可以下载我备份在百度云的），复制dll到Notepad++安装目录的plugins目录下，重启软件。
[Download](http://pan.baidu.com/s/1c08pOjQ)

![pic2](http://upload-images.jianshu.io/upload_images/22576-b63f4097ad8559ea.jpg?imageMogr2/auto-orient/strip%257CimageView2/2/w/1240)  


**小提示**：Notepad++的AutoSave插件和多列编辑功能（菜单栏 -> 设置 -> 首选项 -> 编辑，勾上右边“多列编辑”的小框）都不错哦。

>原文在[此处](http://xuhehuan.com/2237.html)
