---
layout: post
title:  "SQLServer Datetime类型转字符串(带格式)"
date:   2017-4-1 12:18:30 +0800
categories: database
author: Chen Min
---


一、回顾一下CONVERT()的语法格式：
    CONVERT (<data_ type>[ length ]， <expression> [， style])
	
二、这里注重说明一下style的含义：style 是将DATATIME 和SMALLDATETIME 数据转换为字符串时所选用的由SQL Server 系统提供的转换样式编号，不同的样式编号有不同的输出格式；一般在时间类型(datetime,smalldatetime)与字符串类型(nchar,nvarchar,char,varchar)相互转换的时候才用到.
三、下表是SQL Server 系统提供的转换样式编号：

|不带世纪数位 (yy)|带世纪数位 (yyyy)|标准|输入/输出**|
| --------   | -----:   | ----: |  ----: |
|-|0 或 100 (*)|默认值|mon dd yyyy hh:miAM（或 PM）|
|1|101|美国|mm/dd/yyyy|
|2|102|ANSI|yy.mm.dd|
|3|103|英国/法国|dd/mm/yy|
|4|104|德国|dd.mm.yy|
|5|105|意大利|dd-mm-yy|
|6|106|-|dd mon yy|
|7|107|-|mon dd, yy|
|8|108|-|hh:mm:ss|
|-|9 或 109 (*)|默认值 + 毫秒|mon dd yyyy hh:mi:ss:mmmAM（或 PM）|
|10|110|美国|mm-dd-yy|
|11|111|日本|yy/mm/dd|
|12|112|ISO|yymmdd|
|-|13 或 113 (*)|欧洲默认值 + 毫秒|dd mon yyyy hh:mm:ss:mmm(24h)|
|14|114|-|hh:mi:ss:mmm(24h)|
|-|20 或 120 (*)|ODBC 规范|yyyy-mm-dd hh:mm:ss[.fff]|
|-|21 或 121 (*)|ODBC 规范（带毫秒）|yyyy-mm-dd hh:mm:ss[.fff]|
|-|126(***)|ISO8601|yyyy-mm-dd Thh:mm:ss.mmm（不含空格）|
|-|130*|Hijri****|dd mon yyyy hh:mi:ss:mmmAM|
|-|131*|Hijri****|dd/mm/yy hh:mi:ss:mmmAM|

表中‘*'表示的含义说明： * 默认值（style 0 或 100、9 或 109、13 或 113、20 或 120、21 或 121）始终返回世纪数位 (yyyy)。
** 当转换为 datetime时输入；当转换为字符数据时输出。
*** 专门用于 XML。对于从 datetime或 smalldatetime 到 character 数据的转换，输出格式如表中所示。对于从 float、money 或 smallmoney 到 character 数据的转换，输出等同于 style 2。对于从 real 到 character 数据的转换，输出等同于 style 1。
**** Hijri 是具有几种变化形式的日历系统，Microsoft? SQL Server? 2000 使用其中的科威特算法。

四、不带世纪数位的实例代码（注释的表示非有效的样式号）：

代码如下:
{% highlight sql linenos %}
SELECT CONVERT(varchar(100), GETDATE(), 0) AS Style0 
SELECT CONVERT(varchar(100), GETDATE(), 1) AS Style1 
SELECT CONVERT(varchar(100), GETDATE(), 2) AS Style2 
SELECT CONVERT(varchar(100), GETDATE(), 3) AS Style3 
SELECT CONVERT(varchar(100), GETDATE(), 4) AS Style4 
SELECT CONVERT(varchar(100), GETDATE(), 5) AS Style5 
SELECT CONVERT(varchar(100), GETDATE(), 6) AS Style6 
SELECT CONVERT(varchar(100), GETDATE(), 7) AS Style7 
SELECT CONVERT(varchar(100), GETDATE(), 8) AS Style8 
SELECT CONVERT(varchar(100), GETDATE(), 9) AS Style9 
SELECT CONVERT(varchar(100), GETDATE(), 10) AS Style10 
SELECT CONVERT(varchar(100), GETDATE(), 11) AS Style11 
SELECT CONVERT(varchar(100), GETDATE(), 12) AS Style12 
SELECT CONVERT(varchar(100), GETDATE(), 13) AS Style13 
SELECT CONVERT(varchar(100), GETDATE(), 14) AS Style14 
--SELECT CONVERT(varchar(100), GETDATE(), 15) AS Style15 
--SELECT CONVERT(varchar(100), GETDATE(), 16) AS Style16 
--SELECT CONVERT(varchar(100), GETDATE(), 17) AS Style17 
--SELECT CONVERT(varchar(100), GETDATE(), 18) AS Style18 
--SELECT CONVERT(varchar(100), GETDATE(), 19) AS Style19 
SELECT CONVERT(varchar(100), GETDATE(), 20) AS Style21 
SELECT CONVERT(varchar(100), GETDATE(), 21) AS Style21 
SELECT CONVERT(varchar(100), GETDATE(), 22) AS Style22 
SELECT CONVERT(varchar(100), GETDATE(), 23) AS Style23 
SELECT CONVERT(varchar(100), GETDATE(), 24) AS Style24 
SELECT CONVERT(varchar(100), GETDATE(), 25) AS Style25 
--SELECT CONVERT(varchar(100), GETDATE(), 26) AS Style26 
--SELECT CONVERT(varchar(100), GETDATE(), 27) AS Style27 
--SELECT CONVERT(varchar(100), GETDATE(), 28) AS Style28 
--SELECT CONVERT(varchar(100), GETDATE(), 29) AS Style29 
--SELECT CONVERT(varchar(100), GETDATE(), 30) AS Style30 
--SELECT CONVERT(varchar(100), GETDATE(), 31) AS Style31
{% endhighlight %}

