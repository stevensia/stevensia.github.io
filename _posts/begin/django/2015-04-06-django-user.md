---
layout: post
title: "django用户扩展,管理,登陆"
description: "django用户扩展,管理,登陆"
category: "django"
tags: [django]
---

<h1>一.扩展方式1:非profile方式扩展Django User Model</h1>

<p>这个通过方式动态的修改User Model类来实现扩展,全文见:<a href="http://onlypython.group.iteye.com/group/wiki/1519-expansion-django-user-model-by-non-profile-way"><strong>非profile方式扩展Django User Model</strong></a>, <strong>这段代码和实现的理念非常值得研究.</strong></p>

<!--more-->

<pre><code># -*- coding: utf-8 -*-
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
            UserAdmin.fieldsets = list(UserAdmin.fieldsets)
            UserAdmin.fieldsets.append((name, {'fields': fields}))
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
</code></pre>

<p>在扩展的同时可以修改<strong>生成用户方法</strong>,需要在扩展类如上MyProfile加上objects对象(modelManager)如下:</p>

<pre><code>.....
class MyProfile(Profile):
    nickname = models.CharField(max_length = 255)
    birthday = models.DateTimeField(null = True, blank = True)
    city = models.CharField(max_length = 30, blank = True)
    university = models.CharField(max_length = 255, blank = True)
    objects = UserManager_()              # 这里

    def is_today_birthday(self):
        return self.birthday.date() == datetime.date.today()



 #modelManage.py

 #coding=utf-8
import datetime
from django.db import models


class UserManager_(models.Manager):
    def create_user_(self, username, type, password=None, **kwargs):
        now = datetime.datetime.now()
        user = self.model(username=username, type=type, is_staff=False,
                         is_active=True, is_superuser=False, last_login=now,
                         date_joined=now)

        user.set_password(password)
        user.save(using=self._db)
        return user
</code></pre>

<h1>二. django1.5+ 的扩展方式</h1>

<p>在django1.5以上版本django提供了扩展方式,如下:</p>

<pre><code>#coding=utf-8
from django.conf import settings
from django.db import models
from django.contrib.auth.models import BaseUserManager, AbstractBaseUser


class UserManager(BaseUserManager):
    """通过邮箱，密码创建用户"""
    def create_user(self, email,username, password=None,type=None,**kwargs):
        if not email:
            raise ValueError(u'用户必须要有邮箱')

        user = self.model(
            email=UserManager.normalize_email(email),
            username=username,
            type=type if type else 0
        )
        user.set_password(password)
        if kwargs:
            if kwargs.get('sex', None): user.sex = kwargs['sex']
            if kwargs.get('is_active', None): user.is_active=kwargs['is_active']
            if kwargs.get('uid', None): user.uid=kwargs['uid']
            if kwargs.get('token', None): user.token=kwargs['token']
            if kwargs.get('url', None): user.url=kwargs['url']
            if kwargs.get('desc', None): user.desc=kwargs['desc']
            if kwargs.get('avatar', None): user.avatar=kwargs['avatar']

        user.save(using=self._db)
        return user

    def create_superuser(self, email, username, password):
        """
        Creates and saves a superuser with the given email, date of
        birth and password.
        """
        user = self.create_user(email,
            password=password,
            username=username,
        )
        user.is_admin = True
        user.save(using=self._db)
        return user


class MyUser(AbstractBaseUser):
    """扩展User"""
    email = models.EmailField(verbose_name='Email', max_length=255, unique=True,db_index=True)
    username = models.CharField(max_length=50, unique=True, db_index=True)
    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)
    type = models.IntegerField(default=0)                   # 类型，0本站，1微博登录,-1:尚未通过邮箱验证
    sex = models.IntegerField(default=1)                    # sex
    url = models.URLField(null=True)                            # 个人站点
    desc = models.CharField(max_length=2000, null=True)         # 个人信息简介
    avatar = models.CharField(max_length=500, null=True)        # 头像
    token = models.CharField(max_length=500)                    # 验证
    objects = UserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    def get_full_name(self):
        # The user is identified by their email address
        return self.email

    def get_short_name(self):
        # The user is identified by their email address
        return self.email

    def __unicode__(self):
        return self.email

    def has_perm(self, perm, obj=None):
        "Does the user have a specific permission?"
        # Simplest possible answer: Yes, always
        return True

    def has_module_perms(self, app_label):
        "Does the user have permissions to view the app `app_label`?"
        # Simplest possible answer: Yes, always
        return True

    @property
    def is_staff(self):
        "Is the user a member of staff?"
        # Simplest possible answer: All admins are staff
        return self.is_admin


    class Meta:
        db_table = 'user'


class CustomAuth(object):
    """自定义用户验证"""
    def authenticate(self, email=None, password=None):
        try:
            user = MyUser.objects.get(email=email)
            if user.check_password(password):
                return user
        except MyUser.DoesNotExist:
            return None

    def get_user(self, user_id):
        try:
            user = MyUser.objects.get(pk=user_id)
            if user.is_active:
                return user
            return None
        except MyUser.DoesNotExist:
            return None
</code></pre>

<p>具体参考文档.</p>

<h1>注册后登陆</h1>

<p>如上述一, 完成扩展后这里要注册用户,用我们修改过的UserManager_来注册,然后再登陆,<strong>对于注册后登陆,可以使用<code>authenticate()</code> 和 <code>login()</code></strong></p>

<pre><code>User.objects.create_user_(username=us,type=user_type, password=pwd)
        new_user = authenticate(username=us, password=pwd)
        login(request, new_user)
</code></pre>

<p><img src="http://marklol.qiniudn.com/wp-content/uploads/2014/02/37aeb6fe0ca7f23a5e18540c26206dc2.jpg" alt="" /></p>

<p>图片来源:http://www.marklol.com/post/6056</p>
