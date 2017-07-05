---
layout: post
title:  "Greenplum深度优化技巧"
date:   2017-7-5 14:22:16 +0800
categories: database
author: Chen Min
---


转载自云栖社区，原文地址：https://yq.aliyun.com/articles/62624


摘要： 在2016云栖大会杭州峰会开源数据库之 Greenplum专场上阿里云高级专家张广舟（明虚）对于阿里云Greenplum产品ApsaraDB for GP进行了介绍，对于ApsaraDB for GP的优势以及架构进行了深入的分享。Greenplum究竟能解决什么问题？本文就为大家揭晓答案。

以下内容根据演讲PPT以及现场分享整理而成。



本次的分享将主要对云上的Greenplum进行介绍。有的同学往往有一些疑问就是Greenplum产品有什么优势？为什么要使用Greenplum？Greenplum能解决什么问题？在今天的分享中也将探讨这几个问题。最后还会提到一些阿里云Greenplum小组所做的工作。



本次的分享主要分为三个方面：
一、ApsaraDB for GP的定位
二、ApsaraDB for GP内核定制
三、未来规划



一、ApsaraDB for GP的定位
首先提出两个问题：Greenplum的优势是什么？它能解决什么问题？
阿里云的Greenplum产品叫做ApsaraDB for GP，我们给这个产品的定位只有两个字：性能，也就是阿里云的ApsaraDB for GP在性能方面一定要比其他的分析性的数据库解决方案更高。

1f85ff53a7120ea0dd44c0d6de879632f0ea0e4e

在我看来，Greenplum的优势在于这样的几点：首先，Greenplum使用了MPP的架构，除此之外，它还使用了列存和压缩。列存和压缩在现在看来是比较普通的技术，但是其实像IBM的DB2数据库也才在近几年支持了列存和压缩技术，而Greenplum从很早就支持了这些技术，这些技术的在性能上会有很大的优势。而且Greenplum不仅能够支持复杂的SQL，而且它的查询优化器能力也大大超出预期。Greenplum产品性能的定位是在秒级或者小于秒级能够实现对于复杂查询的响应，Greenplum执行器的性能其实是来自多年来Postgre的积淀，要远远超过其他的解决方案。另外Greenplum使用的是本地高效存储和高速网络，当然最好是万兆网络，还有预置稳定资源，不会出现性能的波动，简单而言就是Greenplum可以高效地解决大数据分析的需求。



MPP架构处理举例
举一个例子：Select count(*) from customer group by city
这是一条很简单的SQL语句，比方是在数据库中按照城市分组查询每个城市的用户数量。
对比MySQL的执行过程来看，首先MySQL数据库会对所有的数据记录进行扫描，对用户按照城市进行分组，然后对于每组用户的数量进行统计，最后将结果返回给用户。对于1亿条记录而言，这时即使IO不出现问题，那么机器的CPU也会被占满。对于MySQL而言，这样的一个简单SQL语句就可以使机器的CPU占用率达到100%，而且这样执行的速度也是非常慢的。

而Greenplum则采取多核进行计算处理，比方在扫描数据的时候将会采用多个进程，多个CPU去处理，在Hash的时候也会使用多个CPU，这样速度就会变快。当数据量太大，多到一个机器处理不了的时候，就需要MPP了。所以Greenplum使用MPP架构解决了对于大数据量的问题，对于同样的一条SQL语句，Greenplum将会启动多个实例和进程去做同样的事情，执行同样的流程，但是处理的是不同的数据分片，如此就实现了多机器的查询计算，这也就是Greenplum的最核心能力，也是与传统数据库不同之处。



列存与压缩原理举例
再举一个SQL语句的例子：Select count(*) from customer where status = valid group by city
对于这条语句，DBA在对像MySQL这样的传统的数据库进行优化的时候，可能会选择使用索引。但是其实这种情况下使用索引是不恰当的，使用索引只能够过滤20%左右的数据，而增加的性能开销却是很大的，所以不应该使用索引。

列存方式则将会把status单独存储在一个列存块，经过压缩以后，占用的存储空间也会大大降低，同时也可以单独对status数据取出并进行处理。其实在这种情况下列存近似等于开销极小的索引，而且效率非常高。



Greenplum VS Hadoop
Greenplum的Orca优化器，使得其在响应时间上比Hadoop的离线计算产品性能更加优秀。
Greenplum的 SQL Runtime是从Postgre几十年的沉淀演变来的，并且是由C语言构建的，比Hadoop的SQL Runtime效率高很多。还有Greenplum使用的是本地存储，而Hadoop使用的则是分布式存储。所以总体来看，Greenplum的性能可以达到Hadoop的5-30倍。



ApsaraDB for GP VS AWS Redshift
在亚马逊上有一款卖的非常好的产品，名字叫“Redshift”，它被称为亚马逊“有史以来卖的最好的云服务”，其实ApsaraDB for GP在功能上与Redshift很像，而且ApsaraDB for GP有很多Redshift不具备的特性。

在使用ApsaraDB for GP产品时，推荐使用ECS VPC的架构。架构搭建完成之后的一个问题就是：如何将ECS上的数据导入到ApsaraDB for GP进行分析呢？其实可以通过写程序的方式将数据导入到主节点上，也可以使用EMR图去主动地抓取并分析数据。EMR与OSS结合得非常好，将数据存放在OSS上之后，可以通过执行SQL语句使得所有的子节点并发地拉取数据。当然也可以通过应用服务器直接将数据或者日志上传到OSS上面去，对于其他的阿里云服务可也以通过阿里云CDB服务将数据定向迁移到OSS上面，再通过Greenplum进行数据拉取，进而使用可视化工具对数据进行分析。



二、ApsaraDB for GP 内核定制
接下来分享阿里云在Greenplum上做的一些优化工作。在阿里云ApsaraDB for GP架构设计中，子节点分散地存储在不同的物理机上面，每2个或者是16个子节点为一组。对于子节点组采取了资源限制，但是组内节点之间可以弹性共享资源，这样就降低资源倾斜造成的影响，也便于管理，同时节点之间使用万兆网络进行数据传输。

这样架构的一个优点是支持OSS外部表读写，可以在OSS外部创建一张表，使用简单的SQL语句就可以将数据导入到Greenplum的子节点上，同时也可以很简单地将数据从Greenplum导回到OSS。简而言之，就是让OSS充当数据存储中心，让Greenplum作为数据分析中心。

而且Greenplum支持将一些语法作为插件提供，很多这样插件目前已经提交开源社区，很快大家就可以用到了。而且未来ApsaraDB for GP将会完善对于JSON的支持，如果社区动作较慢，我们会考虑在阿里云自己的产品中优先支持。而对于OOM的很难提前监控的问题，阿里云采取的方法就是利用外部脚本监控cgroup中的内存统计，发生内存水位较高时，将实例移入公共cgroup，同时发出cancel query信号给内核；当水位下降时移回实例的cgroup。

e4c347d538bc9691d963e2bdc4c0c2378e9b60ee

三、未来规划
谈到未来规划，第一点就是必须要满足客户需求。另外还要继续对于列存进行优化，希望在未来能够在某些场景下将性能进一步提高。对于CPU优化方面，我们希望在未来能对GP执行器的静态编译进行进一步优化。最后我们希望与Greenplum厂商、用户和开发者一起为Greenplum社区的发展贡献力量，一起推动Greenplum的发展。