运行结果：

![image](../img/fhasdjaklfjadsdsojeriowej1.png)


五、带世纪数位的实例代码（注释的表示非有效的样式号）：

代码如下:
{% highlight sql linenos %}
SELECT CONVERT(varchar(100), GETDATE(), 100) AS Style100 
SELECT CONVERT(varchar(100), GETDATE(), 101) AS Style101 
SELECT CONVERT(varchar(100), GETDATE(), 102) AS Style102 
SELECT CONVERT(varchar(100), GETDATE(), 103) AS Style103 
SELECT CONVERT(varchar(100), GETDATE(), 104) AS Style104 
SELECT CONVERT(varchar(100), GETDATE(), 105) AS Style105 
SELECT CONVERT(varchar(100), GETDATE(), 106) AS Style106 
SELECT CONVERT(varchar(100), GETDATE(), 107) AS Style107 
SELECT CONVERT(varchar(100), GETDATE(), 108) AS Style108 
SELECT CONVERT(varchar(100), GETDATE(), 109) AS Style109 
SELECT CONVERT(varchar(100), GETDATE(), 110) AS Style110 
SELECT CONVERT(varchar(100), GETDATE(), 111) AS Style111 
SELECT CONVERT(varchar(100), GETDATE(), 112) AS Style112 
SELECT CONVERT(varchar(100), GETDATE(), 113) AS Style113 
SELECT CONVERT(varchar(100), GETDATE(), 114) AS Style114 
--SELECT CONVERT(varchar(100), GETDATE(), 115) AS Style115 
--SELECT CONVERT(varchar(100), GETDATE(), 116) AS Style116 
--SELECT CONVERT(varchar(100), GETDATE(), 117) AS Style117 
--SELECT CONVERT(varchar(100), GETDATE(), 118) AS Style118 
--SELECT CONVERT(varchar(100), GETDATE(), 119) AS Style119 
SELECT CONVERT(varchar(100), GETDATE(), 120) AS Style121 
SELECT CONVERT(varchar(100), GETDATE(), 121) AS Style121 
--SELECT CONVERT(varchar(100), GETDATE(), 122) AS Style122 
--SELECT CONVERT(varchar(100), GETDATE(), 123) AS Style123 
--SELECT CONVERT(varchar(100), GETDATE(), 124) AS Style124 
--SELECT CONVERT(varchar(100), GETDATE(), 125) AS Style125 
SELECT CONVERT(varchar(100), GETDATE(), 126) AS Style126 
SELECT CONVERT(varchar(100), GETDATE(), 127) AS Style127 
--SELECT CONVERT(varchar(100), GETDATE(), 128) AS Style128 
--SELECT CONVERT(varchar(100), GETDATE(), 129) AS Style129 
SELECT CONVERT(varchar(100), GETDATE(), 130) AS Style130 
SELECT CONVERT(varchar(100), GETDATE(), 131) AS Style131
{% endhighlight %}

运行结果：

![image](../img/fhasdjaklfjadsdsojeriowej2.png)


SQL将datetime转化为字符串并截取字符串

复制代码 代码如下:

{% highlight sql linenos %}
select sr_child as '孩子姓名', sr_parents as '家长姓名' ,ss_updatetime as '分配时间', left(ss_updatetime,CHARINDEX(' ',ss_updatetime)-1),SUBSTRING(CONVERT(CHAR(19), ss_updatetime, 120),1,10)as '转换格式并截取后的时间'from dbo.tb_sell_resources,dbo.tb_sell_selldetails where sr_id = ss_rsid and ss_qdstate <> 1 order by ss_updatetime 
{% endhighlight %}

![image](../img/fhasdjaklfjadsdsojeriowej3.png)


sql 中字符串截取函数： SUBSTRING(name,start,end) 
name： 字符串格式的 字段名 
start： 规定开始位置（起始值是 1） 
end：截取字符串结束的位置 


sql 中Datetime格式转换为字符串格式： 2000-01-01 01:01:01（Datetime） CONVERT(CHAR(19), CURRENT_TIMESTAMP, 120) 

CURRENT_TIMESTAMP： 当前时间（此处可以写Datetime格式的字段名，例如ss_updatetime） 
其余的参数（CHAR(19), 120等）不用修改 
使用之后 2000-01-01 01:01:01（Datetime）变为 2000-01-01 01:01:01（字符串格式）