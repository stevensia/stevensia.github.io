---
layout: post
title: "查看mysql数据库和表数据的大小"
description: "查看mysql数据库和表数据的大小"
category: "Mysql"
tags: [Mysql]
---

<h2>information_schema数据库</h2>

<p>information_schema是mysql自带数据库，<strong>提供了访问数据库元数据的方式</strong>， 元数据：关于数据的数据，如库名，表名，列的类型，权限等。</p>

<!--more-->

<pre><code>mysql&gt; user information_schema;
mysql&gt; show tables from information_schema;
+---------------------------------------+
| Tables_in_information_schema |
+---------------------------------------+
| CHARACTER_SETS             |        ###建库或表时可选用的字体都在这里个表里
| COLLATIONS                       |             #####提供了关于各字符集的对照信息
| COLLATION_CHARACTER_SET_APPLICABILITY |       #####指明了可用于校对的字符集。这些列等效于SHOW COLLATION的前两个显示字段。
| COLUMNS                            | ######提供了表中的列信息。详细表述了某张表的所有列以及每个列的信息。
| COLUMN_PRIVILEGES        |      #####列权限
| ENGINES                              | ##### show engines的结果来自这个表
| EVENTS                               | 
| FILES                                   |
| GLOBAL_STATUS               |  #### show global status的结果来自这个表的查询
| GLOBAL_VARIABLES          |   ####mysql全局变量
| KEY_COLUMN_USAGE        |    #####描述了具有约束的键列
| OPTIMIZER_TRACE             |   ###可以控制是否为执行的SQL生成查询计划树，默认关闭，我们也建议关闭，因为它会产生额外的性能开销
| PARAMETERS                     |      #####
| PARTITIONS                        |     ####数据库分区信息
| PLUGINS                              |    ####插件信息
| PROCESSLIST                    |    ####当前mysql正在运行的进程信息
| PROFILING                          |   ###在开启 Query Profiler 功能之后，MySQL 就会自动记录所有执行的 Query 的 profile 信息了
| REFERENTIAL_CONSTRAINTS               |
| ROUTINES                           |  #####提供了关于存储子程序（存储程序和函数）的信息
| SCHEMATA                         |  #####SCHEMATA表：提供了当前mysql实例中所有数据库的信息。是showdatabases的结果取之此表。
| SCHEMA_PRIVILEGES       |######给出了关于方案（数据库）权限的信息
| SESSION_STATUS             |
| SESSION_VARIABLES        |
| STATISTICS                        |     #####提供了关于表索引的信息。是show index from schemaname.tablename的结果取之此表。
| TABLES                              |   ###TABLES表：提供了关于数据库中的表的信息（包括视图）。详细表述了某个表属于哪个schema，表类型，表引擎，创建时间等信息。是show tables from schemaname的结果取之此表。
| TABLESPACES                    |
| TABLE_CONSTRAINTS       |   ####描述了存在约束的表。以及表的约束类型。
| TABLE_PRIVILEGES           |  ###给出了关于表权限的信息
| TRIGGERS                          |   ###记录各表的触发器信息
| USER_PRIVILEGES             | #####给出了关于全程权限的信息。该信息源自mysql.user授权表。
| VIEWS                                 |  ###记录各表的视图信息
| INNODB_LOCKS                 |  ###给出innodb表的锁
| INNODB_TRX                      |
| INNODB_SYS_DATAFILES  |
| INNODB_LOCK_WAITS       |
| INNODB_SYS_TABLESTATS     |
| INNODB_CMP                            |
| INNODB_FT_BEING_DELETED |
| INNODB_CMP_RESET               |
| INNODB_CMP_PER_INDEX        |
| INNODB_CMPMEM_RESET        |
| INNODB_FT_DELETED               |
| INNODB_BUFFER_PAGE_LRU   |
| INNODB_FT_INSERTED              |
| INNODB_CMPMEM                      |
| INNODB_SYS_INDEXES               |
| INNODB_SYS_TABLES               |
| INNODB_SYS_FIELDS                 |
| INNODB_CMP_PER_INDEX_RESET   |
| INNODB_BUFFER_PAGE                    |
| INNODB_FT_DEFAULT_STOPWORD  |
| INNODB_FT_INDEX_TABLE                 |
| INNODB_FT_INDEX_CACHE                |
| INNODB_SYS_TABLESPACES            |
| INNODB_METRICS                              |
| INNODB_SYS_FOREIGN_COLS         |
| INNODB_FT_CONFIG                         |
| INNODB_BUFFER_POOL_STATS      |
| INNODB_SYS_COLUMNS                    |
| INNODB_SYS_FOREIGN                     |
+---------------------------------------+
60 rows in set (0.00 sec)
</code></pre>

<h2>查看数据库大小</h2>

<p>information_schema 数据库中有一个 TABLES 专门记录各个数据库和表的相关信息，主要字段如下：</p>

<p>TABLE_SCHEMA : 数据库名</p>

<p>TABLE_NAME：表名</p>

<p>ENGINE：所使用的存储引擎</p>

<p>TABLES_ROWS：记录数</p>

<p>DATA_LENGTH：数据大小</p>

<p>INDEX_LENGTH：索引大小</p>

<p>通过上面字段信息，我们能查看数据库和表的大小，如下：</p>

<pre><code>#查询所有数据的大小和行号
mysql&gt; select concat(round(sum(DATA_LENGTH/1024/1024), 2), 'MB') as data, TABLE_ROWS from TABLES;
+--------+------------+
| data   | TABLE_ROWS |
+--------+------------+
| 34.00MB |       1289|
.......

#查看指定数据库实例的大小，如blog
mysql&gt; select concat(round(sum(DATA_LENGTH/1024/1024), 2), 'MB') as data from TABLES where table_schema='blog';
+-----------+
| data      |
+-----------+
| 122.32MB |
+-----------+


#查看指定数据库的表的大小，比如说数据库blog中的user表 
mysql&gt; select concat(round(sum(DATA_LENGTH/1024/1024),2),'MB') as data
-&gt; from TABLES where table_schema='blog'
-&gt; and table_name='user';
+--------+
| data   |
+--------+
| 2.52MB |
+--------+
</code></pre>
