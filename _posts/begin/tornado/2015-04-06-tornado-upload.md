---
layout: post
title: "tornado文件上传"
description: "tornado文件上传"
category: "tornado"
tags: [上传]
---
<p>## 一.http上传原理
参考：<a href="http://blog.beginman.cn/blog/146/">html&amp;html5之form</a>, 确保表单<code>enctype=multipart/form-data</code>,multipart/form-data 是新增的编码类型，以提高二进制文件的传输效率.</p>

<p>然后发送请求后我们分析http 头文件：</p>

<pre><code>Content-Length:37153
Content-Type:multipart/form-data; boundary=----WebKitFormBoundaryD68wJn8cs4awCEB8

Request Payload
------WebKitFormBoundaryD68wJn8cs4awCEB8
Content-Disposition: form-data; name="file";    filename="fang.jpg"
Content-Type: image/jpeg


------WebKitFormBoundaryD68wJn8cs4awCEB8
Content-Disposition: form-data; name="_xsrf"

2|0483adb7|139e6ecd0f4ee6da8832b1e7e0c93991|1419042308
------WebKitFormBoundaryD68wJn8cs4awCEB8--
</code></pre>

<p><code>Content-Length</code>:内容总长度</p>

<p><code>Content-Type:multipart/form-data</code>:在最初的 http 协议中，没有上传文件方面的功能。 rfc1867 (http://www.ietf.org/rfc/rfc1867.txt) 为 http 协议添加了这个功能,所以在上传文件时必须设置此项。</p>

<p><code>boundary</code>:边界（分隔）符， boundary=---WebKitFormBoundaryD68wJn8cs4awCEB8， 用于分隔多个文件、表单项。</p>

<p><code>Request Payload</code>:针对Content-Type:multipart/form-data所出现的协议形式，如果去掉enctype="multipart/form-data"，头部信息出现的是 Form Data  而不是Request payload.</p>

<p><code>-----WebKit....</code> 表示各个表单字段项的分隔符</p>

<p><code>name=“file”</code> 表示表单字段，<code>filename</code>:上传的文件名，<code>Content-Type</code>:文件类型。</p>

<p>然后服务器端通过获取上传文件的二进制形式并写入就可以实现上传的原理。</p>

<h2>二.tornado文件上传</h2>

<p>那么接下来就说下服务器端的工作原理，这里以tornado为例子。</p>

<!--more-->

<p><strong>tornado中 RequestHandler的request包含所有httpRequest的信息，通过self.request.files这个字典对象来获取上传列表。</strong></p>

<pre><code>uploadfile_list = self.request.files.get('uploadfile')
</code></pre>

<p>字典内容如下：</p>

<pre><code>[{'body': '\xff\xd8\xff\xe0\x00...., 'content_type': u'image/jpeg', 'filename': u'my.jpg'}, ........]
</code></pre>

<p><strong>注意：如果在测试环境中，编写上传的view时，一定要注意@tornado.web.authenticated， 确保你是登陆状态上传文件或者直接去掉该装饰器，否则会出现403错误。</strong></p>

<p>那么如果多文件上传只需要遍历该self.request.files即可，代码如下：</p>

<pre><code>    # coding=utf-8
__author__ = 'fang'
import time
import datetime
import tornado.gen
import tornado.web
import tornado.ioloop
import settings
import os
import datetime

from web import BaseHandler

class FileHandler(BaseHandler):
    def get(self):
        self.render('file/file.html')

    # @tornado.web.authenticated
    @tornado.web.asynchronous
    def post(self):
        # print self.get_argument('txt')
        files = self.request.files.get('file')
        for f in files:
            filename = f['filename']
            filepath = os.path.join(settings.UPLOAD,
                                    datetime.datetime.now().strftime('%Y-%M-%d'))
            if not os.path.exists(filepath):
                os.makedirs(filepath)
            file_path = os.path.join(filepath, filename)
            with open(file_path, 'wb') as up:
                up.write(f['body'])     # 写入文件

        self.write('ok')
        self.finish()
</code></pre>

<h2>三.web upload技术里程碑</h2>

<p>web技术这几十年，上传这块历经如下里程碑：</p>

<p><strong>1.传统的form上传</strong></p>

<p>文件上传的传统形式，是使用表单元素file：</p>

<p><strong>2.iframe上传</strong></p>

<p>传统的表单上传，属于"同步上传"。也就是说，点击上传按钮后，网页"锁死"，用户只能等待上传结束，然后浏览器刷新，跳到表单的action属性指定的网址。</p>

<pre><code>var form = $("#upload-form");
form.on('submit',function() {
// 此处动态插入iframe元素
});
</code></pre>

<p>通过动态插入iframe实现“异步上传”</p>

<p><strong>3.ajax上传</strong></p>

<p>ajax上传实现真正的“异步上传”，利用HTML5 FormData对象构建表单键值对。</p>

<p>3.1：XMLHttpRequest第二版还定义了一个progress事件，可以用来制作进度条。</p>

<p>3.2：如果上传的是图片文件，利用File API，我们可以做一个图片文件的预览。这里主要用到FileReader对象。</p>

<p>参考：<a href="http://www.ruanyifeng.com/blog/2012/08/file_upload.html"><strong>文件上传的渐进式增强</strong></a></p>

<h2>四.js文件上传插件</h2>

<p>下面的插件都是基于上面说的里程碑中最新技术背景下产生的，下面学习<a href="https://blueimp.github.io/jQuery-File-Upload/">jQuery File Uploader</a>插件。</p>

<p>这是最受欢迎的 jQuery 文件上传组件，支持批量上传，拖放上传，显示上传进度条以及校验功能。</p>

<p>支持预览图片、音频和视频，支持跨域上传和客户端图片缩放，支持的服务端平台有：PHP, Python, Ruby on Rails, Java, Node.js, Go 等等。</p>

<p>这里有个demo关于tornado与该插件的，<a href="https://github.com/BeginMan/FileHub">文件共享应用FileHub</a></p>

<p><img src="http://m2.img.srcdd.com/farm5/d/2013/0616/21/F4EC5A8D98300726C4784B4779D641F1_B500_900_500_263.PNG" alt="" /></p>

<h2>五.大文件上传</h2>

<p>Tornado 自身是不支持大文件上传的。对于接收到的文件，它会把文件内容保存在内存里，而不是像 PHP 那样保存在临时文件里。这样对于大文件，问题很明显了——内容不够。所以，Tornado 上传文件的大小限制在 100M 以下了。Tornado 官方建议使用 nginx 的上传模块来处理文件上传。</p>

<p>参考：</p>

<p><a href="http://lilydjwg.is-programmer.com/2012/4/3/tornado-and-http-file-upload.32782.html">1.Tornado 与文件上传</a></p>
