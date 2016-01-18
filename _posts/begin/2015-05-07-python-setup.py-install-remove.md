---
layout: post
title: "python setup.py install 卸载"
description: "python setup.py install 卸载"
category: "python"
tags: [python技巧]
---
<p>You need to remove all files manually, and also undo any other stuff that installation did manually.</p>

<p>If you don't know the list of all files, you can reinstall it with the --record option, and take a look at the list this produces.</p>

<p>To record list of installed files, you can use:</p>

<pre><code>python setup.py install --record files.txt
</code></pre>

<p>Once you want to uninstall you can use xargs to do the removal:</p>

<pre><code>cat files.txt | xargs rm -rf
</code></pre>
