---
layout: post
title: "利用mysql information_schema库查询大小"
description: "利用mysql information_schema库查询大小"
category: "Mysql"
tags: [Mysql]
---

<p>information_schema数据库是mysql自带的，对数据库元数据的存储，<strong>元数据是关于数据的数据，如数据库名或表名，列的数据类型，或访问权限等</strong>。INFORMATION_SCHEMA中，有数个只读表。它们实际上是视图，而不是基本表，因此，你将无法看到与之相关的任何文件。</p>

<p><em>information_schema数据库表说明:</em></p>

<p>SCHEMATA表：提供了当前mysql实例中所有数据库的信息。是show databases的结果取之此表。</p>

<p>TABLES表：提供了关于数据库中的表的信息（包括视图）。详细表述了某个表属于哪个schema，表类型，表引擎，创建时间等信息。是show tables from schemaname的结果取之此表。</p>

<p>COLUMNS表：提供了表中的列信息。详细表述了某张表的所有列以及每个列的信息。是show columns from schemaname.tablename的结果取之此表。</p>

<p>STATISTICS表：提供了关于表索引的信息。是show index from schemaname.tablename的结果取之此表。</p>

<p>USER_PRIVILEGES（用户权限）表：给出了关于全程权限的信息。该信息源自mysql.user授权表。是非标准表。</p>

<p>SCHEMA_PRIVILEGES（方案权限）表：给出了关于方案（数据库）权限的信息。该信息来自mysql.db授权表。是非标准表。</p>

<p>TABLE_PRIVILEGES（表权限）表：给出了关于表权限的信息。该信息源自mysql.tables_priv授权表。是非标准表。</p>

<p>COLUMN_PRIVILEGES（列权限）表：给出了关于列权限的信息。该信息源自mysql.columns_priv授权表。是非标准表。</p>

<p>CHARACTER_SETS（字符集）表：提供了mysql实例可用字符集的信息。是SHOW CHARACTER SET结果集取之此表。</p>

<p>COLLATIONS表：提供了关于各字符集的对照信息。</p>

<p>COLLATION_CHARACTER_SET_APPLICABILITY表：指明了可用于校对的字符集。这些列等效于SHOW COLLATION的前两个显示字段。</p>

<p>TABLE_CONSTRAINTS表：描述了存在约束的表。以及表的约束类型。</p>

<p>KEY_COLUMN_USAGE表：描述了具有约束的键列。</p>

<p>ROUTINES表：提供了关于存储子程序（存储程序和函数）的信息。此时，ROUTINES表不包含自定义函数（UDF）。名为“mysql.proc name”的列指明了对应于INFORMATION_SCHEMA.ROUTINES表的mysql.proc表列。</p>

<p>VIEWS表：给出了关于数据库中的视图的信息。需要有show views权限，否则无法查看视图信息。</p>

<p>TRIGGERS表：提供了关于触发程序的信息。必须有super权限才能查看该表</p>

<h2>查数据库，表，数据大小</h2>

<pre><code>select * from information_schema.TABLES 
where information_schema.TABLES.TABLE_SCHEMA='databasename'
and information_schema.TABLES.TABLE_NAME='tablename'\G
</code></pre>

<p>返回结果:</p>

<pre><code>*************************** 1. row ***************************
TABLE_CATALOG: def
 TABLE_SCHEMA: databasename
  TABLE_NAME: tablename
  TABLE_TYPE: BASE TABLE
      ENGINE: MyISAM
     VERSION: 10
  ROW_FORMAT: Dynamic
  TABLE_ROWS: 6422930
  AVG_ROW_LENGTH: 213
  DATA_LENGTH: 1370884700
  MAX_DATA_LENGTH: 281474976710655
  INDEX_LENGTH: 412930048
   DATA_FREE: 0
AUTO_INCREMENT: 6422931
 CREATE_TIME: 2012-05-11 05:00:02
 UPDATE_TIME: 2012-05-22 15:12:06
  CHECK_TIME: 2012-05-11 09:58:52
TABLE_COLLATION: utf8_general_ci
    CHECKSUM: NULL
CREATE_OPTIONS: 
TABLE_COMMENT: 'table comment'

1 row in set (0.00 sec)
</code></pre>

<p>TABLE_ROWS 代表拥有的数据行数。</p>

<p><strong>总大小 = DATA_LENGTH(数据大小) + INDEX_LENGTH(索引大小)</strong></p>

<p>结果以字节为单位，除1024为K，除1048576(=1024*1024)为M。</p>

<p>参考：<a href="http://fukun.org/archives/05222029.html">http://fukun.org/archives/05222029.html</a></p>
