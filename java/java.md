# Java

## 1. date

### 1.1. LocalDate to Date

   ```java
   LocalDate nowLocalDate = LocalDate.now();
   Date date = Date.from(localDate.atStartOfDay(ZoneOffset.ofHours(8)).toInstant());
   ```

   

### 1.2. LocalDateTime to Date

   ```java
   LocalDateTime localDateTime = LocalDateTime.now();
   Date date = Date.from(localDateTime.atZone(ZoneOffset.ofHours(8)).toInstant());
   ```

### 1.3. Date to LocalDateTime/LocalDate

   ```java
   Date date = new Date();
   LocalDateTime localDateTime = date.toInstant().atZone(ZoneOffset.ofHours(8)).toLocalDateTime();
   LocalDate localDate = date.toInstant().atZone(ZoneOffset.ofHours(8)).toLocalDate();
   ```

### 1.4. LocalDate to epochMilli

   ```java
   LocalDate localDate = LocalDate.now();
   long timestamp = localDate.atStartOfDay(ZoneOffset.ofHours(8)).toInstant().toEpochMilli();
   ```

   

### 1.5. LocalDateTime to epochMilli

   ```java
   LocalDateTime localDateTime = LocalDateTime.now();
   long timestamp = localDateTime.toInstant(ZoneOffset.ofHours(8)).toEpochMilli();
   ```

   

### 1.6. epochMilli to LocalDateTime/LocalDate

   ```java
   long timestamp = System.currentTimeMillis();
   LocalDate localDate = Instant.ofEpochMilli(timestamp).atZone(ZoneOffset.ofHours(8)).toLocalDate();
   LocalDateTime localDateTime = Instant.ofEpochMilli(timestamp).atZone(ZoneOffset.ofHours(8)).toLocalDateTime();
   ```

### 1.7. format

   ```java
   DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
   Instant.ofEpochMilli(openPosition.getTradingDay()).atZone(ZoneId.systemDefault()).format(dateTimeFormatter);
   
   ```

## 2. jvm 调优

