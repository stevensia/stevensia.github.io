---
layout: post
title: "nodejs redis使用(二).发布与订阅"
description: "nodejs redis使用(二).发布与订阅"
category: "redis"
tags: [redis]
---

<p>一旦客户端有订阅动作，它将发送如下事件：</p>

<h3>"message" (channel, message)</h3>

<p>客户端将发送<code>message</code>事件对于每个订阅消息接受者.<strong>是个消息监听的事件</strong></p>

<pre><code>//订阅频道
client1.subscribe("channelA");

//监听消息
client1.on("message", function(channel, message) {
    console.log(channel);
    console.log(message);
});
</code></pre>

<p>然后在终端运行nodejs，使之处于订阅后并监听消息的状态</p>

<pre><code>$ node test.js
</code></pre>

<p>然后再打开redis终端，在channelA频道发送消息</p>

<pre><code>127.0.0.1:6379&gt; publish channelA "Beginman"
(integer) 1
</code></pre>

<p>此时回到运行nodejs的窗口，就可以看到监听到的消息了</p>

<pre><code>$ node test.js
channelA
Beginman
</code></pre>

<h3>"subscribe" (channel, count)</h3>

<p>当<code>SUBSCRIBE</code>命令执行后，客户端将发送<code>subscribe</code>事件</p>

<pre><code>//订阅频道:subscribe命令
client1.subscribe("channelA");

//nodejs回调:subscribe事件
client1.on("subscribe", function(channel, count) {
    console.log(channel);       //channelA
    console.log(count);         //1
});
</code></pre>

<h3>"psubscribe" (pattern, count)</h3>

<p>当<code>PSUBSCRIBE</code>命令执行后，客户端会发送<code>psubscribe</code>事件</p>

<pre><code>//订阅多个频道:psubscribe命令
client1.psubscribe("channel*", "cha*", "fuck.a.b*");

//nodejs回调:psubscribe事件
client1.on("psubscribe", function(pattern, count) {
    console.log(pattern);
    console.log(count);      
});
</code></pre>

<p>运行nodejs后：</p>

<pre><code>$ node test.js
channel*
1
cha*
2
fuck.a.b*
3
</code></pre>

<h3>"pmessage" (pattern, channel, message)</h3>

<pre><code>//订阅多个频道:psubscribe命令
client1.psubscribe("channel*", "cha*", "fuck.a.b*");

//监听多个频道
client1.on("pmessage", function (pattern, channel, message) {
    console.log(pattern);
    console.log(channel);
    console.log(message);
});
</code></pre>

<p>运行nodejs后，打开redis命令行，发布消息：</p>

<pre><code>127.0.0.1:6379&gt; publish channelA "Beginman"
(integer) 2
127.0.0.1:6379&gt; publish chaDDD "Beginman"
(integer) 1
127.0.0.1:6379&gt; publish fuck "Beginman"
(integer) 0
127.0.0.1:6379&gt; publish fuck.a.b "Beginman"
(integer) 1
127.0.0.1:6379&gt; publish fuck.a.b.c.d.e.f.g "Beginman"
(integer) 1
</code></pre>

<p>返回到nodejs窗口，查看监听到的消息：</p>

<pre><code>$ node test.js
channel*
channelA
Beginman

cha*
channelA
Beginman

cha*
chaDDD
Beginman

fuck.a.b*
fuck.a.b
Beginman

fuck.a.b*
fuck.a.b.c.d.e.f.g
Beginman
</code></pre>

<h3>"unsubscribe" (channel, count)</h3>

<p><code>UNSUBSCRIBE</code>命令执行后客户端会发送<code>unsubscribe</code>事件</p>

<pre><code>//订阅多个频道:psubscribe命令
client1.psubscribe("channel*", "cha*", "fuck.a.b*");

/*
UNSUBSCRIBE [channel [channel ...]]
指示客户端退订给定的频道。
如果没有频道被指定，也即是，一个无参数的 UNSUBSCRIBE 调用被执行，那么客户端使用 SUBSCRIBE 命令订阅的所有频道都会被退订。
*/
client1.unsubscribe("channelA");

client1.on('unsubscribe', function(channel, count) {
    console.log(channel);
    console.log(count);
})

//运行结果
$ node test.js
channelA
3
</code></pre>

<h3>"punsubscribe" (pattern, count)</h3>

<p>批量退订</p>
