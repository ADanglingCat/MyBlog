# Spring

## 1. mybatisGenerator

* 添加依赖

  ```maven
  <dependency>
              <groupId>org.mybatis.generator</groupId>
              <artifactId>mybatis-generator-core</artifactId>
              <version>1.3.7</version>
          </dependency>
  ```

* 添加插件

  ```maven
  <build>
          <plugins>
              <plugin>
                  <groupId>org.springframework.boot</groupId>
                  <artifactId>spring-boot-maven-plugin</artifactId>
              </plugin>
              <plugin>
                  <groupId>org.apache.maven.plugins</groupId>
                  <artifactId>maven-compiler-plugin</artifactId>
                  <configuration>
                      <source>1.8</source>
                      <target>1.8</target>
                  </configuration>
              </plugin>
              <plugin>
                  <groupId>org.mybatis.generator</groupId>
                  <artifactId>mybatis-generator-maven-plugin</artifactId>
                  <version>1.3.7</version>
                  <configuration>
                      <!--允许移动文件-->
                      <verbose>true</verbose>
                      <!--是否覆盖-->
                      <overwrite>true</overwrite>
                      <!--<configurationFile>-->
                      <!--${basedir}/src/main/resources/generator/generatorConfig.xml-->
                      <!--</configurationFile>-->
                  </configuration>
                  <dependencies>
                      <dependency>
                          <groupId>mysql</groupId>
                          <artifactId>mysql-connector-java</artifactId>
                          <version>8.0.13</version>
                          <scope>runtime</scope>
                      </dependency>
                  </dependencies>
              </plugin>
          </plugins>
      </build>
  ```

  

