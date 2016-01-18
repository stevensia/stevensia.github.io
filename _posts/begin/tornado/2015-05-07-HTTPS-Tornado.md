---
layout: post
title: "HTTPS设置与Tornado应用"
description: "HTTPS设置与Tornado应用"
category: "security"
tags: [安全]
---
<h2>一.https与http区别</h2>

<p><strong>HTTPS(Secure Hypertext Transfer Protocol)：安全超文本传输协议，基于HTTP,使用安全套接层(SSL)作为HTTP应用的子层，HTTPS使用443端口，SSL使 用40 位关键字作为RC4流加密算法，HTTPS和SSL支持使用X.509数字认证。</strong></p>

<p><img src="http://beginman.qiniudn.com/https.jpg" alt="" /></p>

<p>与http区别如下：</p>

<blockquote>
  <p>http是HTTP协议运行在TCP之上。所有传输的内容都是明文，客户端和服务器端都无法验证对方的身份。
  https是HTTP运行在SSL/TLS之上，SSL/TLS运行在TCP之上。所有传输的内容都经过加密，加密采用对称加密，但对称加密的密钥用服务器方的证书进行了非对称加密。此外客户端可以验证服务器端的身份，如果配置了客户端验证，服务器方也可以验证客户端的身份。</p>
</blockquote>

<ol>
<li>https协议需要到ca申请证书，一般免费证书很少，需要交费</li>
<li>http是超文本传输协议，信息是明文传输，https 则是具有安全性的ssl加密传输协议</li>
<li>http和https使用的是完全不同的连接方式用的端口也不一样,前者是80,后者是443</li>
<li>http的连接很简单,是无状态的</li>
<li>HTTPS协议是由SSL+HTTP协议构建的可进行加密传输、身份认证的网络协议 要比http协议安全 </li>
</ol>

<!--more-->

<p>注意：</p>

<p><strong>1.对于https第三方工具截取不到客户端与服务端的通讯</strong></p>

<p><strong>2.总的来说，http效率更高，https安全性更高。</strong></p>

<p>更多HTTPS相关内容参考<a href="http://baike.baidu.com/view/14121.htm">百度百科 https</a></p>

<p>如果不想买证书的话，可以参考这里<strong><a href="http://www.oschina.net/translate/switch-to-https-now-for-free?p=3#comments">现在就启用 HTTPS，免费的！</a></strong></p>

<h2>二.openssl生成证书和自签证书</h2>

<p>1.进入openssl安装目录</p>

<pre><code>cd /etc/ssl
</code></pre>

<p>2.在OpenSSL 的安装目录下建立demoCA,然后进入demoCA 目录建立certs、newcerts 文件夹和空index.txt</p>

<pre><code>mkdir demoCA;
cd demoCA;
mkdir certs;
mkdir newcerts
&gt;index.txt
#返回到openssl安装目录
cd ..
</code></pre>

<p>3.在OpenSSL 的安装目录下建立serial文件，然后用 vim 或其他工具往里面填充任意的16进制数字，如 0000</p>

<p>4.在OpenSSL 的安装目录下，首先要生成服务器端的私钥(key文件):</p>

<pre><code>openssl genrsa -des3 -out server.key 1024
</code></pre>

<p>运行时会提示输入密码,此密码用于加密key文件(参数des3便是指加密算法,当然也可以选用其他你认为安全的算法.)，以后每当需读取此文件(通过openssl提供的命令或API)都需输入口令.如果觉得不方便,也可以去除这个口令,但一定要采取其他的保护措施!
去除key文件口令的命令:</p>

<pre><code>openssl rsa -in server.key -out server.key
</code></pre>

<p>5.生成Certificate Signing Request（CSR）,生成的csr文件交给CA签名后形成服务端自己的证书.</p>