>[参考文档](https://mp.weixin.qq.com/s/oiz8K0CyVI-Qka-WCV67qA)

### 2.1. **优化思路**

其实简单来说就是尽量让每次Young GC后的存活对象小于Survivor区域的50%，都留存在年轻代里。尽量别让对象进入老年代。尽量减少Full GC的频率，避免频繁Full GC对JVM性能的影响。

### 2.2. 调优工具

用 jstat gc -pid 命令可以计算出如下一些关键数据，有了这些数据就可以采用之前介绍过的优化思路，先给自己的系统设置一些初始性的JVM参数，比如堆内存大小，年轻代大小，Eden和Survivor的比例，老年代的大小，大对象的阈值，大龄对象进入[老年代](https://www.zhihu.com/search?q=老年代&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A2420997119})的阈值等。

### 2.3. 关键指标

#### a. 年轻代对象增长的速率

可以执行命令 jstat -gc pid 1000 10 (每隔1秒执行1次命令，共执行10次)，通过观察EU(eden区的使用)来估算每秒eden大概新增多少对象，如果系统负载不高，可以把频率1秒换成1分钟，甚至10分钟来观察整体情况。注意，一般系统可能有高峰期和日常期，所以需要在不同的时间分别估算不同情况下对象增长速率。

#### b. Young GC的触发频率和每次耗时

知道年轻代对象增长速率我们就能推根据eden区的大小推算出Young GC大概多久触发一次，Young GC的平均耗时可以通过 YGCT/YGC 公式算出，根据结果我们大概就能知道**系统大概多久会因为Young GC的执行而卡顿多久。**

#### c. 每次Young GC后有多少对象存活和进入老年代

这个因为之前已经大概知道Young GC的频率，假设是每5分钟一次，那么可以执行命令 jstat -gc pid 300000 10 ，观察每次结果eden，survivor和老年代使用的变化情况，在每次gc后eden区使用一般会大幅减少，survivor和老年代都有可能增长，这些增长的对象就是每次Young GC后存活的对象，同时还可以看出每次Young GC后进去老年代大概多少对象，从而可以推算出**老年代对象增长速率。**

#### d. Full GC的触发频率和每次耗时

知道了老年代对象的增长速率就可以推算出Full GC的触发频率了，Full GC的每次耗时可以用公式 FGCT/FGC 计算得出。   

## 3. jvm 问题分析

> [参考文档](https://mp.weixin.qq.com/s/YuML5GfzRhq5YBfIPXgbYg)
>
> [参考文档](https://www.cnblogs.com/z-sm/p/6745375.html)

### 3.1 排查流程

* `jps`查出当前用户所有的Java进程,类似ps

* `jinfo pid`打印JVM的各种参数

* `jstat -gcuntil pid 5000 100` 每隔5000ms 输出一次GC信息,100次后结束

  ![image-20220426141317511](https://s2.loli.net/2022/04/26/B1PYzradURkgjHq.png)

  > 其中，S0 表示 Survivor0 区占用百分比，S1 表示 Survivor1 区占用百分比，E 表示 Eden 区占用百分比，O 表示老年代占用百分比，M 表示元数据区占用百分比，YGC 表示年轻代回收次数，YGCT 表示年轻代回收耗时，FGC 表示老年代回收次数，FGCT 表示老年代回收耗时。

* `jcmd`可以导出堆,栈信息;执行GC等

  ```bash
  #打印虚拟机列表,类似jps
  jcmd -l
  #导出堆信息
  jcmd pid GC.heap_dump filename.hprof
  #打印线程栈信息, 类似jstack
  jcmd pid Thread.print
  #打印类统计信息
  jcmd pid GC.class_histogram
  #触发gc()
  jcmd pid GC.run
  #jvm启动参数
  jcmd pid VM.flags
  #jvm启动命令行
  jcmd pid VM.command_line
  
  ```
  
  ![image-20220426142748972](https://s2.loli.net/2022/04/26/QlCmfiIUP4r8GZh.png)
  ![image-20220426142824218](https://s2.loli.net/2022/04/26/tBYMm6UPvCsDI5q.png)

* `jstack pid`获取当前线程栈.下面是发生死锁时线程栈数据:

  ```java
  "main":
          at org.apache.activemq.FifoMessageDispatchChannel.stop(FifoMessageDispatchChannel.java:124)
          **- waiting to lock <0x00000000ffe3fc88> (a java.lang.Object)**
          at org.apache.activemq.ActiveMQMessageConsumer.stop(ActiveMQMessageConsumer.java:1589)
          at org.apache.activemq.ActiveMQSession.stop(ActiveMQSession.java:1867)
          at org.apache.activemq.ActiveMQMessageConsumer.setMessageListener(ActiveMQMessageConsumer.java:452)
          at com.nogle.messaging.activemq.ActiveMQMessenger.subscribe(ActiveMQMessenger.java:73)
          at com.nogle.messaging.Messenger.subscribe(Messenger.java:55)
          at com.example.test.listener.ActiveMqListener.receiveStrategyHbt(ActiveMqListener.java:366)
          at com.example.test.listener.ActiveMqListener.receiveStrategySummary(ActiveMqListener.java:360)
          at com.example.test.listener.ActiveMqListener.init(ActiveMqListener.java:112)
          at jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(java.base@11.0.13/Native Method)
          at jdk.internal.reflect.NativeMethodAccessorImpl.invoke(java.base@11.0.13/NativeMethodAccessorImpl.java:62)
          at jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(java.base@11.0.13/DelegatingMethodAccessorImpl.java:43)
          at java.lang.reflect.Method.invoke(java.base@11.0.13/Method.java:566)
          at org.springframework.beans.factory.annotation.InitDestroyAnnotationBeanPostProcessor$LifecycleElement.invoke(InitDestroyAnnotationBeanPostProcessor.java:389)
          at org.springframework.beans.factory.annotation.InitDestroyAnnotationBeanPostProcessor$LifecycleMetadata.invokeInitMethods(InitDestroyAnnotationBeanPostProcessor.java:333)
          at org.springframework.beans.factory.annotation.InitDestroyAnnotationBeanPostProcessor.postProcessBeforeInitialization(InitDestroyAnnotationBeanPostProcessor.java:157)
          at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.applyBeanPostProcessorsBeforeInitialization(AbstractAutowireCapableBeanFactory.java:440)
          at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.initializeBean(AbstractAutowireCapableBeanFactory.java:1796)
          at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:620)
          at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:542)
          at org.springframework.beans.factory.support.AbstractBeanFactory.lambda$doGetBean$0(AbstractBeanFactory.java:335)
          at org.springframework.beans.factory.support.AbstractBeanFactory$$Lambda$278/0x00000001002fa440.getObject(Unknown Source)
          at org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:234)
          **- locked <0x00000000f71ab058> (a java.util.concurrent.ConcurrentHashMap)**
          at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:333)
          at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:208)
          at org.springframework.beans.factory.support.DefaultListableBeanFactory.preInstantiateSingletons(DefaultListableBeanFactory.java:944)
          at org.springframework.context.support.AbstractApplicationContext.finishBeanFactoryInitialization(AbstractApplicationContext.java:918)
          at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:583)
          - locked <0x00000000f6f05918> (a java.lang.Object)
          at org.springframework.boot.web.servlet.context.ServletWebServerApplicationContext.refresh(ServletWebServerApplicationContext.java:145)
          at org.springframework.boot.SpringApplication.refresh(SpringApplication.java:730)
          at org.springframework.boot.SpringApplication.refreshContext(SpringApplication.java:412)
          at org.springframework.boot.SpringApplication.run(SpringApplication.java:302)
          at org.springframework.boot.SpringApplication.run(SpringApplication.java:1301)
          at org.springframework.boot.SpringApplication.run(SpringApplication.java:1290)
          at com.example.test.CmsSimApplication.main(CmsSimApplication.java:17)
          at jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(java.base@11.0.13/Native Method)
          at jdk.internal.reflect.NativeMethodAccessorImpl.invoke(java.base@11.0.13/NativeMethodAccessorImpl.java:62)
          at jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(java.base@11.0.13/DelegatingMethodAccessorImpl.java:43)
          at java.lang.reflect.Method.invoke(java.base@11.0.13/Method.java:566)
          at org.springframework.boot.loader.MainMethodRunner.run(MainMethodRunner.java:49)
          at org.springframework.boot.loader.Launcher.launch(Launcher.java:108)
          at org.springframework.boot.loader.Launcher.launch(Launcher.java:58)
          at org.springframework.boot.loader.JarLauncher.main(JarLauncher.java:88)
  "ActiveMQ Session Task-1":
          at org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:217)
          **- waiting to lock <0x00000000f71ab058> (a java.util.concurrent.ConcurrentHashMap)**
          at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:333)
          at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:208)
          at org.springframework.beans.factory.config.DependencyDescriptor.resolveCandidate(DependencyDescriptor.java:276)
          at org.springframework.beans.factory.support.DefaultListableBeanFactory.doResolveDependency(DefaultListableBeanFactory.java:1380)
          at org.springframework.context.annotation.ContextAnnotationAutowireCandidateResolver$1.getTarget(ContextAnnotationAutowireCandidateResolver.java:95)
          at org.springframework.aop.framework.CglibAopProxy$DynamicAdvisedInterceptor.intercept(CglibAopProxy.java:676)
          at com.example.test.listener.ws.mock.WsMockSessionManager$$EnhancerBySpringCGLIB$$602ea827.sendData(<generated>)
          at com.example.test.listener.ws.mock.WsMockPushService.pushPositionAndStateMsg(WsMockPushService.java:139)
          at com.example.test.listener.ws.mock.WsMockPushService$$FastClassBySpringCGLIB$$10b87740.invoke(<generated>)
          at org.springframework.cglib.proxy.MethodProxy.invoke(MethodProxy.java:218)
          at org.springframework.aop.framework.CglibAopProxy$DynamicAdvisedInterceptor.intercept(CglibAopProxy.java:689)
          at com.example.test.listener.ws.mock.WsMockPushService$$EnhancerBySpringCGLIB$$9cfda371.pushPositionAndStateMsg(<generated>)
          at com.example.test.service.AccountInfoService.handleAccountPosition(AccountInfoService.java:103)
          at com.example.test.listener.ActiveMqListener$8.onMessage(ActiveMqListener.java:319)
          at com.nogle.messaging.activemq.ActiveMQMessenger.onMessage(ActiveMQMessenger.java:145)
          at org.apache.activemq.ActiveMQMessageConsumer.dispatch(ActiveMQMessageConsumer.java:1435)
          **- locked <0x00000000ffe3fc88> (a java.lang.Object)**
          at org.apache.activemq.ActiveMQSessionExecutor.dispatch(ActiveMQSessionExecutor.java:131)
          at org.apache.activemq.ActiveMQSessionExecutor.iterate(ActiveMQSessionExecutor.java:202)
          at org.apache.activemq.thread.PooledTaskRunner.runTask(PooledTaskRunner.java:133)
          at org.apache.activemq.thread.PooledTaskRunner$1.run(PooledTaskRunner.java:48)
          at java.util.concurrent.ThreadPoolExecutor.runWorker(java.base@11.0.13/ThreadPoolExecutor.java:1128)
          at java.util.concurrent.ThreadPoolExecutor$Worker.run(java.base@11.0.13/ThreadPoolExecutor.java:628)
          at java.lang.Thread.run(java.base@11.0.13/Thread.java:829)
  ```

  >本次死锁发生在main和mq两个线程之间,栈信息要从下往上看
  >
  >mq线程里, mq在分发和消费accountInfo消息时,对内存地址为0x00000000ffe3fc88的Object类型对象加了锁,然后accountInfo 的onMessage 方法内会注入对象wsMockPushService(lazy启动,所以现在才创建),创建时需要获取0x00000000f71ab058的ConcurrentHashMap锁
  >
  >main线程里, SpringBoot容器启动后,创建ActiveMqListener对象时,对0x00000000f71ab058加锁,然后执行PostConstruct的方法init, init内部通过receiveStrategyHbt订阅了一个topic,此时需要获取0x00000000ffe3fc88锁
  >
  >mq订阅和消费的时候共用一个锁(object),strategyHbtService的订阅(main)跟accountInfoService消费(mq)锁一起了
  >
  >spring创建对象的时候会加锁(concurrentHashMap),activeMqListener的创建(main)跟accountInfo里wsManager的创建(mq)锁一起了
