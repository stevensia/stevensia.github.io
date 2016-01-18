---
layout: post
title: "mysql备份策略"
description: "mysql备份策略"
category: "mysql"
tags: [备份]
---

<h2>1&#46;备份的种类</h2>

<ol>
<li>完全备份,就是备份整个数据库对象</li>
<li>事务日志备份， 备份事务日志记录上一次的数据库改变</li>
<li>增量备份，也叫差异备份</li>
<li>文件备份</li>
</ol>

<h2>2&#46;备份方式</h2>

<ol>
<li>逻辑备份， 既备份sql语句，使用mysql自带的mysqldump工具进行备份。备份成sql文件形式</li>
<li>物理备份， 备份数据库文件</li>
</ol>

<p>两种备份方式的比较：参考<strong><a href="http://www.cnblogs.com/wangtao_20/p/3304633.html">MYSQL自动备份策略的选择与实践</a></strong></p>

<h2>3&#46;备份工具</h2>

<h3>1&#46;mysqldump</h3>

<p>mysqldump是mysql自带的备份工具，属于逻辑备份支持<code>innodb的热备份</code>，备份速度慢，适用于备份数据量小的场景。</p>

<p><strong>对myisam存储引擎的表，只能使用温备份，这个时候要防止数据的写入，所以先加上读锁， --lock-all-tables</strong></p>

<pre><code>mysqldump --databases test --lock-all-tables --flush-logs &gt; /tmp/backup_test_`date+%F-%H-%M`.sql
</code></pre>

<p><strong>innodb存储引擎表，可以热备，不必对数据库进行加锁的操作，加一个选项可以进行热备份，--single-transaction</strong></p>

<pre><code>mysqldump --databases test --single-transaction --flush-logs--master-data=2&gt; /tmp/backup_test_`date +%F-%H-%M`.sql
</code></pre>

<p><strong>更多mysqldump命令，参考<a href="http://segmentfault.com/a/1190000002428533">MySQL备份命令mysqldump参数说明与示例</a></strong></p>

<h3>2&#46;基于LVM快照备份</h3>

<p>物理备份方式</p>

<ol>
<li>基于文件系统的物理备份（LVM的快照）</li>
<li>tar之类的命令对整个数据库目录进行打包备份</li>
</ol>

<p><strong>备份的流程都是遵循以下：</strong></p>

<ol>
<li>开启窗口1，临时锁所有表， mysql> flush tables with read lock; 可以在mysql中使用 show master status; 查看状态， <strong>注意这个窗口不能关闭，直到所有备份完成之后才能关闭</strong></li>
<li>开启窗口2，tar备份数据库文件， tar -zcvf mysqla1.tar.gz mydata</li>
<li>备份完成，切换窗口1进行解锁， mysql> unlocktables; </li>
</ol>

<p>更多参考：<a href="http://blog.itpub.net/18841027/viewspace-1465334">MySQL 数据库备份种类以及常用备份工具汇总</a></p>

<h2>4&#46;个人方案</h2>

<p>每晚凌晨3点mysqldump备份数据库</p>

<pre><code>#加入定时计划
* 03 * * * /root/mytools/mysqlback.sh
</code></pre>

<p>脚本如下：</p>

<pre><code>[shell]
DB_NAME="res" 
DB_USER="root" 
DB_PASS="****" 
BIN_DIR="/usr/bin/" # mysqldump命令所在路径 
BACK_DIR="/data/backdata" # 备份工具的路径 
DATE="mysql-`date +'%Y%m%d-%H:%M:%S'`" 
LogFile="$BACK_DIR"/dbbakup.log # 日志记录保存的目录 
BackNewFile=$DATE.sql

$BIN_DIR/mysqldump --opt --force -u$DB_USER  -p$DB_PASS $DB_NAME &gt; $BACK_DIR/$DATE.sql
echo -----------------------"$(date +"%y-%m-%d %H:%M:%S")"----------------------- &gt;&gt; $LogFile
echo  createFile:"$BackNewFile" &gt;&gt; $LogFile
#-ctime表示创建时间，这里表示删除创建时间为多少天之前的文件，也就是结果只保留多少天的数据
find "/data/backdata/" -ctime +7 -type f -name "*.sql" -print &gt; deleted.txt
echo -e "delete files:\n" &gt;&gt; $LogFile
#循环删除匹配到的文件
cat deleted.txt | while read LINE
do
    rm -rf $LINE
    echo $LINE&gt;&gt; $LogFile
done

echo "---------------------------------------------------------------" &gt;&gt; $LogFile
[/shell]
</code></pre>
