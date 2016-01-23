#!/bin/bash
if [ "$#" -ne 2 ]
 then echo "Usage: $0 title category"
 exit
fi
TITLE=$1
TISP=`echo $TITLE | sed 's/ /-/g'`
DATE=`date "+%Y-%m-%d %H:%M:%S"`
FDATE=`date "+%Y-%m-%d"`
CATE=$2 

FILE="$FDATE-$TISP.md"

echo "---
layout: post
title:  "$TITLE"
date:   "$DATE"
categories: "$CATE"
tags: "$CATE"
---
" > $FILE

echo $FILE