* 在<u>resources</u>文件夹下创建文件<u>generatorConfig.xml</u>,格式如下:

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE generatorConfiguration
          PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
          "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">
  <generatorConfiguration>
      <!--加载配置文件，为下面读取数据库信息准备-->
      <properties resource="application.properties"/>
  
      <!--targetRuntime="MyBatis3Simple" 不会生成示例 -->
      <!--defaultModelType="flat" 所有bean属性平铺 -->
      <context id="Mysql" targetRuntime="MyBatis3Simple" defaultModelType="flat">
          <property name="autoDelimitKeywords" value="true" />
          <property name="beginningDelimiter" value="`" />
          <property name="endingDelimiter" value="`" />
          <property name="javaFileEncoding" value="utf-8" />
          <plugin type="org.mybatis.generator.plugins.SerializablePlugin" />
          <plugin type="org.mybatis.generator.plugins.ToStringPlugin" />
          <!--覆盖生成文件-->
          <plugin type="org.mybatis.generator.plugins.UnmergeableXmlMappersPlugin" />
          <!-- 注释,type里指定自定义注释生成类 -->
          <commentGenerator type="com.skyworth.spip.common.MybatisComment">
              <!-- 是否取消Mybatis默认注释 -->
              <property name="suppressAllComments" value="true"/>
              <!-- 生成注释是否带时间戳-->
              <property name="suppressDate" value="true" />
          </commentGenerator>
  
          <!--数据库链接地址账号密码-->
          <jdbcConnection driverClass="com.mysql.cj.jdbc.Driver"
                          connectionURL="${spring.datasource.url}"
                          userId="${spring.datasource.username}"
                          password="${spring.datasource.password}">
              <property name="nullCatalogMeansCurrent" value="true"/>
              <property name="useInformationSchema" value="true"/>
          </jdbcConnection>
  
          <!-- 类型转换 type 指定自定义的类型转换类-->
          <javaTypeResolver type="com.skyworth.spip.common.MybatisTypeResolver">
              <!-- 是否使用bigDecimal， false可自动转化以下类型（Long, Integer, Short, etc.）-->
              <property name="forceBigDecimals" value="false"/>
          </javaTypeResolver>
  
          <!--生成Model类存放位置-->
          <javaModelGenerator targetPackage="com.skyworth.spip.bean" 				                               targetProject="src/main/java">
              <property name="enableSubPackages" value="true"/>
              <property name="trimStrings" value="true"/>
          </javaModelGenerator>
  
          <!-- 生成mapxml文件 -->
          <sqlMapGenerator targetPackage="mapper" targetProject="src/main/resources" >
              <property name="enableSubPackages" value="false" />
          </sqlMapGenerator>
  
          <!-- 生成mapxml对应client，也就是接口dao -->
          <javaClientGenerator targetPackage="com.skyworth.spip.dao"                                        targetProject="src/main/java" type="XMLMAPPER" >
              <property name="enableSubPackages" value="false" />
          </javaClientGenerator>
        
  				<!-- 指定table,支持多个 -->
        	<!-- useActualColumnNames:使用实际的字段名 -->
          <table tableName="spec_item" mapperName="SpecItemDao">
              <property name="useActualColumnNames" value="true"/>
              <generatedKey column="id" sqlStatement="Mysql" identity="true"/>
  						<!--<columnOverride column="id" javaType="int"/>-->
          </table>
      </context>
  </generatorConfiguration>
  ```

  

* 自定义类型转换

  ```java
  package com.skyworth.spip.common;
  
  import org.mybatis.generator.api.dom.java.FullyQualifiedJavaType;
  import org.mybatis.generator.internal.types.JavaTypeResolverDefaultImpl;
  
  import java.sql.Types;
  
  public class MybatisTypeResolver extends JavaTypeResolverDefaultImpl {
      public MybatisTypeResolver() {
          super();
          super.typeMap.put(Types.INTEGER, new JdbcTypeInformation("INTEGER", //$NON-NLS-1$
                  new FullyQualifiedJavaType("int")));
      }
  }
  
  ```

  

* 自定义注释生成

  ```java
  package com.skyworth.spip.common;
  
  import org.mybatis.generator.api.IntrospectedColumn;
  import org.mybatis.generator.api.IntrospectedTable;
  import org.mybatis.generator.api.MyBatisGenerator;
  import org.mybatis.generator.api.dom.java.Field;
  import org.mybatis.generator.api.dom.java.TopLevelClass;
  import org.mybatis.generator.config.Configuration;
  import org.mybatis.generator.config.xml.ConfigurationParser;
  import org.mybatis.generator.internal.DefaultCommentGenerator;
  import org.mybatis.generator.internal.DefaultShellCallback;
  import org.springframework.util.StringUtils;
  
  import java.io.File;
  import java.util.ArrayList;
  import java.util.List;
  
  public class MybatisComment extends DefaultCommentGenerator {
  		/**
  		 * javabean注释
  		*/
      @Override
      public void addModelClassComment(TopLevelClass topLevelClass, IntrospectedTable introspectedTable) {
          String remarks = introspectedTable.getRemarks();
          topLevelClass.addImportedType("org.apache.ibatis.type.Alias");
          if (StringUtils.hasText(remarks)) {
              topLevelClass.addJavaDocLine("/**");
              topLevelClass.addJavaDocLine(" * "+remarks);
              topLevelClass.addJavaDocLine(" */");
          }
          String fileName = introspectedTable.getMyBatis3XmlMapperFileName();
           //添加注解  
          topLevelClass.addAnnotation(
             "@Alias(\""+fileName.substring(0,fileName.indexOf("Dao.xml"))+"\")");
      }
    
  		/**
  		 * javabean注释
  		*/
      @Override
      public void addFieldComment(Field field, IntrospectedTable introspectedTable, IntrospectedColumn introspectedColumn) {
          String remarks = introspectedColumn.getRemarks();
          if (StringUtils.hasText(remarks)) {
              field.addJavaDocLine("/**");
              field.addJavaDocLine(" * "+remarks);
              field.addJavaDocLine(" */");
          }
      }
  
      public static void main(String[] args) {
          // 执行中的异常信息会保存在warnings中
          List<String> warnings = new ArrayList<String>();
          try {
              // true:生成的文件覆盖之前的
              boolean overwrite = true;
              // 读取配置,构造 Configuration 对象.
              // 如果不想使用配置文件的话,也可以直接来 new Configuration(),然后给相应属性赋值.
              File configFile = new File(".\\src\\main\\resources\\generatorConfig.xml");
              ConfigurationParser cp = new ConfigurationParser(warnings);
              Configuration config = cp.parseConfiguration(configFile);
              DefaultShellCallback callback = new DefaultShellCallback(overwrite);
              MyBatisGenerator myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
              myBatisGenerator.generate(null);
              for (String warning : warnings){
                  Tool.info("MybatisComment main warning:",warning);
              }
              Tool.info("MybatisComment main : over!Dao需要手动添加注解");
          } catch (Exception e) {
              Tool.error(e);
          }
  
      }
  
  }
  ```

  

## 2. 统一异常处理

* 使用@ControllerAdvice 或@RestControllerAdvice注解标识

  ```java
  package com.skyworth.spip.config;
  
  import com.skyworth.spip.common.EmailUtils;
  import com.skyworth.spip.common.Tool;
  import org.springframework.beans.factory.annotation.Autowired;
  import org.springframework.http.HttpStatus;
  import org.springframework.http.ResponseEntity;
  import org.springframework.mail.javamail.JavaMailSender;
  import org.springframework.web.bind.annotation.ExceptionHandler;
  import org.springframework.web.bind.annotation.RestControllerAdvice;
  import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;
  
  import javax.servlet.http.HttpServletRequest;
  
  @RestControllerAdvice
  public class GlobalExceptionConfig extends ResponseEntityExceptionHandler {
      private Tool tool;
      private JavaMailSender javaMailSender;
  
      @Autowired
      public void setTool(Tool tool) {
          this.tool = tool;
      }
  
      @Autowired
      public void setJavaMailSender(JavaMailSender javaMailSender) {
          this.javaMailSender = javaMailSender;
      }
  		/**
  		 * @ExceptionHandler指定要处理的异常类型
  		*/
      @ExceptionHandler(Exception.class)
      ResponseEntity<?> handleControllerException(HttpServletRequest request, Throwable ex) {
          if (!Tool.isBeta()) {
              String uri = request.getRequestURI();
              String userAccount = tool.getUserAccount(request);
              EmailUtils emailUtils = new EmailUtils();
              emailUtils.setDetail(javaMailSender
                      ,"Exception:"+uri+" "+userAccount
                      ,emailUtils.generateContent(Tool.getExceptionDetail(ex))
                      ,"dongfeiyang@skyworth.com");
              emailUtils.setPriority(EmailUtils.PRIORITY_HIGH);
              emailUtils.sendEmail();
          }
          HttpStatus status = getStatus(request);
          return new ResponseEntity<>(status);
      }
  
      private HttpStatus getStatus(HttpServletRequest request) {
          Integer statusCode = (Integer) request
            .getAttribute("javax.servlet.error.status_code");
          if (statusCode == null) {
              return HttpStatus.INTERNAL_SERVER_ERROR;
          }
          return HttpStatus.valueOf(statusCode);
      }
  }
  
  ```

  

## 3. Spring事务

## 4. 异步任务

## 5. log配置


   * 创建<u>logback-spring.xml</u>文件

     ```xml
     <?xml version="1.0" encoding="UTF-8"?>
     <!--scan:是否自动检测配置文件变动 debug:是否输出logback运行日志-->
     <configuration scan="false" scanPeriod="60 seconds" debug="false">
         <!-- 应用程序名称 -->
         <contextName>logback</contextName>
         <springProperty scope="context" name="LOG_HOME" source="logging.file"/>
         <!-- 定义全局变量 通过${propertyName}访问value-->
         <!--<property name="log.path" value="logback.log"/>-->
         <!--输出到控制台-->
         <appender name="console" class="ch.qos.logback.core.ConsoleAppender">
             <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
                 <level>DEBUG</level>
             </filter>
             <encoder>
                 <pattern>%d{HH:mm:ss} %highlight(%-5level):%msg%n</pattern>
             </encoder>
         </appender>
     
         <!--输出到文件-->
         <appender name="file" class="ch.qos.logback.core.rolling.RollingFileAppender">
             <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
                 <level>DEBUG</level>
             </filter>
             <file>${LOG_HOME}</file>
             <!-- 滚动记录日志行为 -->
             <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                 <fileNamePattern>logback%d{yyyy-MM-dd}.log</fileNamePattern>
                 <maxHistory>30</maxHistory>
                 <totalSizeCap>1GB</totalSizeCap>
             </rollingPolicy>
             <encoder>
                 <pattern>%d{HH:mm:ss} %contextName [%thread] %-5level %logger{36} - %msg%n</pattern>
             </encoder>
         </appender>
     
         <springProfile name = "dev">
             <logger name="com.skyworth.spip.dao" level="debug"/>
             <root level="info">
                 <!-- appender name -->
                 <appender-ref ref="console"/>
             </root>
         </springProfile>
         <springProfile name = "test">
             <logger name="com.skyworth.spip.dao" level="debug"/>
             <root level="info">
                 <appender-ref ref="file"/>
                 <appender-ref ref="console"/>
             </root>
         </springProfile>
         <springProfile name = "prod">
             <logger name="com.skyworth.spip.dao" level="error"/>
             <root level="info">
                 <appender-ref ref="file"/>
             </root>
         </springProfile>
         <!-- 为特定类或目录配置,additivity:是否向上级(上一级目录的配置是这一级目录的上级)传递打印信息 -->
         <!--logback.LogbackDemo：类的全路径 -->
         <!--<logger name="com.dudu.controller.LearnController" level="WARN" additivity="false">-->
             <!--<appender-ref ref="console"/>-->
         <!--</logger>-->
     </configuration>
     ```

## 6.