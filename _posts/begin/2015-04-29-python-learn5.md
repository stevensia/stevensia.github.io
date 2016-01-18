---
layout: post
title: "python装饰器小结"
description: "python装饰器小结"
category: "Python"
tags: [Python]
---

## 1. 如下例子以函数对象作为参数实现装饰

    # code 1:

    def deco(fn):
        print "bef..."
        fn()
        print "end..."
        return fn           # 返回原函数对象

    def func():
        print 'fun'

    myfun = deco(func)      # 将原函数对象func赋值给变量myfun
    print '---------'
    myfun()                 # 执行原函数对象func
    print '*********'
    myfun()                 # 执行原函数对象func


运行后的结果如下：

    bef...
    fun
    end...
    ---------
    fun
    *********
    fun


该例中`deco()`打印bef,end,执行原函数(`fn()`)，然后返回原函数对象(`fn`), 那么`myfun`就是返回的原函数对象`fn`。再看第二个例子：

    代码2：

    def deco(fn):
        def wrapper():      # 在实例1基础上又包装了一层函数
            print "bef..."
            fn()
            print "end..."
                                 # 这里不再返回原函数对象
        return wrapper           # 返回wrapper函数对象

    def func():
        print 'fun'

    myfun = deco(func)          # 将wrapper函数对象赋值给myfun
    print '--------'
    myfun()                     # 执行wrapper函数
    print '*********'
    myfun()                     # 执行wrapper函数


运行后的结果：

    ---------
    bef...
    fun
    end...
    *********
    bef...
    fun
    end...


两种代码不同之处在于：

- 代码1.发现新函数只在第一次被调用，且原函数多调用了一次
- 代码2.装饰函数返回内嵌包装函数对象保证了每次新函数都被调用

**如上所见如果我们要装饰一个函数，一定要定义装饰函数(如deco)接收被装饰的函数(如func)作为参数，如`def deco(fn)`，并返回内部的包装函数对象(`return wrapper`)**

## 2.语法糖形式的装饰器
### (1).语法糖

如果将`myfun = deco(func)`变相以下，就成了如下方式：

    @deco
    def func():
        .....

**这种变相的方式就称为`装饰器`，所谓的装饰器就是`@`语法糖- Syntactic Sugar的形式来包装一个函数。这种包装作用就是在函数执行前处理某某，在函数执行后处理某某。**

如下实例：

    def deco(fn):
        def wrapper(*args, **kwargs):
            return fn(*args, **kwargs)

        return wrapper

    def fun(a, b):
        return a+b

    # 将函数作为参数的直接形式
    myfun = deco(fun)               # 将wrapper函数对象赋值给myfun
    print myfun(100, 200)           # 调用wrapper函数,返回fn回调函数的值

    
    # 装饰器形式
    @deco
    def foo(a, b):
        return a+b

    print foo(100,200)          # 300

### (2).让装饰器带参数
让装饰器带参数，则需要在原先的基础上的最外层再包裹一层函数，用于接收参数。

    def deco(*args, **kwargs):
        # 内嵌一个真正的装饰函数
        def true_deco(fn):
            def wrapper(*args, **kwargs):
                # 返回原函数执行的结果
                return fn(*args, **kwargs)

            # 返回wrapper函数装饰对象
            return wrapper

        print 'the deco values is:', args, kwargs
        # 返回真正的装饰函数 true_deco
        return true_deco


    @deco(1,2)
    def fun(a, b):
        return a + b

    print fun(100, 200)

执行结果如下：

    the deco values is: (1, 2) {}
    300

**总结：无论包装函数包裹了多少层，一定要返回一个真正的包装函数**, 如下：

    def deco1(*args, **kwargs):
        def deco1__(fn):
            print u'deco1__'
            def wrapper(*args, **kwargs):
                print u'wrapper....'
                return fn(*args, **kwargs)

            return wrapper
        print 'deco1....%d' % (sum(args))
        return deco1__

    def foo(a, b):
        return 'foo---%d' % (a + b)

    # 以函数对象传参形式
    f = deco1(1, 3)         # deco1....
    ff = f(foo)             # deco1__
    fff = ff(100, 200)      # wrapper....
    print fff               # foo---300

