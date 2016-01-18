---
layout: post
title: "tornado异步方案"
description: "tornado异步方案"
category: "tornado"
tags: [异步]
---
<p>如下实例：</p>

<pre><code>@tornado.web.asynchronous
def get(self):
    time.sleep(5)
    self.write("sleep 5s")
</code></pre>

<p>上面的示例是没有到达异步非阻塞的效果的，<strong>@tornado.web.asynchronous装饰器有个前提就是你要耗时的执行需要执行异步,而且需要注意的是 Tornado默认在函数处理返回时关闭客户端的连接,但是当你使用@tornado.web.asynchonous装饰器时，Tornado永远不会自己关闭连接，需要显式的self.finish()关闭</strong>，为了实现异步我们有如下几种方式：</p>

<!--more-->

<h2>(1).添加通过回调异步操作：</h2>

<pre><code>@tornado.web.asynchronous
def get(self):
    def handler_reponse():
        """callback"""
        self.write('sleep 5s')
        self.finish()

    tornado.ioloop.IOLoop.instance().add_timeout(
        time.time() + 5,
        callback = handler_reponse
    )
</code></pre>

<p>注意：<code>tornado.ioloop.IOLoop.instance().add_timeout()</code>是time.sleep的非阻塞版本，它接受一个时间长度和一个函数这两个参数。表示多少时间之后调用该函数。</p>

<h2>(2).tornado.gen.coroutine 协程操作：</h2>

<pre><code>@tornado.web.asynchronous
@tornado.gen.coroutine
def get(self):
    yield tornado.gen.Task(
        tornado.ioloop.IOLoop.instance().add_timeout,
        time.time() + 5
    )
    self.write("when i sleep 5s")
</code></pre>

<p>ornado.gen.coroutine装饰器, coroutine是3.0之后新增的装饰器.以前的办法是用回调，现在直接通过<code>yield</code>关键字就行</p>

<h2>(3).<a href="https://github.com/mher/tornado-celery">tornado-celery(一个非阻塞的tornado celery客户端)</a></h2>

<pre><code>from tornado import gen, web
import tcelery, tasks

tcelery.setup_nonblocking_producer()

class GenAsyncHandler(web.RequestHandler):
    @asynchronous
    @gen.coroutine
    def get(self):
        response = yield gen.Task(tasks.sleep.apply_async, args=[3])
        self.write(str(response.result))
        self.finish()
</code></pre>

<p>然后写我们定义的task.</p>

<pre><code>import time
from celery import Celery

celery = Celery("tasks", broker="amqp://guest:guest@localhost:5672")
celery.conf.CELERY_RESULT_BACKEND = "amqp"

@celery.task
def sleep(seconds):
    time.sleep(float(seconds))
    return seconds

if __name__ == "__main__":
    celery.start()
</code></pre>

<p>启动celery works</p>

<pre><code>celery -A tasks worker --loglevel=info
</code></pre>

<p><strong>由于我们的异步非阻塞依赖于celery，如果队列中任务过多也会阻塞的，这是我们要考虑把同步阻塞函数变为异步</strong></p>

<h2>(4).concurrent模块和tornado.concurrent模块将同步函数变成异步</h2>

<p>concurrent：提供了多线程和多进程的并发功能.在python 3中使用concurrent模块，如果是python2.x 则要安装：<code>sudo pip install futures</code></p>

<pre><code>from tornado.concurrent import run_on_executor
from concurrent.futures import ThreadPoolExecutor

class SleepHandler(tornado.web.RequestHandler):
    executor = ThreadPoolExecutor(2)
    @tornado.web.asynchronous
    @tornado.gen.coroutine
    def get(self):
        res = yield self.sleep()  # sleep（）已经实现了异步
        self.write("when i sleep")
        self.finish()

    @run_on_executor
    def sleep(self):
        time.sleep(5)
        return 5
</code></pre>

<p>注意上述代码都省略了class.</p>

<h2>(5).基于tornado.ioloop的异步客户端</h2>

<p>在<a href="https://github.com/tornadoweb/tornado/wiki/Links">tornado wiki</a>中汇总了一些异步客户端。在<a href="http://tornado.poweredsites.org/">http://tornado.poweredsites.org/</a>中也给出了一些基于tornado开发的webService.</p>

<p>如基于<code>Beanstalkd</code>的tornado异步客户端：<code>beanstalkt</code>,<a href="https://bitbucket.org/nephics/beanstalkt">beanstalkt: An async beanstalkd client for Tornado</a></p>

<p><code>tornado-dns</code>:<a href="https://github.com/eklitzke/tornado-dns">异步的DNS查询</a></p>

<p>基于<code>HBase</code>的<a href="https://github.com/mjrusso/pyhbase"><code>pyhbase</code></a></p>

