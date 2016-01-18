---
layout: post
title: "git实用的一键提交脚本"
description: "git实用的一键提交脚本"
category: "git"
tags: [git]
---

<p>为了更加方便高效的使用git,写了个脚本．</p>

<pre><code>#!/bin/bash
# ----------------------------
# author:BeginMan
# function:git快捷提交
# date:2014-10-02
# ----------------------------


cat &lt;&lt; EOF
+---------------------------------------+
|  Git一键提交,如需手动则按Ctrl+Z 结束  |
+---------------------------------------+
EOF

#检测忽略文件
function checkIgnore(){
    if git status --porcelain | grep -E "*.\.log|.txt|.pyc|.idea|.sass|.gitignore" ; then
        echo "忽略文件已添加进去了,正在取消中..."
        find . -regex ".*\.txt\|.*\.log\|.*\.pyc" -exec git rm --cached {} \;
    fi

}

# 自动提交
function auto(){
    git add -A;
    read -p "输入日志,按Enter键跳过 :" log
    if  [ ! -n "$log" ] ;then
        git commit -m "自动生成";
    else git commit -m "${log}";
    fi;
    git push origin develop:develop;
    echo -e "\033[32m 远程推送完成! \033[0m"
}


echo -e "\033[33m git初始化中.... \033[0m"
git pull origin develop;
echo -e "\033[32m 更新完毕! \033[0m"

if [ -n "$(git status --porcelain)" ]; then
     git status;
     checkIgnore
     read -p "--------是否提交已暂存的文件:[y/n]" tip
     case $tip in
        Y|y)
            auto;;
        *)
            echo -e "\033[32m 操作终止! \033[0m";;
     esac;
else
  echo -e "\033[32m 没有暂存的文件,不需要提交! \033[0m"
fi
</code></pre>