如果以装饰器则：

    @deco1(1, 3)  # 返回 deco1__函数对象, 然后并将foo函数对象作为参数(`fn`)，返回wrapper函数对象
    def foo(a, b):
        return 'foo---%d' % (a + b)

    # 运行结果
    deco1....4
    deco1__

    # 执行新的包装函数
    print foo(100, 200)
    # 运行结果
    wrapper....
    foo---300


### (3).多个包装函数

    def deco1(*args, **kwargs):
        def deco1__(fn):
            print u'deco1__'
            def wrapper(*args, **kwargs):
                print u'wrapper....'
                return fn(*args, **kwargs)

            return wrapper
        print 'deco1....%d' % (sum(args))
        return deco1__


    def deco2(fn):
        def wrapper(*args, **kwargs):
            print 'deco2..wrapper..'
            return fn(*args, **kwargs)

        print u'deco2.....'
        return wrapper


    @deco1(1, 3)        # 返回 deco1__函数对象, 然后并将deco2函数对象作为参数(`fn`)，返回wrapper函数对象
    @deco2              # deco2函数将foo对象传入
    def foo(a, b):
        return a + b

    print '-------------------'
    print foo(100, 200)


执行结果：

    deco1....4
    deco2.....
    deco1__
    -------------------
    wrapper....
    deco2..wrapper..
    300

上面装饰器写法等同于：

    myfoo = deco1(1, 2)(deco2(foo))
    print myfoo(100, 200)

## 3.类装饰器

    class ClassDeco(object):
        def __init__(self, fn, *args, **kwargs):
            self.fn = fn
            self.arg = args
            self.kwargs = kwargs

        def __call__(self, *args, **kwargs):
            return self.fn(*args, **kwargs)


    @ClassDeco
    def fuc(a,b):
        return a + b

    print fuc(1, 2)         # 3

    myfunc = ClassDeco(fuc)
    print myfunc(1, 2)      # 3

类装饰器实现方式2：

    class ClassDeco(object):
        def __init__(self, *args, **kwargs):
            self.arg = args
            self.kwargs = kwargs

        def __call__(self, fn, *args, **kwargs):
            def wrapper(*args, **kwargs):
                return fn(*args, **kwargs)

            return wrapper

    @ClassDeco(100,200)
    def fuc(a,b):
        return a + b

    print fuc(1, 2)         # 3

    myfunc = ClassDeco(100,200)(fuc)
    print myfunc(1, 2)      # 3

如上实现了2个类装饰器，实现要点如下：

如果类装饰器不需要参数：

- `__init__`定义被装饰的函数
- `__call__`成为装饰函数，调用`init中被装饰的函数

如果类装饰器需要参数:

- `__init__`初始化参数，不再定义被装饰的函数
- `__call__`成为装饰函数，同时被装饰的函数作为其参数传入

## 4.装饰器带来的副作用

副作用就是：**被装饰的函数转换成了另一个函数**

    def deco(fn):
        def wrapper():
            print fn.__name__       # foo
        return wrapper

    @deco
    def func():
        print 'hello'

    func()

    print func.__name__     # wrapper

这里就要用到`warps`装饰器了，**它可以把被封装函数的name、module、doc和 dict都复制到封装函数去(模块级别常量WRAPPER_ASSIGNMENTS, WRAPPER_UPDATES)

    from functools import wraps
        def deco(fn):
            @wraps(fn)
            def wrapper():
                print fn.__name__   # func
            return wrapper

    @deco
    def func():
        print 'hello'

    func()

    print func.__name__     # func

## 5.实践

- [mysql 装饰器](https://gist.github.com/BeginMan/1139628e64d654b67e36)
- [高效带缓存的斐波那契数列](https://gist.github.com/BeginMan/a8ea401eca61de41e18e)
- [python程序运行计时装饰器](https://gist.github.com/BeginMan/d40a08a2a9bf35cc9f02)
- [日志打印装饰类](https://gist.github.com/BeginMan/bf229030727d2cff9e21)

