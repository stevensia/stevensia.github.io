---
layout: post
title:  Force tabs to be expanded to spaces
date:   2016-01-23 12:51:52
categories: tools
tags: tools vim
---
:set tabstop=4        " Force tabs to be displayed/expanded to 4 spaces (instead of default 8).
:set softtabstop=4    " Make Vim treat key as 4 spaces, but respect hard Tabs. "   I don't think this one will do what you want.
:set expandtab        " Turn Tab keypresses into spaces. Sounds like this is happening to you. "    You can still insert real Tabs as [Ctrl]-V [Tab].
:set noexpandtab      " Leave Tab keys as real tabs (ASCII 9 character).
:1,$retab!            " Convert all tabs to space or ASCII-9 (per "expandtab"), "   on lines 1_to_end-of-file.
:set shiftwidth=4     " When auto-indenting, indent by this much. "   (Use spaces/tabs per "expandtab".)
:help tabstop         " Find out more about this stuff.
:help vimrc           " Find out more about .vimrc/_vimrc :-) 
[转自](http://hi.baidu.com/flowskyac/blog/item/fe75c8301f343a93a9018e0e.html)

To insert space characters whenever the tab key is pressed, set the 'expandtab' option: 
:set expandtab
With this option set, if you want to enter a real tab character use Ctrl-V<Tab> key sequence. 
To control the number of space characters that will be inserted when the tab key is pressed, set the 'tabstop' option. For example, to insert 4 spaces for a tab, use: 
:set tabstop=4
After the 'expandtab' option is set, all the new tab characters entered will be changed to spaces. This will not affect the existing tab characters. To change all the existing tab characters to match the current tab settings, use: 
:retab
To change the number of space characters inserted for indentation, use the 'shiftwidth' option: 
:set shiftwidth=4
For example, to get the following coding style, 
No tabs in the source file. 
All tab characters are 4 space characters. 
use the following set of options: 
:set tabstop=4
:set shiftwidth=4
:set expandtab
Add the above settings to your vimrc.

Adjusting indent
Since tabs effectively group spaces together, you may be tempted work with tabs than spaces and change individual lines selectively. To easily change a tab-based indent to use spaces instead when 'noexpandtab' is set, you can temporarily set 'expandtab' and use :retab with a range. For example, to convert only the current line to use spaces, use :.retab. 
However, Vim makes working with spaces for indentation just as easy as working with tabs. Just use the < and > operators to quickly indent/de-indent lines or visual selections. 

[转-Converting tabs to spaces](http://vim.wikia.com/wiki/Converting_tabs_to_spaces)
