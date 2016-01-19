---
layout: post
title:  Git configuration
date:   2015-12-05 13:08:47
categories: tools
excerpt: git
---
* content
{:toc}

###Before
最近学习了一点GIT的知识，用起来也很方便，这篇文章是用来记录一些常用的命令和配置，后续有新的知识点会更新进来。

---  

####Git alias config

>You can find below tips from [here](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/001375234012342f90be1fc4d81446c967bbdc19e7c03d3000)   

    #!/bin/sh
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.ci commit
    git config --global alias.br branch
    git config --global alias.last 'log -1'
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

---

####Git password cache setting  
We can make git store password in cache, then stop keeping input password for every git push.

    #!/bin/sh
    git config --global credential.helper cache  
    #Set git to use the credential memory cache**  

    git config --global credential.helper 'cache --timeout=3600'
    # Set the cache to timeout after 1 hour (setting is in seconds)


>This is where I found this [setting](https://help.github.com/articles/caching-your-github-password-in-git/#platform-linux)
