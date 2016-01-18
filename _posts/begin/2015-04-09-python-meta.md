---
layout: post
title: "理解python的元类"
description: "理解python的元类"
category: "python"
tags: [python技巧]
---

<h2>推荐阅读</h2>

<p>关于Python 元类的学习，这篇文章堪称一绝：</p>

<p>原文：<a href="http://stackoverflow.com/questions/100003/what-is-a-metaclass-in-python"><strong>What is a metaclass in Python?</strong></a></p>

<p>翻译：<a href="http://blog.jobbole.com/21351/"><strong>深刻理解Python中的元类(metaclass)</strong></a></p>

<p><img src="http://www.linuxidc.com/upload/2012_04/120404073636141.png" alt="" /></p>

<p><strong>个人小结：</strong></p>

<blockquote>
  <p>1.<code>type()</code>是个内建元类，能够动态创建类：</p>
</blockquote>

<pre><code>type(类名, 父类的元组（针对继承的情况，可以为空），包含属性的字典（名称和值）) 
</code></pre>

<blockquote>
  <p>2.<code>__metaclass__</code>属性定义了元类，如果一个类，或模块中找到它则对于类的创建会通过它来控制，否则就通过<code>type</code>来控制。</p>
  
  <p>3.自定义元类，通过继承<code>type</code>，并重写<code>__new__()</code>实现
      [python]
      class Person(type):
          def <strong>new</strong>(cls, name, base, dct):
              print dct
              attrs = dict([(name.upper(), value) for name, value in dct.items() if not name.startswith('<strong>')])
              return super(Person, cls).__new</strong>(cls, name, base, attrs)</p>
</blockquote>

<pre><code>p = Person('cName',(), {'age':18})
print hasattr(p, 'age')   #false
print hasattr(p, 'AGE')   # true
[/python]
</code></pre>

<blockquote>
  <p>4.元类最浅显的理解就是：拦截类的创建--修改类--返回定制后的类</p>
  
  <p>5.元类的用处并不多，但最好理解它，常用之处如：Django ORM.对于models的处理，或在django1.5以下通过扩展User表等。</p>
</blockquote>

<!--more-->

<h2>扩展django  auth_user</h2>

<pre><code>[python]
# -*- coding: utf-8 -*-
from django.db import models
from django.contrib.auth.models import User
from django.contrib.auth.admin import UserAdmin
import datetime
class ProfileBase(type):
    def __new__(cls, name, bases, attrs):
        module = attrs.pop('__module__')
        parents = [b for b in bases if isinstance(b, ProfileBase)]
        if parents:
            fields = []
            for obj_name, obj in attrs.items():
                if isinstance(obj, models.Field): fields.append(obj_name)
                User.add_to_class(obj_name, obj)
            #UserAdmin.fieldsets = list(UserAdmin.fieldsets)
            #UserAdmin.fieldsets.append((name, {'fields': fields}))
        return super(ProfileBase, cls).__new__(cls, name, bases, attrs)

class Profile(object):
    __metaclass__ = ProfileBase

class MyProfile(Profile):
    nickname = models.CharField(max_length = 255)
    birthday = models.DateTimeField(null = True, blank = True)
    city = models.CharField(max_length = 30, blank = True)
    university = models.CharField(max_length = 255, blank = True)

    def is_today_birthday(self):
        return self.birthday.date() == datetime.date.today()
    [/python]
</code></pre>

<blockquote>
  <p>上面的代码中定义了一个ProfileBase的元类，然后定义了一个作为Profile基类的Profile类，并且它的元类为ProfileBase。
  元类的作用简单来讲，就是创建其他类的类。也就是元类的实例是普通类，而普通类的实例就是普通的实例。
  如果你不理解这些也没关系，只要知道，上面的代码中，当解释器看到你在定义一个Profile类的子类，而Profile类的元类是ProfileBase，所以MyProfilede的元类也是ProfileBase，也就是在定义任何Profile的子类的时候，它就会执行元类ProfileBase中的<strong>new</strong>中代码，并且将正在定义的类的（名字，基类，类属性）作为参数传递给<strong>new</strong>。</p>
  
  <p>MyProfilede中的field采用了和普通Model相同的声明语法，所以这些field和那个自定义方法is_today_birthday会作为attrs中的属性传递过去，然后元类中将这些信息提取出来通过 User.add_to_class(obj_name, obj) 加入到User类中，add_to_class也是普通Model中定义field时采用的方式，因为普通Model也有一个元类在做相似的事情，只不过这里定义的这个元类专门往User Model中加东西。</p>
  
  <p>在添加完这些field和自定义方法后，前面识别出哪些属性是field，然后加入到UserAdmin.fieldsets中，那样在admin中就可以和其他User fields 一起编辑这些新加的field了。</p>
  
  <p>如果你有其他app也想往User Model中加field或方法，都只要通过子类Profile类，然后使用声明语法进行定义即可，所有其他工作都有元类帮你完成。</p>
  
  <p>通过这种方式添加到User Model中的field和方法的效果就和直接修改Django User Model的源码一样，只不过现在这些修改不用再像修改源码这么暴力了，而且想添的时候随便可以添。</p>
</blockquote>

<p>该代码参考：<a href="http://onlypython.group.iteye.com/group/wiki/1519-expansion-django-user-model-by-non-profile-way"><strong>非profile方式扩展Django User Model</strong></a></p>