<pre><code>openssl req -new -key server.key -out server.csr -config openssl.cnf
...
Country Name (2 letter code) [XX]:CN           #国家，随便填
State or Province Name (full name) []:GD     
Locality Name (eg, city) [Default City]:GZ
Organization Name (eg, company) [Default Company Ltd]:SZuniversity
Organizational Unit Name (eg, section) []:SZunivertiy
Common Name (eg, your name or your server's hostname) []:xxx  #这个重要！！
Email Address []:aaa@163.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:                   #不填
An optional company name []:               #不填
</code></pre>

<p>6.对客户端也作同样的命令生成key及csr文件</p>

<pre><code>openssl genrsa -des3 -out client.key 1024   #如果服务端去掉了密码，这里也要去掉
openssl req -new -key client.key -out client.csr -config openssl.cnf
</code></pre>

<p>7.生成CA文件</p>

<p>CSR文件必须有CA的签名才可形成证书，可将此文件发送到verisign等地方由它验证（需要收费），这里我们自己制作一个CA</p>

<p>在demoCA建立一个文本文件 serial, 没有扩展名，内容是一个合法的16进制数字，例如 0000,确保demoCA下有之前建立的certs，newcerts文件夹和空文件 index.txt。然后<strong>在openSSL安装目录下</strong>创建CA文件：</p>

<pre><code>openssl req -new -x509 -keyout ca.key -out ca.crt -config openssl.cnf
</code></pre>

<p>8.用生成的CA的证书为刚才生成的server.csr,client.csr文件签名</p>

<pre><code>openssl ca -in server.csr -out server.crt -cert ca.crt -keyfile ca.key -config openssl.cnf

openssl ca -in client.csr -out client.crt -cert ca.crt -keyfile ca.key -config openssl.cnf
</code></pre>

<p><strong>注意，如果报错了则清空index.txt,重新执行第8步</strong></p>

<p>则client使用的文件有：ca.crt，client.crt，client.key</p>

<p>server使用的文件有：ca.crt，server.crt，server.key</p>

<h2>三.配置Nginx</h2>

<p>编辑配置文件nginx.conf，给站点加上HTTPS协议</p>

<pre><code>server {
    listen 443;
    server_name YOUR_DOMAINNAME_HERE;

    ssl on;
    ssl_certificate /to/your/path/server.crt;
    ssl_certificate_key /to/your/path/server.key;

    ssl_session_cache    shared:SSL:10m;
    ssl_session_timeout  10m;

    ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
    #ssl_ciphers  ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
    ssl_ciphers   RC4:HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
            root /usr/local/nginx/html;
            index index.html;
        }
    }
</code></pre>

<p>重启Nginx后即可通过https访问网站了.但是<strong>自行颁发的SSL证书能够实现加密传输功能，但浏览器并不信任，会出现“此网站的安全证书有问题”的提示。</strong></p>

<p><img src="http://beginman.qiniudn.com/disableSSl.jpeg" alt="" /></p>

<h2>四.tornado 建立SSL</h2>

<p>tornado支持SSL链接</p>

<pre><code>import ssl
from tornado.httpserver import HTTPServer
from tornado.web import Application, RequestHandler
from tornado.ioloop import IOLoop

class TestHandler(RequestHandler):
    def get(self):
        self.write("Hello, World!\n")

settings = {
    "static_path" : os.path.join(os.path.dirname(__file__), "static"),
}

application = Application([
    (r"/", TestHandler),
], **settings)

if __name__ == "__main__":
    server = HTTPServer(application,ssl_options={
           "certfile": os.path.join(os.path.abspath("."), "server.crt"),
           "keyfile": os.path.join(os.path.abspath("."), "server.key"),
       })
    server.listen(8000)
    IOLoop.instance().start()
</code></pre>

<p>启动项目后打开浏览器输入网址：</p>

<p><img src="http://beginman.qiniudn.com/ssl.jpg" alt="" /></p>

<p><strong>对于安全性较高的商业软件，还是购买证书吧</strong></p>

<p>推荐阅读:<a href="http://w.gdu.me/wiki/sysadmin/openssl_genrsa_req_sign.html">SSL证书申请、颁发说明</a></p>

<h2>五.参考</h2>

<p><a href="http://www.zhukun.net/archives/7604">CentOS6系统openssl生成证书和自签证书</a></p>

<p><a href="http://www.cnblogs.com/SinSay/archive/2010/10/30/1865178.html">使用 Tornado 跟 SSL 建立安全链接</a></p>
