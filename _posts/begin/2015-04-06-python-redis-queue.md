---
layout: post
title: "python实现redis简单的消息队列(一)"
description: "python实现redis简单的消息队列(一)"
category: "redis"
tags: [redis]
---

<h2>Redis消息队列的实现</h2>

<h3>队列(queue)</h3>

<p>在弄清楚消息队列之前要明白以下几个概念：<code>queue</code>.</p>

<p>队列，又称为伫列（queue），是先进先出（FIFO, First-In-First-Out）的线性表。在具体应用中通常用链表或者数组来实现。队列只允许在后端（称为rear）进行插入操作，在前端（称为front）进行删除操作。</p>

<p>队列的操作方式和堆栈类似，唯一的区别在于队列只允许新数据在后端进行添加</p>

<!--more-->

<h3>消息队列</h3>

<p>消息队列(Message queue)的含义,以下总结内容来自<a href="http://zh.wikipedia.org/wiki/%E6%B6%88%E6%81%AF%E9%98%9F%E5%88%97">wiki</a>:</p>

<blockquote>
  <p>1.消息队列是一种进程间通讯或同一进程不同线程间的通讯方式</p>
  
  <p>2.消息队列常保持在链表结构中，拥有权限的进程可以向消息队列中写入或读取消息。</p>
  
  <p>3.优缺点：</p>
  
  <p>消息队列本身是异步的，它允许接收者在消息发送很长时间后再取回消息，这和大多数通信协议是不同的。例如WWW中使用的HTTP协议是同步的，因为客户端在发出请求后必须等待服务器回应。然而，很多情况下我们需要异步的通信协议。比如，一个进程通知另一个进程发生了一个事件，但不需要等待回应。但消息队列的异步特点，也造成了一个缺点，就是接收者必须轮询消息队列，才能收到最近的消息。</p>
  
  <p>和信号相比，消息队列能够传递更多的信息。与管道相比，消息队列提供了有格式的数据，这可以减少开发人员的工作量。[5]但消息队列仍然有大小限制。</p>
</blockquote>

<h3>Redis list类型</h3>

<p>redis list提供了队列的实现，其中<code>lbpop</code>可以实现一种简单的消息队列。关于redis list的学习参考：<a href="https://redis.readthedocs.org/en/2.4/list.html">https://redis.readthedocs.org/en/2.4/list.html</a></p>

<p>redis 消息列表设计模式：</p>

<p>设计模式： 一个安全的队列</p>

<p>Redis的列表经常被用作队列(queue)，用于在不同程序之间有序地交换消息(message)。一个程序(称之为生产者，producer)通过LPUSH命令将消息放入队列中，而另一个程序(称之为消费者，consumer)通过RPOP命令取出队列中等待时间最长的消息。</p>

<p>不幸的是，在这个过程中，一个消费者可能在获得一个消息之后崩溃，而未执行完成的消息也因此丢失。</p>

<p>使用RPOPLPUSH或BRPOPLPUSH(阻塞版本)命令可以解决这个问题，因为它在返回一个消息之余，还将该消息添加到另一个列表当中，另外的这个列表可以用作消息的备份表：假如一切正常，当消费者完成该消息的处理之后，可以用LREM命令将该消息从备份表删除。</p>

<p>另一方面，助手(helper)程序可以通过监视备份表，将超过一定处理时限的消息重新放入队列中去(负责处理该消息的消费者可能已经崩溃)，这样就不会丢失任何消息了。</p>

<p>推荐阅读：<a href="http://www.cnblogs.com/laozhbook/p/redis_queue.html"><strong>用redis实现支持优先级的消息队列</strong></a></p>

<h2>python实现redis简单的消息队列</h2>

<pre><code># coding=utf-8
import redis

class RedisQueue(object):
    def __init__(self, name, namespace='queue', **redis_kwargs):
        self.__db = redis.StrictRedis()
        self.key = '%s:%s' % (namespace, name)

    def put(self, item):
        self.__db.rpush(self.key, item)

    def get(self, type=True, timeout=None):
        if type:
            item =  self.__db.blpop(self.key, timeout)
        else:
            item = self.__db.lpop(self.key)

        if item:
            print item
            item = item[1]
        return item

    def size(self):
        return self.__db.llen(self.key)


&gt;&gt;&gt;q = RedisQueue('test')
&gt;&gt;&gt;q.put('hello,world')
&gt;&gt;&gt;print q.get()
</code></pre>

<h2>主流消息队列一览表</h2>

<p><code>rabbitMQ</code>：它在消息或任务队列里面是主流的方案，成熟稳定。同类的还有ZeroMQ等。</p>

<p>优点：成熟放心。</p>

<p>缺点：需要开发和运维都充分掌握，学习和维护成本较redis的高。</p>

<p><code>redis</code>：内部的列表支持对队列的操作，其中List的blpop是阻塞式的，满足消息队列的要求。</p>

<p>优点：使用和维护简单。自身的内存缓存特点也保证了速度。</p>

<p>缺点：因为不是原生设计成对消息队列的应用，有的队列操作还需要补充实现。这个有现成的库可以帮助解决，但可靠性、成熟度需要确认。</p>

<p><code>celery</code>：把rabbiMQ、redis、mongodb等作为后端，进一步的封装。最初是python的，现在也有nodejs版</p>

<p>优点：进一步的封装，可以方便把后端切换成不同的方案。python版相对比较成熟。</p>

<p>缺点：nodejs版还不够成熟，有点功能还不支持，比如底层现在指支持rabbitMQ，不支持redis</p>

<p><code>mongodb</code>: 其实也有人用mongodb的capped collection来做队列，鉴于它在node.js的应用中广泛被使用，它也是一种选择。</p>

<p>优点：如果本来应用就是用mongodb，那可以一并来用</p>

<p>缺点：当并发量大的时候，速度不理想</p>
