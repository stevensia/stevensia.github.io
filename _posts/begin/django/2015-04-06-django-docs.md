---
layout: post
title: "高效利用django文档"
description: "高效利用django文档"
category: "django"
tags: [django]
---

<blockquote>
  <p>"Care about your craft"
  "注重时效的程序员,不要完成工作,还要完成的漂亮!"
  --&lt;&lt;程序员修炼之道>></p>
</blockquote>

<p>是啊,在程序生涯中,很多时候往往是事倍功半的状态,在<a href="http://blog.beginman.cn/blog/78/">&lt;&lt;心理效应的背后>></a>中曾提到"80/20法则",<strong>注重时效就是从生活的深层去探索，找出那些关键的20％，以达到80％的好处.</strong></p>

<p>关于Django文档的学习过程中,也要遵从该法则.这里总结几点:</p>

<h1>1.学会高效地查询文档</h1>

<p><strong>哪些是刚需,哪些是要注意的,哪地方是需要后期慢慢接触的,哪些是我们项目中要用到的...等等都要搞明白.还有一点就是不能死啃,一定要结合项目,不是什么都要看,而是看着重点,看了那么多没用到就是浪费;忘记了就是浪费什么,一定要在脑袋里有个模型,哪怕是概念性的东西,起码用的时候我们找到在文档中的哪个地方,或者我能通过文档能够使用在自己的项目中.</strong></p>

<!--more-->

<h1>2.搞清楚文档的脉络</h1>

<p>如下根据Django1.5文档生成的脉络:</p>

<h2>模型层(model)</h2>

<p><strong>模型(Models)</strong>: <a href="https://docs.djangoproject.com/en/1.5/topics/db/models/">模型语法( Model syntax )</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/models/fields/">字段类型(Field types)</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/models/options/">Meta选项(Meta options)</a></p>

<p><strong>查询集(QuerySets)</strong>: <a href="https://docs.djangoproject.com/en/1.5/topics/db/queries/">执行查询( Executing queries)</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/models/querysets/">QuerySet 方法参考(QuerySet method reference)</a></p>

<p><strong>模型实例(Model instances)</strong>: <a href="https://docs.djangoproject.com/en/1.5/ref/models/instances/">Instance 方法( Instance methods)</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/models/relations/">访问关联对象(Accessing related objects)</a></p>

<p><strong>进阶(Advanced)</strong>: <a href="https://docs.djangoproject.com/en/1.5/topics/db/managers/">管理器(Managers)</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/db/sql/">SQL 语句查询( Raw SQL)</a> |<a href="https://docs.djangoproject.com/en/1.5/topics/db/transactions/">事务( Transactions)</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/db/aggregation/">数据处理(Aggregation 或称Data Aggregation )</a> | <a href="https://docs.djangoproject.com/en/1.5/howto/custom-model-fields/">自定义字段( Custom fields)</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/db/multi-db/">多数据库(Multiple databases)</a></p>

<p><strong>其他(Other)</strong>: <a href="https://docs.djangoproject.com/en/1.5/ref/databases/">支持的数据库(Supported databases)</a> | <a href="https://docs.djangoproject.com/en/1.5/howto/legacy-databases/">遗留型旧数据库(Legacy databases )</a> | <a href="https://docs.djangoproject.com/en/1.5/howto/initial-data/">为模型提供初始数据( Providing initial data)</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/db/optimization/">优化数据库访问(Optimize database access)</a></p>

<h2>视图层(Views)</h2>

<p><strong>基础(The basics)</strong>: <a href="https://docs.djangoproject.com/en/1.5/topics/http/urls/">URL配置(URLconfs)</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/http/views/">视图函数(View functions )</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/http/shortcuts/">快捷方法( Shortcuts)</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/http/decorators/">装饰器(Decorators)</a></p>

<p><strong>参考(Reference)</strong>:<a href="https://docs.djangoproject.com/en/1.5/ref/views/">内置视图(Built-in Views )</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/request-response/">Request/response 对象</a> |<a href="https://docs.djangoproject.com/en/1.5/ref/template-response/">TemplateResponse 对象</a></p>

<p><strong>文件上传(File uploads)</strong>: <a href="https://docs.djangoproject.com/en/1.5/topics/http/file-uploads/">概述( Overview)</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/files/file/">File 对象</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/files/storage/">存储 API</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/files/">文件管理</a> | <a href="https://docs.djangoproject.com/en/1.5/howto/custom-file-storage/">自定义存储(Custom storage)</a></p>

<p><strong>视图基类(Class-based views)</strong>: <a href="https://docs.djangoproject.com/en/1.5/topics/class-based-views/">概述(Overview)</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/class-based-views/generic-display/">内置显示视图( Built-in display views)</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/class-based-views/generic-editing/">内置编辑视图( Built-in editing views)</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/class-based-views/mixins/">混合使用( Using mixins)</a> |<a href="https://docs.djangoproject.com/en/1.5/ref/class-based-views/"> API 参考</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/class-based-views/flattened-index/">分类索引(Flattened index)</a></p>

<p><strong>进阶(Advanced)</strong>: <a href="https://docs.djangoproject.com/en/1.5/howto/outputting-csv/">生成 CSV(Generating CSV)</a> | <a href="https://docs.djangoproject.com/en/1.5/howto/outputting-pdf/">生成 PDF</a></p>