<ul>
<li>[[Amazon DynamoDB|http://aws.amazon.com/dynamodb/]]

<ul>
<li>[[asyncdynamo|https://github.com/bitly/asyncdynamo]]</li>
</ul></li>
<li>[[Amazon Web Services|http://aws.amazon.com]]

<ul>
<li>[[ botocore|https://github.com/boto/botocore ]] with [[ tornado-botocore|https://github.com/nanvel/tornado-botocore ]]</li>
</ul></li>
<li>[[AMQP|http://www.amqp.org/]]

<ul>
<li>[[stormed-amqp|https://github.com/paolo-losi/stormed-amqp]] - [[amqp|http://www.amqp.org/]] 0.9.1 compliant</li>
</ul></li>
<li>[[Beanstalkd|http://kr.github.com/beanstalkd/]]

<ul>
<li>[[beanstalkt|https://bitbucket.org/nephics/beanstalkt]]</li>
</ul></li>
<li>[[CouchDB|http://couchdb.apache.org/]]

<ul>
<li>[[trombi|http://github.com/inoi/trombi]]</li>
<li>[[corduroy|http://samizdat.cc/corduroy]]</li>
<li>[[tornado-couchdb|https://bitbucket.org/nephics/tornado-couchdb/overview]] - Blocking and non-blocking (asynchronous) clients to access CouchDB using Tornado's httpclient.</li>
</ul></li>
<li>DNS

<ul>
<li>[[tornado-dns|https://github.com/eklitzke/tornado-dns]]</li>
</ul></li>
<li>[[HBase|http://hbase.apache.org/]]

<ul>
<li>[[pyhbase|https://github.com/mjrusso/pyhbase]] - HBase Avro client</li>
</ul></li>
<li>[[Memcached|http://memcached.org/]]

<ul>
<li>[[tornado-memcache|https://github.com/dpnova/tornado-memcache]]</li>
<li>[[asyncmc|https://github.com/jeffhodsdon/asyncmc]]</li>
<li>[[memnado|https://github.com/clofresh/memnado]]</li>
</ul></li>
<li>[[MongoDB|http://www.mongodb.org/]] 

<ul>
<li>[[asyncmongo|http://github.com/bitly/asyncmongo]]</li>
<li>[[Motor|http://github.com/mongodb/motor/]]</li>
<li>[[PyEnty|https://github.com/leodesouza/pyenty/]]</li>
</ul></li>
<li>[[MySQL|http://www.mysql.com/]]

<ul>
<li>[[amysql|https://github.com/abael/amysql]] pure C language, base on Python native socket(support Python async).</li>
<li>[[adb|https://github.com/ovidiucp/pymysql-benchmarks]] - 
[[adisp|https://launchpad.net/adisp]]/[[MySQLdb|http://mysql-python.sourceforge.net/]] based</li>
</ul></li>
<li>[[PostgreSQL|http://www.postgresql.org/]]

<ul>
<li>[[momoko|https://github.com/FSX/momoko]] - [[psycopg|http://initd.org/psycopg/]] wrapper.</li>
<li>[[adb|https://github.com/ovidiucp/pymysql-benchmarks]] - [[adisp|https://launchpad.net/adisp]]/[[psycopg|http://initd.org/psycopg/]] based</li>
<li>[[queries|https://github.com/gmr/queries]] - [[psycopg|http://initd.org/psycopg/]] wrapper with an eye on ease of use.</li>
</ul></li>
<li>[[RabbitMQ|http://www.rabbitmq.com]]

<ul>
<li>[[Pika|https://github.com/pika/pika]]</li>
</ul></li>
<li>[[Redis|http://redis.io/]]

<ul>
<li>[[tornado-redis|https://github.com/leporo/tornado-redis]] (fork of [[brukva|https://github.com/evilkost/brukva]])</li>
<li>[[tornadis|https://github.com/thefab/tornadis]]</li>
</ul></li>
<li>[[Socket.IO|http://socket.io/]]

<ul>
<li>[[tornadio2|https://github.com/MrJoes/tornadio2]]</li>
</ul></li>
<li>Socks5 Proxy Server

<ul>
<li>[[Fukei|https://github.com/thomashuang/Fukei]]</li>
</ul></li>
<li>[[Solr|http://lucene.apache.org/solr/]]

<ul>
<li>[[pysolr-tornado|https://github.com/nieldomingo/pysolr-tornado]] based on [[pysolr|https://github.com/toastdriven/pysolr]]</li>
</ul></li>
<li>[[subprocess|http://docs.python.org/library/subprocess.html]] (local)

<ul>
<li>[[AsyncProcessMixIn|https://gist.github.com/pplante/489093]]</li>
</ul></li>
<li>[[SMTP|http://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol]]

<ul>
<li>[[smtp|https://gist.github.com/1358253]]</li>
</ul></li>
<li>XML-RPC/JSON-RPC

<ul>
<li>[[tornadorpc|https://github.com/joshmarshall/tornadorpc]]</li>
</ul></li>
<li>[[Event-Source|http://dev.w3.org/html5/eventsource/]]

<ul>
<li>Python/Tornado's [[event-source-library|https://github.com/guyzmo/event-source-library]]</li>
</ul></li>
</ul>

<p>参考：<a href="http://dongweiming.github.io/blog/archives/shi-yong-tornadorang-ni-de-qing-qiu-yi-bu-fei-zu-sai/">使用tornado让你的请求异步非阻塞</a></p>
