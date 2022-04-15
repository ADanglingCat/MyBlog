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