<p><strong>中间件(Middleware)</strong>: <a href="https://docs.djangoproject.com/en/1.5/topics/http/middleware/">概述</a> |<a href="https://docs.djangoproject.com/en/1.5/ref/middleware/">内置中间件</a></p>

<h2>模板层(template)</h2>

<p><strong>For 设计师</strong>: <a href="https://docs.djangoproject.com/en/1.5/topics/templates/">语法概述</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/templates/builtins/">内置 tags 和 filters</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/contrib/webdesign/">Web 设计助手</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/contrib/humanize/">人性化( Humanization)</a></p>

<p><strong>For 程序员</strong>: <a href="https://docs.djangoproject.com/en/1.5/ref/templates/api/">模板 API</a> | <a href="https://docs.djangoproject.com/en/1.5/howto/custom-template-tags/">自定义 tags 和 filters</a></p>

<h2>表单(Forms)</h2>

<p><strong>基础</strong>: <a href="https://docs.djangoproject.com/en/1.5/topics/forms/">概述</a> |<a href="https://docs.djangoproject.com/en/1.5/ref/forms/api/">表单 API</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/forms/fields/">内置字段</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/forms/widgets/">内置小工具</a></p>

<p><strong>进阶</strong>: <a href="https://docs.djangoproject.com/en/1.5/topics/forms/modelforms/">模型表单( Forms for models )</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/forms/media/">表单外观(Integrating media )</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/forms/formsets/">表单集(Formsets )</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/forms/validation/">自定义验证(Customizing validation)</a></p>

<p><strong>附加功能(Extras)</strong>: <a href="https://docs.djangoproject.com/en/1.5/ref/contrib/formtools/form-preview/">表单预览(Form preview)</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/contrib/formtools/form-wizard/">表单向导(Form wizard)</a></p>

<h2>开发流程</h2>

<p><strong>设置</strong>: <a href="https://docs.djangoproject.com/en/1.5/topics/settings/">概述</a> | <a href="https://docs.djangoproject.com/en/1.5/ref/settings/">全部设置列表</a></p>

<p><strong>异常</strong>: <a href="https://docs.djangoproject.com/en/1.5/ref/exceptions/">概述</a></p>

<p><strong>django-admin.py 和 manage.py</strong>: <a href="https://docs.djangoproject.com/en/1.5/ref/django-admin/">概述</a> | <a href="https://docs.djangoproject.com/en/1.5/howto/custom-management-commands/">添加自定义命令</a></p>

<p><strong>测试</strong>: <a href="https://docs.djangoproject.com/en/1.5/topics/testing/">介绍</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/testing/overview/">编写和运行测试</a> |<a href="https://docs.djangoproject.com/en/1.5/topics/testing/advanced/"> 进阶主题</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/testing/doctests/">Doctests</a></p>

<p><strong>部署(Deployment)</strong>: <a href="https://docs.djangoproject.com/en/1.5/howto/deployment/">概述</a> | <a href="https://docs.djangoproject.com/en/1.5/howto/deployment/wsgi/">WSGI servers </a>| <a href="https://docs.djangoproject.com/en/1.5/howto/deployment/fastcgi/">FastCGI/SCGI/AJP</a> | <a href="https://docs.djangoproject.com/en/1.5/howto/static-files/deployment/">处理静态文件</a> | <a href="https://docs.djangoproject.com/en/1.5/howto/error-reporting/">通过电子邮件跟踪代码中的错误</a></p>

<h2>管理(The admin)</h2>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/admin/">管理网站</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/admin/actions/">管理操作</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/admin/admindocs/">管理文档生成器</a></p>

<h2>安全(Security)</h2>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/security/">安全概述</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/clickjacking/">Clickjacking 防护</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/csrf/">跨站请求伪造防护</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/signing/">加密签名(Cryptographic signing)</a></p>

<h2>国际化和本地化</h2>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/i18n/">概述</a> |<a href="https://docs.djangoproject.com/en/1.5/topics/i18n/translation/"> 国际化</a> | <a href="https://docs.djangoproject.com/en/1.5/topics/i18n/translation/#how-to-create-language-files">本地化</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/localflavor/">“Local flavor”</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/i18n/timezones/">时区(Time zones)</a></p>

<h2>常用的web应用工具</h2>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/auth/">认证</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/cache/">缓存</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/logging/">日志</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/email/">发送电子邮件</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/syndication/">聚合供稿(RSS/Atom)</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/comments/">评论</a>, <a href="https://docs.djangoproject.com/en/1.5/ref/contrib/comments/moderation/">评论审核</a> 和 <a href="https://docs.djangoproject.com/en/1.5/ref/contrib/comments/custom/">自定义评论</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/pagination/">分页</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/messages/">消息框架</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/serialization/">序列化(Serialization)</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/http/sessions/">Sessions</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/sitemaps/">站点地图</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/staticfiles/">静态文件管理</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/validators/">数据验证</a></p>

<h2>其他核心功能</h2>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/conditional-view-processing/">按需处理内容</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/contenttypes/">内容类型和泛型关系</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/databrowse/">数据浏览</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/flatpages/">简单页面</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/redirects/">重定向</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/topics/signals/">信号</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/contrib/sites/">sites 框架</a></p>

<p><a href="https://docs.djangoproject.com/en/1.5/ref/unicode/">在 Django 中使用 Unicode</a></p>

<p><img src="http://personalexcellence.co/blog/images/watch.jpg" alt="" /></p>

<p><strong>一入代码深似海,共勉吧!</strong></p>
