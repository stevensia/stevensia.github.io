---
layout: post
title: "Nginx简单的配置详情"
description: "Nginx简单的配置详情"
category: "Nginx"
tags: [Nginx]
---

<p>建议从<a href="http://oilbeater.com/nginx/2014/12/29/nginx-conf-from-zero.html"><strong>nginx 配置从零开始</strong></a>开始入门，</p>

<p>大致了解Nginx后，直接从配置文件入手：</p>

<pre><code>[shell]

#定义Nginx运行的用户和用户组
user nginx;

#nginx进程数，建议设置为等于CPU总核心数。
worker_processes 4;

#全局错误位置与日志类型定义，[ debug | info | notice | warn | error | crit ]
error_log /var/log/nginx/error.log info;

#进程文件
pid /var/run/nginx.pid;

events {
    worker_connections 65530;       #单个进程最大连接数（最大连接数=连接数*进程数）
    use epoll;                      #参考事件模型
}

#设定http服务器
http {
    include mime.types; #文件扩展名与文件类型映射表
    default_type application/octet-stream; #默认文件类型
    charset utf-8; #默认编码
    client_header_buffer_size 1024k; #上传文件大小限制
    tcp_nopush on; #防止网络阻塞
    tcp_nodelay on; #防止网络阻塞
    keepalive_timeout 120; #长连接超时时间，单位是秒

    #FastCGI相关参数是为了改善网站的性能：减少资源占用，提高访问速度。下面参数看字面意思都能理解。
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;

    #gzip模块设置
    gzip on; #开启gzip压缩输出
    gzip_min_length 1k; #最小压缩文件大小
    gzip_buffers 4 16k; #压缩缓冲区
    gzip_http_version 1.0; #压缩版本（默认1.1，前端如果是squid2.5请使用1.0）
    gzip_comp_level 2; #压缩等级
    gzip_types text/plain application/x-javascript text/css application/xml;
    #压缩类型，默认就已经包含text/html，所以下面就不用再写了，写上去也不会有问题，但是会有一个warn。
    gzip_vary on;

    upstream yunlianxiNET {
        server 127.0.0.1:9000;
        server 127.0.0.1:9001;
        server 127.0.0.1:9002;
        server 127.0.0.1:9003;
    }
    #虚拟主机的配置
    server {
        #监听端口
        listen 9000;
        #域名可以有多个，用空格隔开
        #server_name www.yunlianxi.net yunlianxi.net;
        index index.html index.htm index.php;
        root /root/project/yunlianxiManage;
        location ^~ /static/ {
            root /root/project/yunlianxiManage;
            if ($query_string) {
                expires max;
            }
        }
        #图片缓存时间设置
        location ~ .*.(gif|jpg|jpeg|png|bmp|swf)$ {
            expires 10d;
        }
        #JS和CSS缓存时间设置
        location ~ .*.(js|css)?$ {
            expires 1h;
        }
        #日志格式设定
        log_format access '$remote_addr - $remote_user [$time_local] &amp;quot;$request&amp;quot; '
        '$status $body_bytes_sent &amp;quot;$http_referer&amp;quot; '
        '&amp;quot;$http_user_agent&amp;quot; $http_x_forwarded_for';
        #定义本虚拟主机的访问日志
        access_log /var/log/nginx/yunlianxiManageaccess.log access;

        #对 &amp;quot;/&amp;quot; 启用反向代理
        location / {
            proxy_pass http://yunlianxiNET;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            #后端的Web服务器可以通过X-Forwarded-For获取用户真实IP
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            #以下是一些反向代理的配置，可选。
            proxy_set_header Host $host;
            client_max_body_size 10m; #允许客户端请求的最大单文件字节数
            client_body_buffer_size 128k; #缓冲区代理缓冲用户端请求的最大字节数，
            proxy_connect_timeout 90; #nginx跟后端服务器连接超时时间(代理连接超时)
            proxy_send_timeout 90; #后端服务器数据回传时间(代理发送超时)
            proxy_read_timeout 90; #连接成功后，后端服务器响应时间(代理接收超时)
            proxy_buffer_size 4k; #设置代理服务器（nginx）保存用户头信息的缓冲区大小
            proxy_buffers 4 32k; #proxy_buffers缓冲区，网页平均在32k以下的设置
            proxy_busy_buffers_size 64k; #高负荷下缓冲大小（proxy_buffers*2）
            proxy_temp_file_write_size 64k;
            #设定缓存文件夹大小，大于这个值，将从upstream服务器传
        }

        #设定查看Nginx状态的地址
        location /NginxStatus {
            stub_status on;
            access_log on;
            auth_basic &amp;quot;NginxStatus&amp;quot;;
            auth_basic_user_file conf/htpasswd;
            #htpasswd文件的内容可以用apache提供的htpasswd工具来产生。
        }


    }


}

[/shell]
</code></pre>
