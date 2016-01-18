---
layout: post
title: "Lua 入门"
description: "Lua 入门指南"
category: "lua"
tags: [lua,redis]
---
Lua是高效的轻量级语言，很方便嵌入其他语言中使用,**其设计目的是为了嵌入应用程序中，从而为应用程序提供灵活的扩展和定制功能。**,如redis脚本扩展，nginx扩展等，

![](http://www.runoob.com/wp-content/uploads/2015/05/lua.png)

注意事项：

- Lua是类C的，所以，他是大小写字符敏感
- Lua脚本的语句的分号是可选的
- 单行注释：`--`, 多行注释：`--[[多行注释--]]`
- 在默认情况下，变量总是认为是全局的,访问一个没有初始化的全局变量也不会出错，只不过得到的结果是：`nil`。如果你想删除一个全局变量，只需要将变量赋值为nil
- 

# 一.数据类型
Lua是动态类型语言，变量不要类型定义,只需要为变量赋值。 值可以存储在变量中，作为参数传递或结果返回。

Lua中有8个基本类型分别为：`nil`、`boolean`、`number`、`string`、`userdata`、`function`、`thread`和`table`。

![](http://beginman.qiniudn.com/lua_datatype.png)



