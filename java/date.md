# Date

## 一. 类型转换

1. LocalDate to Date

   ```java
   LocalDate nowLocalDate = LocalDate.now();
   Date date = Date.from(localDate.atStartOfDay(ZoneOffset.ofHours(8)).toInstant());
   ```

   

2. LocalDateTime to Date

   ```java
   LocalDateTime localDateTime = LocalDateTime.now();
   Date date = Date.from(localDateTime.atZone(ZoneOffset.ofHours(8)).toInstant());
   ```

3. Date to LocalDateTime/LocalDate

   ```java
   Date date = new Date();
   LocalDateTime localDateTime = date.toInstant().atZone(ZoneOffset.ofHours(8)).toLocalDateTime();
   LocalDate localDate = date.toInstant().atZone(ZoneOffset.ofHours(8)).toLocalDate();
   ```

4. LocalDate to epochMilli

   ```java
   LocalDate localDate = LocalDate.now();
   long timestamp = localDate.atStartOfDay(ZoneOffset.ofHours(8)).toInstant().toEpochMilli();
   ```

   

5. LocalDateTime to epochMilli

   ```java
   LocalDateTime localDateTime = LocalDateTime.now();
   long timestamp = localDateTime.toInstant(ZoneOffset.ofHours(8)).toEpochMilli();
   ```

   

6. epochMilli to LocalDateTime/LocalDate

   ```java
   long timestamp = System.currentTimeMillis();
   LocalDate localDate = Instant.ofEpochMilli(timestamp).atZone(ZoneOffset.ofHours(8)).toLocalDate();
   LocalDateTime localDateTime = Instant.ofEpochMilli(timestamp).atZone(ZoneOffset.ofHours(8)).toLocalDateTime();
   ```

7. format

   ```java
   DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
   Instant.ofEpochMilli(openPosition.getTradingDay()).atZone(ZoneId.systemDefault()).format(dateTimeFormatter);
   
   ```

   
