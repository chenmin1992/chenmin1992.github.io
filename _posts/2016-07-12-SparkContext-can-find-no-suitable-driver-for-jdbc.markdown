---
layout: post
title:  "SparkContext can find no suitable driver for jdbc"
date:   2016-7-12 09:33:48 +0800
categories: spark
author: Chen Min
---

Well,there is no post after my blog has been renovationed,so it is.

Here,

when i use a jdbc format url to connect to a mysql server in spark program.

a error occured , no suitable driver ........,as follow:

{% highlight scala linenos %}
  def hive_to_mysql(data: DataFrame, tableName: String): Unit = {
    data.write.mode(SaveMode.Append).jdbc(url, tableName, mysql_prop)
  }
{% endhighlight %}

I think that the sparkcontext will find a driver from registered driver list according to connection url,

but the error occured.

with i am a beginner so i don't know how to solve it.

i found a pull request about no suitable driver from spark github,

[pull 5782]

{% highlight scala linenos %}
def getConnector(driver: String, url: String, properties: Properties): () => Connection = {
      () => {
        try {
 -        if (driver != null) Utils.getContextOrSparkClassLoader.loadClass(driver)
 +        if (driver != null) DriverRegistry.register(driver)
        } catch {
          case e: ClassNotFoundException => {
            logWarning(s"Couldn't find class $driver", e);
{% endhighlight %}

{% highlight scala linenos %}
     val upperBound = parameters.getOrElse("upperBound", null)
      val numPartitions = parameters.getOrElse("numPartitions", null)
  
 -    if (driver != null) Utils.getContextOrSparkClassLoader.loadClass(driver)
 +    if (driver != null) DriverRegistry.register(driver)
  
      if (partitionColumn != null
          && (lowerBound == null || upperBound == null || numPartitions == null)) {
 @@ -136,7 +136,7 @@ private[sql] case class JDBCRelation(
    override val schema: StructType = JDBCRDD.resolveTable(url, table, properties)
  
    override def buildScan(requiredColumns: Array[String], filters: Array[Filter]): RDD[Row] = {
 -    val driver: String = DriverManager.getDriver(url).getClass.getCanonicalName
 +    val driver: String = DriverRegistry.getDriverClassName(url)
      JDBCRDD.scanTable(
        sqlContext.sparkContext,
        schema,
{% endhighlight %}

according to the changes puller made , he create a DriverWrapper extends java.sql.Driver,
and reload the jdbc driver with the same driver loaded by sparkcontext .

the key point is that the pull request has been mergen,haha.
so i add a line before connectting to mysql server,like this 

{% highlight scala linenos %}
  def hive_to_mysql(data: DataFrame, tableName: String): Unit = {
    DriverRegistry.register("com.mysql.jdbc.Driver")
    data.write.mode(SaveMode.Append).jdbc(url, tableName, mysql_prop)
  }
{% endhighlight %}

i think it will succeed ,but but but ,three but is but, it failed,
a new error was reported by spark program.

sparkContext can not find the registered driver...............

the the CTO in my company solve the final problem for me.

{% highlight scala linenos %}
  Property mysql_prop = new Property()
  mysql_prop.add("user","root")
  mysql_prop.add("password","password")
  mysql_prop.add("driver","com.mysql.jdbc.Driver") //the most important line
{% endhighlight %}

the most important line had shown we must tell sparkContext the classname of Driver I mean.

why so , it is a bug that the spark job in yarn cluster mode ran by oozie workflow will occur.

so far, all spark job will finish successfully.


[pull 5782]:https://github.com/apache/spark/pull/5782