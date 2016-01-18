---
layout: post
title: "重定向mysql查询结果"
description: "重定向mysql查询结果"
category: "Mysql"
tags: [Mysql]
---

<p>mysql 数据重定向</p>

<pre><code>#将所需要的数据重定向到本地。

mysql -h hostIP -P端口 -u用户名 -p密码 -D 数据库 --default-character-set=UTF-8 -N -e "
select * from mytable " &gt; /目录/a.txt

或：

➜  ~  mysql -u root -p -D res -N -e "select * from user" &gt; a.txt
Enter password: 


#或
mysql -h10.10.10.10 -ucrazyant -p123456 -P3306 -Ne "use test; select * from tb_test;" &gt; /tmp/rs.txt

#SQL文件
#小于号表示输入重定向，runsql.sql的文件内容会被发送给mysql的命令，大于号则表示输出重定向，会将命令执行的结果输出到文件；

mysql -h10.10.10.10 -ucrazyant -p123456 -P3306 -N &lt; runsql.sql &gt; /tmp/rs.txt
</code></pre>

<p><strong>其中-Ne是执行这个SQL语句的选项，-N代表输出SQL语句执行结果中不带第一行的字段名称，-e表示要执行SQL语句</strong></p>

<p>总结：</p>

<blockquote>
  <p>1.select into outfile只能在MySQL服务器上执行，客户端上无法执行；</p>
  
  <p>2.mysql -Ne “sql” > rs.txt可以将SQL语句执行后输出为文件</p>
  
  <p>3.mysql -N &lt; runsql.sql > rs.txt可以执行sql文件中的内容，然后将结果输出到文件；</p>
  
  <p>4.mysql -N的选项，表示输出时不带表头</p>
</blockquote>

<p>参考：<a href="http://www.crazyant.net/1587.html">MySQL执行Select语句将结果导出到文件的方法</a></p>
