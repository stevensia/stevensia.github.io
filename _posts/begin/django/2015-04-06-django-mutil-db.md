---
layout: post
title: "django多数据库配置"
description: "django多数据库配置"
category: "django"
tags: [django]
---

<h1>一.设置settings.py数据库实例</h1>

<p>django需要一个默认的数据库实例,如settings.py中的<code>DATABASES</code>字典中的<code>default</code>字典.如果不需要则也可以不指定.如:</p>

<pre><code>DATABASES = {
    'default': {},
    'users':{
        'NAME': 'user_data',
        'ENGINE':'django.db.backends.mysql',
        'PASSWORD':'12345'
    },
}
</code></pre>

<p>数据库别名可以随便起,但default有特殊意义,<strong>当没有选择其他数据库时， Django 总是使用别名为 default 的数据库。因此，如果你没有定义一个名为 default 的数据库时，你应当小心了，在使用数据库前要指定你想用的数据库</strong></p>

<!--more-->

<h1>二.数据库同步</h1>

<p><code>syncdb</code>默认同步一个数据库且默认是default.如果指定数据库,可这样:</p>

<pre><code>$ ./manage.py syncdb
$ ./manage.py syncdb --database=otherDb
</code></pre>

<h1>三.自定义数据库路由</h1>

<p>假设项目下myapp使用的model是数据库'other', 那么设置路由的时候要指定哪个app要使用对应的数据库.关于数据库路由的规则可参考:</p>

<pre><code>class MyAppRouter(object):
""" 一个控制 myapp 应用中模型的
所有数据库操作的路由 """

  def db_for_read(self, model, **hints):
      "myapp 应用中模型的操作指向 'other'"
      if model._meta.app_label == 'myapp':
          return 'other'
      return None

  def db_for_write(self, model, **hints):
      "myapp 应用中模型的操作指向 'other'"
      if model._meta.app_label == 'myapp':
          return 'other'
      return None

  def allow_relation(self, obj1, obj2, **hints):
      " 如果包含 myapp 应用中的模型则允许所有关系 "
      if obj1._meta.app_label == 'myapp' or obj2._meta.app_label == 'myapp':
        return True
      return None

  def allow_syncdb(self, db, model):
      " 确保 myapp 应用只存在于 'other' 数据库 "
      if db == 'other':
          return model._meta.app_label == 'myapp'
      elif model._meta.app_label == 'myapp':
          return False
      return None

class MasterSlaveRouter(object):
""" 一个设置简单主/从定义的路由 """

 def db_for_read(self, model, **hints):
    if model._meta.app_label == 'myapp':
        return 'other'
    return 'default'

def db_for_write(self, model, **hints):
    if model._meta.app_label == 'myapp':
        return 'other'
    return 'default'

  def allow_relation(self, obj1, obj2, **hints):
      " 允许数据库池中的两个对象间的任何关系 "
      db_list = ('master','slave1','slave2')
      if obj1._state.db in db_list and obj2._state.db in db_list:
          return True
      return None

  def allow_syncdb(self, db, model):
      " 显示地放置所有数据库中的模型 "
      return True
</code></pre>

<p>然后在settings.py中引入路由:</p>

<pre><code>DATABASE_ROUTERS = ['path.to.MyAppRouter', 'path.to.MasterSlaveRouter']
</code></pre>

<p>这个设置中，路由的顺序是很重要的，因为查询时是按这个设置中的顺序依次查询的。上 例中， MyAppRouter 先于 MasterSlaveRouter ，因此， myapp 中的模型就 优先于其他模型。如果 DATABASE_ROUTERS 设置中两个路由的顺序变换了， 那么 MasterSlaveRouter.allow_syncdb() 会优先执行。因为 MasterSlaveRouter 是 包罗万象的，这样就会导致所有模型可以使用所有数据库。</p>

<p>更多内容参考:<a href="http://docs.oneele.com/django/topics/db/multi-db.html"><strong>使用多个数据库</strong></a> 或 <a href="https://docs.djangoproject.com/en/1.5/topics/db/multi-db/"><strong>文档</strong></a></p>

<p><img src="http://alpha.hstor.org/storage2/4b1/f6c/742/4b1f6c7425737f726b2b1b9d1828fb6a.png" alt="" /></p>
