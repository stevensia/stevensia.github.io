---
layout: post
title: "git撤销与回滚操作"
description: "git撤销与回滚操作"
category: "git"
tags: [git]
---

<blockquote>
  <p>康肃问曰：“汝亦知射乎？吾射不亦精乎？”翁曰：“无他，但手熟尔。”康肃忿然曰：“尔安敢轻吾射！”翁曰：“以我酌油知之。”乃取一葫芦置于地，以钱覆其口，徐以杓酌油沥之，自钱孔入，而钱不湿。因曰：“我亦无他，惟手熟尔。”康肃笑而遣之。                      ----欧阳修《卖油翁》</p>
</blockquote>

<p>学习也是一样,很多东西都要记,在记的过程中实践,熟能生巧.</p>

<p>在操作git时候,总想吃点后悔药,但git确实卖这种药,接下来从git撤销与回滚来兜售这种后悔药.</p>

<p><img src="http://oss.org.cn/attachments/2012/05/5499_201205241616381AVC3.png" alt="" /></p>

<!--more-->

<h1>一.撤消操作</h1>

<h2>1.修改最后一次撤销</h2>

<p>常用修改日志,或者改变你刚刚通过增加，改变，删除而记录的快照等.命令如下:</p>

<pre><code>git commit --amend  
</code></pre>

<p>amend([ə'mend]修改,修订),执行完该命令后会出现log信息编辑页面.如果修改多个提交说明,则使用<code>rebase</code>命令.<code>git rebase</code>增加<code>-i</code>选项来以交互方式地运行rebase,后面还要跟上参数,如修改最近三次的提交说明:</p>

<pre><code>git rebase -i HEAD~3
</code></pre>

<p>运行后会给出编辑框编辑说明,结果如下:</p>

<pre><code>pick f7f3f6d changed my name a bit
pick 310154e updated README formatting and added blame
pick a5f4a0d added cat-file

# Rebase 710f0f8..a5f4a0d onto 710f0f8
#
# Commands:
#  p, pick = use commit
#  e, edit = use commit, but stop for amending
#  s, squash = use commit, but meld into previous commit
#
# If you remove a line here THAT COMMIT WILL BE LOST.
# However, if you remove everything, the rebase will be aborted.
#
</code></pre>

<p>如果什么都不操作,或者<code>:q</code>退出则会出现:</p>

<pre><code>(blog)[beginman@beginman pycode]$ git rebase -i HEAD~3
之前的拣选操作现在是一个空提交，可能是由冲突解决导致的。如果您无论如何
也要提交，使用命令：

    git commit --allow-empty

否则，请使用命令 'git reset'
变基操作正在进行中；至 3b26b98
您在执行将分支 'master' 变基到 '3b26b98' 的操作。

无文件要提交，干净的工作区
Could not apply cec0f6078c9aec232e29c3c5acf8c558e9cc468c... log
(blog)[beginman@beginman pycode]$ git branch
* （非分支，正变基 master）
  master
</code></pre>

<p><strong>HEAD~3..HEAD范围内的每一次提交都会被重写，无论你是否修改说明</strong></p>

<h2>2.取消已暂存的文件</h2>

<p>如果执行了<code>git add .</code>或某个文件,就已经添加到暂存区,如果要把它拖到非暂存区则使用</p>

<pre><code>git reset HEAD &lt;file&gt;..
</code></pre>

<p>当然这条命令在每次git add 后git status会给出相应的提示,<code>git checkout</code>则是对为暂存文件的撤销,撤销到未修改状态,如一个文件想从暂存区中撤销它,可以这样:</p>

<pre><code>git reset HEAD README.md
git checkout README.md
</code></pre>

<h2>3.提交前撤销add操作</h2>

<p>如果已经将不想纳入版本控制的文件撤销,如生效.gitignore,可以使用git rm ,如</p>

<pre><code>git rm -r --cached .svn/
</code></pre>

<h1>二.代码回滚</h1>

<p><strong>本地代码回滚:</strong></p>

<pre><code>git reset --hard commit-id 
git reset --hard HEAD~3  
</code></pre>

<p><strong>远程代码回滚:原理：先将本地分支退回到某个commit，删除远程分支，再重新push本地分支</strong></p>

<pre><code>1、git checkout the_branch

2、git pull

3、git branch the_branch_backup //备份一下这个分支当前的情况

4、git reset --hard the_commit_id //把the_branch本地回滚到the_commit_id

5、git push origin :the_branch //删除远程 the_branch

6、git push origin the_branch //用回滚后的本地分支重新建立远程分支

7、git push origin :the_branch_backup //如果前面都成功了，删除这个备份分支
</code></pre>

<blockquote>
  <p>如果使用了gerrit做远程代码中心库和code review平台，需要确保操作git的用户具备分支的push权限，并且选择了 Force Push选项（在push权限设置里有这个选项）另外，gerrit中心库是个bare库，将HEAD默认指向了master，因此master分支是不能进行删除操作的，最好不要选择删除master分支的策略，换用其他分支。 --参考<a href="http://www.cnblogs.com/qualitysong/archive/2012/11/27/2791486.html">http://www.cnblogs.com/qualitysong/archive/2012/11/27/2791486.html</a></p>
</blockquote>

<h1>三.回滚单个文件</h1>

<p>(1).首先查看该文件的历史版本信息：git log a.py</p>

<p>(2).记录下需要恢复的commit版本号：如 5d25eb4efc05b2e5ff56191464d6db75e4d3b52b</p>

<p>(3).恢复该文件：git reset 5d25eb4efc05b2e5ff56191464d6db75e4d3b52b a.py</p>

<p>(4).提交 git:git commit -m "revert old file"</p>
