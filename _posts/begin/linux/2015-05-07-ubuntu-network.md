---
layout: post
title: "ubuntu网络配置"
description: "ubuntu网络配置"
category: "linux"
tags: [linux服务器]
---

<h2>配置文件</h2>

<p>Ubuntu的网络设置涉及到如下文件：</p>

<pre><code>/etc/network/interfaces     # 网络接口配置，包括网络接口说明、IP地址、子网掩码、网关等
/etc/resolv.conf                # DNS服务器设置
/etc/hostname                   # 主机名设置
/etc/hosts                  # 域名解析映射
/etc/hosts.allow                # IP访问允许规则
/ect/hosts.deny             # IP访问禁止规则
</code></pre>

<p>注意：修改网络配置文件后，要重启网络接口，使用命令：<code>/etc/init.d/networking restart</code></p>

<!--more-->

<h2>网络配置</h2>

<h3>1.IP自动获取（DHCP）</h3>

<p>只需修改/etc/network/interfaces文件即可，修改后内容如下：</p>

<pre><code>    auto lo             # 设置回环
    iface lo inet loopback

    auto eth0               # 设置eth0开机自动加载
    iface eth0 inet dhcp    # 定义网络接口eth0为Internet，DHCP方式
</code></pre>

<h3>2.IP手动配置（Static）</h3>

<p>a) 修改/etc/network/interfaces文件：</p>

<pre><code>    auto lo             # 设置回环
    iface lo inet loopback

    auto eth0
    iface eth inet static   # 静态ip

    address 10.0.18.25      # 设置ip地址 其中号段为18
    gateway 10.0.18.25      # 设置网关
    netmask 255.255.255.0    # 设置子网掩码

    #网络和广播可不写
    #network 10.0.2.0
    #broadcast 10.0.2.255
</code></pre>

<p>b) 配置DNS，修改/etc/resolv.conf,内容如下</p>

<pre><code>    nameserver x.x.x.x  # 首要DNS服务器
    nameserver xx.x.x   # 备用DNS服务器
</code></pre>

<h3>3. 关于主机名：</h3>

<p>直接修改/etc/hostname文件即可，文件中仅存主机名</p>

<h3>4. 主机访问控制：</h3>

<p>通过修改tcpd的配置文件<code>/etc/hosts.allow</code>与<code>/etc/hosts.deny</code>来完成，当配置冲突时，以前者配置为准，
因此，二者仅需其一即可完成配置。二者同时存在的原因是这样使得配置更加清晰，即允许规则放在<code>hosts.allow</code>中，禁止规则放在<code>hosts.deny</code>中。
    文件中一条规则占用一行，格式为：</p>

<pre><code>    daemon_list:client_list[:shell_list]
</code></pre>

<p>其中,daemon所示daemon进程名，必须在<code>/etc/rc.d/</code>（BSD风格的启动脚本）或<code>/etc/init.d</code>（SystemV风格的启动脚本）下出现</p>

<pre><code>    #sshd的配置例子：
    # /etc/hosts.allow
    ALL:127.0.0.1               # 允许本机访问所有服务
    sshd:10.0.2.0/255.255.255.0 # 允许10.0.3.0网段的IP访问ssh服务
    sshd:10.0.3.0/24            # 允许10.0.3.0网段的IP访问ssh服务
    # /etc/hosts.deny
    ALL:ALL                     # 禁止所有访问
</code></pre>

<h3>5. 其他：使用命令方式配置网络信息</h3>

<p>本方式仅执行命令后有效，重启机器后，所做更改消失，所以永久改动还是直接修改配置文件好</p>

<pre><code>ifconfig eth0 &lt;ip_addr&gt; netmask &lt;netmask&gt;   # 配置IP地址和子网掩码
route add default gw &lt;gw_addr&gt;          # 配置网关
hostname &lt;new_hostname&gt;                     # 配置主机名
dhclient eth0                               # DHCP方式获取
</code></pre>

<p>参考：<a href="http://rsljdkt.iteye.com/blog/1142051">(总结) Ubuntu网络设置</a></p>
