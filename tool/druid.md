# Druid

## 1. druid介绍

[druid](https://github.com/alibaba/druid/wiki/%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98)是一款java数据库连接池,同时提供了数据库监控功能.

## 2. druid使用

```properties
#pom.xml
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid-spring-boot-starter</artifactId>
            <version>1.2.3</version>
        </dependency>
#application.properties
spring.datasource.type=com.alibaba.druid.pool.DruidDataSource
#启动config filter,用来密码加密
spring.datasource.druid.filter.config.enabled=true
#启动stat filter,监控
spring.datasource.druid.filter.stat.enabled=true
spring.datasource.druid.filter.stat.log-slow-sql=false
spring.datasource.druid.filter.stat.slow-sql-millis=3000
spring.datasource.druid.filter.stat.merge-sql=true
spring.datasource.druid.web-stat-filter.url-pattern=/*
spring.datasource.druid.web-stat-filter.exclusions=*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*,/static/*
#启动监控界面
spring.datasource.druid.stat-view-servlet.enabled=true
spring.datasource.druid.stat-view-servlet.reset-enable=true
spring.datasource.druid.stat-view-servlet.login-username=admin
spring.datasource.druid.stat-view-servlet.login-password=cdl12278@
#启动wall filter,防止SQL注入攻击
spring.datasource.druid.filter.wall.enabled=true
spring.datasource.druid.filter.wall.config.drop-table-allow=false
spring.datasource.druid.filter.wall.config.create-table-allow=false
spring.datasource.druid.filter.wall.config.alter-table-allow=false
spring.datasource.druid.filter.wall.config.multiStatementAllow=true
spring.datasource.druid.filter.wall.config.condition-and-alway-false-allow=true
spring.datasource.druid.filter.wall.config.condition-and-alway-true-allow=true
#spring.datasource.druid.filter.wall.config.update-where-none-check=true
#spring.datasource.druid.filter.wall.config.none-base-statement-allow=true
#是否输出到日志
spring.datasource.druid.filter.wall.log-violation=false
#是否抛出异常
spring.datasource.druid.filter.wall.throw-exception=false
#数据库链接
spring.datasource.url=jdbc:mysql://localhost:3306/databaseName?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&allowMultiQueries=true
#数据库密码加密 java -cp druid-1.0.16.jar com.alibaba.druid.filter.config.ConfigTools you_password
spring.datasource.druid.connection-properties=config.decrypt=true;config.decrypt.key=MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALeM8eey7iPIDwqvEAZuT6P209rH5fYbOgnaHUBpDkY+gVZAxngbXnwYyRkoZ0m/==
spring.datasource.username=admin
spring.datasource.password=G7Ex6eC6jw7vb7BKcWV/IVZ4hg9ZTEsn33Ln/q6Hcw9ePkHKA==
#连接池启动时初始化连接数
spring.datasource.druid.initial-size=5
spring.datasource.druid.min-idle=1
#连接池最大连接数,超过连接数将排队
spring.datasource.druid.max-active=20
spring.datasource.druid.max-wait=60000
        
```

