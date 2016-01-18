---
layout: post
title: "Python生成聊天群头像"
description: "Python生成聊天群头像"
category: "Python"
tags: [Python视觉处理]
---

<p>最近在做即时聊天(IM)这块，对创建聊天小组要生成头像有需求，也就是根据创建聊天小组的时候，根据成员头像，生成一张聊天小组组图，相当于创建微信群头像，这不过这里将它圆角化而已。</p>

<p>要开发这个功能，我们需要哪些知识呢？我列举如下：</p>

<ol>
<li>Python PIL</li>
<li><a href="http://book.douban.com/subject/25906843/">《Python计算机视觉编程》</a>(优化程序，后期阅读)</li>
</ol>

<p>流程如下:</p>

<ol>
<li>读取网络图片(url图片资源存入内存中处理而非本地)</li>
<li>先图片缩略图处理，再图片圆角处理</li>
<li>合并图片，生成base64加密的二进制流供文件系统API处理；或者保存本地也可</li>
</ol>

<p>如下是我生成的图片：</p>

<p><img src="http://beginman.qiniudn.com/genAvatar.jpg" alt="" /></p>

<p>接下来逐一突破吧，就拿代码来说吧</p>

<!--more-->

<h2>1&#46;PIL 与 Pillow</h2>

<p><a href="http://www.douban.com/group/topic/37715851/">PIL库的一些问题以及如何使用Pillow替代</a></p>

<p>问题2.<a href="http://stackoverflow.com/questions/18504835/pil-decoder-jpeg-not-available-on-ubuntu-x64">decoder jpeg not available</a></p>

<p>Pillow is the “friendly PIL fork”,PIL is the Python Imaging Library.</p>

<p>最重要的类就是<code>Image</code>,Image的open方法打开图片文件，如果成功则返回Image对象，包含一些方法和属性(如<code>format</code>,<code>size</code>,<code>mode</code>等),如果打开失败则触发<code>IOError</code>异常。</p>

<p><a href="http://pillow.readthedocs.org/reference/Image.html#PIL.Image.open"><code>open()</code></a>打开文件</p>

<p><a href="http://pillow.readthedocs.org/reference/Image.html#PIL.Image.Image.save"><code>save()</code></a>保存文件，保存文件的时候文件名变得重要了。除非你指定格式，否则这个库将会以文件名的扩展名作为格式保存。<code>save('a.jpg')</code>或<code>save('a.t', 'PNG')</code></p>

<p>更多内容就要参考文档了，熟悉它们是关键。</p>

<h2>2&#46;不罗嗦了，直接代码</h2>

<pre><code># coding=utf-8
__author__ = 'fang'
import base64
import urllib2
import cStringIO
from PIL import Image

def ImageScale(url):
    file = cStringIO.StringIO(urllib2.urlopen(url).read())
    img = Image.open(file)
    return img

def make_thumb(im, count):
    """生成缩略图"""
    width, height = im.size
    size = 100
    # 裁剪图片成正方形
    if width &gt; height:
        delta = (width - height) / 2
        box = (delta, 0, delta+height, height)
        region = im.crop(box)
    elif height &gt; width:
        delta = (height - width) / 2
        box = (0, delta, width, delta+width)
        region = im.crop(box)
    else:
        region = im

    thumb = region.resize((size, size), Image.ANTIALIAS)
    thumb = circle(thumb)
    return thumb

def merge_thumb(im_iterables, size=(340,340)):
    """合并图片"""

    # 新建一个白色底的图片
    merge_img = Image.new('RGB', size, 0xffffff)
    w_padding, h_padding = 10, 10
    for index, img in enumerate(chunks(im_iterables, 3)):
        # 把图片粘贴上去
        im_size = img[0].size[0]

        if index == 0:
            for i, j in enumerate(img):
                merge_img.paste(j, (w_padding * (i + 1) + (im_size * i), h_padding))
        elif index == 1:
            for i, j in enumerate(img):
                merge_img.paste(j, (w_padding * (i + 1) + (im_size * i), h_padding * 2 + im_size))

        else:
            for i, j in enumerate(img):
                merge_img.paste(j, (w_padding * (i + 1) + (im_size * i), h_padding * 3 + im_size * 2))

    merge_img.show()
    # 图片保存到StringIO中
    out = cStringIO.StringIO()
    merge_img.save(out, format='png')
    s = out.getvalue()
    out.close()
    bs = base64.b64encode(s)
    return bs



def circle(ima):
    size = ima.size
    # 因为是要圆形，所以需要正方形的图片
    r2 = min(size[0], size[1])
    if size[0] != size[1]:
        ima = ima.resize((r2, r2), Image.ANTIALIAS)
    imb = Image.new('RGBA', (r2, r2),(255,255,255,0))
    pima = ima.load()
    pimb = imb.load()
    r = float(r2/2) #圆心横坐标
    for i in range(r2):
        for j in range(r2):
            lx = abs(i-r+0.5) #到圆心距离的横坐标
            ly = abs(j-r+0.5)#到圆心距离的纵坐标
            l  = pow(lx,2) + pow(ly,2)
            if l &lt;= pow(r, 2):
                pimb[i,j] = pima[i,j]
    return imb



def chunks(arr, n):
    '''
    arr是被分割的list，n是每个chunk中含n元素。
    '''
    return [arr[i:i+n] for i in range(0, len(arr), n)]



if __name__ == '__main__':
    #test
    img_url = "http://www.qqtn.com/up/2011-2/201121495218648.jpg"

    imageUrls = (
        img_url,
        "http://img.zcool.cn/community/0331b3e554c741900000158fcefdfd7.jpg@250w_188h_1c_1e",
        "http://image.zcool.com.cn/2013/32/0/m_1374216571289.jpg",
        "http://img.zcool.cn/community/033fd22554c734300000158fc577f10.jpg@250w_188h_1c_1e",
        "http://image.zcool.com.cn/2011/03/114/58/m_1299928906662.jpg",
        "http://image.zcool.com.cn/2011/03/14/110/m_1299928505392.jpg",
        "http://img.zcool.cn/community/03396c7554c7ece00000158fc8a411a.jpg"
    )

    count = len(imageUrls)
    im_lists = [make_thumb(ImageScale(i), count) for i in imageUrls[:9]]
    merge_thumb(im_lists)
</code></pre>

<h2>3&#46;todo</h2>

<ol>
<li>更换背景色</li>
<li>图片加有色边框，椭圆化</li>
<li>优化生成时间</li>
</ol>

<p><strong>Python计算机视觉编程是本好书！</strong></p>
