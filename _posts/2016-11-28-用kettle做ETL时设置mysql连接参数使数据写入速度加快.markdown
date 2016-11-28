---
layout: post
title:  "用kettle做ETL时设置mysql连接参数使数据写入速度加快"
date:   2016-11-28 13:09:52 +0800
categories: ETL
author: Chen Min
---

在用kettle做转换抽取数据的时候，向mysql服务器写入数据时会很慢，尤其是广域网里的服务器

经过网上查资料看文档，确定了这三个连接属性

设置后写入速度有明显提升。

{% highlight C linenos %}

rewriteBatchedStatements=true

useServerPrepStmts=false

useCompression=true

{% endhighlight %}


设置方法：


![image](../img/QQ截图20161128131131.png)