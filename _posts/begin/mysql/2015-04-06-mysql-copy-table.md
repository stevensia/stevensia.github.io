---
layout: post
title: "mysql copy表或表数据常用的语句整理汇总"
description: "mysql copy表或表数据常用的语句整理汇总"
category: "Mysql"
tags: [Mysql]
---

<p>mysql copy表或表数据常用的语句整理汇总.</p>

<p><img src="http://www.tutorialspoint.com/images/mysql-mini-logo.png" alt="" /></p>

<p>假如我们有以下这样一个表：</p>

<pre><code>id      username    password 
----------------------------------- 
1       admin       ************* 
2       sameer      ************* 
3       stewart     *************

#SQL 
 CREATE TABLE IF NOT EXISTS `admin` (   
`id` int(6) unsigned NOT NULL auto_increment,   
`username` varchar(50) NOT NULL default '',   
`password` varchar(100) default NULL,   
PRIMARY KEY (`id`)   
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;  
</code></pre>

<!--more-->

<h2>1. 下面这个语句会拷贝表结构到新表newadmin中。 （不会拷贝表中的数据）</h2>

<pre><code>CREATE TABLE newadmin LIKE admin 
</code></pre>

<h2>2. 下面这个语句会拷贝数据到新表中。 注意：这个语句其实只是把select语句的结果建一个表。所以newadmin这个表不会有主键，索引。</h2>

<pre><code>CREATE TABLE newadmin AS   
(   
SELECT *  FROM admin   
)  
</code></pre>

<h2>3. 如果你要真正的复制一个表。可以用下面的语句。</h2>

<pre><code>CREATE TABLE newadmin LIKE admin;   

INSERT INTO newadmin SELECT * FROM admin; 
</code></pre>

<h2>4. 我们可以操作不同的数据库。</h2>

<pre><code>CREATE TABLE newadmin LIKE shop.admin;   

CREATE TABLE newshop.newadmin LIKE shop.admin;  
</code></pre>

<h2>5. 我们也可以拷贝一个表中其中的一些字段。</h2>

<pre><code>CREATE TABLE newadmin AS   
(   
SELECT username, password FROM admin   
)  
</code></pre>

<h2>6. 我们也可以将新建的表的字段改名。</h2>

<pre><code>CREATE TABLE newadmin AS   
(   
SELECT id, username AS uname, password AS pass FROM admin   
)
</code></pre>

<h2>7. 我们也可以拷贝一部分数据。</h2>

<pre><code>CREATE TABLE newadmin AS   
(   
SELECT * FROM admin WHERE LEFT(username,1) = 's'   
)     
</code></pre>

<h2>8. 我们也可以在创建表的同时定义表中的字段信息。</h2>

<pre><code>CREATE TABLE newadmin   
(   
id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY   
)   
AS   
(   
SELECT * FROM admin   
)
</code></pre>

<h2>9.MySQL复制表结构及数据到新表</h2>

<pre><code>CREATE TABLE 新表  SELECT * FROM 旧表  
</code></pre>

<h2>10.Mysql只复制表结构不复制数据</h2>

<pre><code>CREATE TABLE 新表
SELECT * FROM 旧表 WHERE 1=2
即:让WHERE条件不成立.
</code></pre>

<h2>11.复制不同结构的表</h2>

<pre><code>create table 新表(字段1,字段2,,,)    SELECT 字段1,字段2... FROM 旧表
</code></pre>

<h2>参考:</h2>

<p><a href="http://database.51cto.com/art/201011/234776.htm">mysql拷贝表的几种方式</a></p>
