---
layout: post
title: "Python操作与监控Redis"
description: "Python操作与监控Redis"
category: "redis"
tags: [redis]
---

<h2>一.安装配置Redis</h2>

<p>参考：<a href="http://blog.beginman.cn/blog/67/">http://blog.beginman.cn/blog/67/</a></p>

<h2>二.supervisor控制Redis进程</h2>

<pre><code>[program:redis]
command=/usr/local/bin/redis-server
autorestart=true
</code></pre>

<!--more-->

<h2>三.python操作redis</h2>

<h3>1.安装 redis-py</h3>

<p><a href="https://redis-py.readthedocs.org/en/latest/"><strong>文档地址</strong></a></p>

<p>redis-py提供两个类Redis和StrictRedis用于实现Redis的命令，StrictRedis用于实现大部分官方的命令，并使用官方的语法和命令（比如，SET命令对应与StrictRedis.set方法）。Redis是StrictRedis的子类，用于向后兼容旧版本的redis-py。</p>

<pre><code>&gt;&gt;&gt; import redis
&gt;&gt;&gt; r = redis.StrictRedis()
&gt;&gt;&gt; r
StrictRedis&lt;ConnectionPool&lt;Connection&lt;host=localhost,port=6379,db=0&gt;&gt;&gt;
&gt;&gt;&gt; r.set('foo', 'hello')
True
&gt;&gt;&gt; r.get('foo')
'hello'
</code></pre>

<p>redis-py使用connection pool来管理对一个redis server的所有连接，避免每次建立、释放连接的开销。默认，每个Redis实例都会维护一个自己的连接池。可以直接建立一个连接池，然后作为参数Redis，这样就可以实现多个Redis实例共享一个连接池。</p>

<pre><code>&gt;&gt;&gt; pool = redis.ConnectionPool(host='127.0.0.1', port=6379, db=0)
&gt;&gt;&gt; pool
ConnectionPool&lt;Connection&lt;host=127.0.0.1,port=6379,db=0&gt;&gt;
&gt;&gt;&gt; r = redis.Redis(connection_pool=pool)
&gt;&gt;&gt; r
Redis&lt;ConnectionPool&lt;Connection&lt;host=127.0.0.1,port=6379,db=0&gt;&gt;&gt;
</code></pre>

<p>redis pipeline(管道)机制，可以在一次请求中执行多个命令，这样避免了多次的往返时延。</p>

<pre><code>&gt;&gt;&gt; pipe = r.pipeline()
&gt;&gt;&gt; pipe.set('one', '1')
Pipeline&lt;ConnectionPool&lt;Connection&lt;host=127.0.0.1,port=6379,db=0&gt;&gt;&gt;
&gt;&gt;&gt; pipe.set('two', '2')
Pipeline&lt;ConnectionPool&lt;Connection&lt;host=127.0.0.1,port=6379,db=0&gt;&gt;&gt;
&gt;&gt;&gt; pipe.execute()
[True, True]
&gt;&gt;&gt; pipe.set('name', 'fang').rpush('list', 'hello').rpush('list', 'world').execute()
[True, 1L, 2L]
&gt;&gt;&gt;
</code></pre>

<p>edis-py默认在一次pipeline中的操作是原子的，要改变这种方式，可以传入transaction=False</p>

<pre><code>pipe = r.pipeline(transaction=False) 
</code></pre>

<p>参考：<a href="http://blog.csdn.net/chosen0ne/article/details/7319807">Redis的Python客户端redis-py</a></p>

<h3>2.redis监控：</h3>

<p>1.redis-desktop-manager 桌面客户端</p>

<p>2.redis-live: python编写的监控redis服务，web版</p>

<p>3.redis-stat: ruby编写，web版和命令行版</p>

<p>redis-live配置安装如下：<a href="http://www.nkrode.com/article/real-time-dashboard-for-redis">文档地址</a></p>

<pre><code>pip install tornado
pip install redis
pip install python-dateutil

git clone https://github.com/kumarnitin/RedisLive.git
</code></pre>

<p>配置redis-live.conf,  RedisServers： 对应redis服务，远程或本地;RedisStatsServer： redis运行状况:</p>

<p>修改监控和被监控Redis实例的配置信息并分别启动这两个Redis实例。RedisServer是被监控Redis实例的配置，RedisStatsServer是监控Redis实例的配置，如果不希望将监控信息存储在Redis中，则需要将DataStoreType由redis改为sqlite类型即可，这样RedisStatsServer也就不用配置了。</p>

<pre><code>{
"RedisServers":
[ 
    {
        "server": "127.0.0.1",
        "port" : 6379
    },

    {
        "server": "localhost",
        "port" : 6379
    }       
    ],

"DataStoreType" : "redis",

"RedisStatsServer":
{
    "server" : "127.0.0.1",
    "port" : 6379
},

"SqliteStatsStore" :
{
    "path":  "to your sql lite file"
}
}
</code></pre>

<p>控制：</p>

<pre><code>cd src
#启动监控服务
./redis-monitor.py --duration=120   #每120秒监控一次
#启动web服务
./redis-live.py
</code></pre>

<p>然后访问：http://localhost:8888/index.html  就能看到监控页面了。</p>

<p><img src="http://blog.ithomer.net/wp-content/uploads/2014/07/redis-live.jpg" alt="" /></p>
