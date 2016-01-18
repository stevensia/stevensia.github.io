---
layout: post
title: "C&Shell&七牛 图片批量处理简陋工具"
description: "C&Shell&七牛 图片批量处理简陋工具"
category: "life"
tags: [工具]
---

最近有一大批图片需要处理并发布到博客上，弄巧成拙做了些小工具，包括：

- C 图片批量缩略处理(其实就是利用mac下`sips`命令，还不如直接 `sips -Z 680 *.jpg`呢，这里弄巧成拙了搞得比较麻烦)
- Shell 图片批量以当前时间戳重命名保证上传文件的唯一性
- 七牛小工具批量上传

C程序如下，无成熟性和安全性 (囧!)


	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>  
	#include <dirent.h> 
	#include <unistd.h>
	#include <errno.h>
	#define MAX_LEN 65535

	int main(int argc, char *argv[])
	{
		FILE *fp=NULL;
		char *path="/Users/fangpeng/mypics/";
		fp = fopen(path, "r");
		if(!fp)
			puts("文件夹不存在");
		else{
			//打印存在的文件
			DIR *dir;
			struct dirent *ptr;
			char *flow[MAX_LEN];
			int num=0,i=0;

			if((dir=opendir(path)) == NULL)
			{
				perror("Open dir error..");
				exit(1);
			}
		    // readdir() return next enter point of directory dir
			while((ptr=readdir(dir)) != NULL)
			{
				flow[num] = (char*)malloc(sizeof(char));
				strcpy(flow[num], ptr->d_name);
				num++;
			}
			for(i=0; i<num; i++){
				char *dot = strrchr(flow[i], '.');
				if(dot && !strcmp(dot, ".jpg")){				// 判断是否以".jpg"结尾
					printf("the file:%s\n", flow[i]);
					//set pictures
					pid_t pid = fork();
					if(pid == -1)
					{
						fprintf(stderr, "Can't fork process: %s\n", strerror(errno));
						return 1;
					}
					if(pid == 0)	// 或 !pid,  运行在子进程
					{
						
						if(execlp("sips", "sips", "-Z", argv[1],flow[i], NULL) == -1)
						{
							fprintf(stderr, "Can't run command sips %s\n", strerror(errno));
							return 1;
						}
					}
				}
			}
			closedir(dir);
			
		}
		
		return 0;
	}

批量缩略后，再重命名，shell脚本如下：

	#!/bin/bash
	path="![](http://beginman.qiniudn.com/"
	end=")"
	for i in `ls *.jpg *.png *.jpge`
	do
		newName=$(date -u +%y%m%d%h%M%s)
		newName=`echo $newName$i|awk '{gsub(/ /,"")}1'`
		mv $i $newName
		#打印
		echo $path$newName$end
		echo ""
	done

然后把输出的一大堆如：

	![](http://beginman.qiniudn.com/1509309151443608119DSC_0796.jpg)

	![](http://beginman.qiniudn.com/1509309151443608119DSC_0803.jpg)

	![](http://beginman.qiniudn.com/1509309151443608119DSC_0804.jpg)

	![](http://beginman.qiniudn.com/1509309151443608119DSC_0806.jpg)

	![](http://beginman.qiniudn.com/1509309151443608119DSC_0828.jpg)
	.....

粘贴到你的博客中。

然后通过七牛[qrsync命令行辅助同步工具](http://developer.qiniu.com/docs/v6/tools/qrsync.html),上传即可，我这里做了alias, 如：

	alias qn="/Users/fangpeng/tools/qiniuTool/qrsync /Users/fangpeng/Pictures/config.json" 

执行`qn`立马会将目标文件统统上传至七牛服务器。那么接下来就开始引用链接了，看下美图吧：


![](http://beginman.qiniudn.com/1509309151443608156DSC_0211.jpg)

![](http://beginman.qiniudn.com/1509309151443608156DSC_0229.jpg)

![](http://beginman.qiniudn.com/1509309151443608156DSC_0244.jpg)

![](http://beginman.qiniudn.com/1509309151443608156DSC_0404.jpg)

![](http://beginman.qiniudn.com/1509309151443608156DSC_0422.jpg)

![](http://beginman.qiniudn.com/1509309151443608156DSC_0506.jpg)

![](http://beginman.qiniudn.com/1509309151443608156DSC_0536.jpg)

![](http://beginman.qiniudn.com/1509309151443608156DSC_0551.jpg)

![](http://beginman.qiniudn.com/1509309151443608156DSC_0674.jpg)

![](http://beginman.qiniudn.com/1509309151443608156DSC_0688.jpg)

![](http://beginman.qiniudn.com/1509309151443608156DSC_0804.jpg)

![](http://beginman.qiniudn.com/1509309151443608156DSC_0828.jpg)
