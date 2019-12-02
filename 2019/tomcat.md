# TomCat

1. ## 乱码问题

   1. 修改字体为微软雅黑
   2. HELP->cusjtom vm options 添加 -Dfile.encoding=UTF-8
   3. 修改注册表:HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor,新建**字符串值**:autorun = chcp 65001,这样每次启动cmd都会自动将编码改为UTF-8

2. tomcat 安装和配置

   1. 安装前先安装JDK
   2. [安装地址](<https://tomcat.apache.org/>),注意Tomcat9与jdk7不兼容
   3. 配置环境变量
      * 新建CATALINA_BASE,D:\JavaEE\apache-tomcat-9.0.8（此处为你的解压包路径）
      * 新建CATALINA_HOME,D:\JavaEE\apache-tomcat-9.0.8（此处为你的解压包路径)
      * 新建TOMCAT_HOME,D:\JavaEE\apache-tomcat-9.0.8（此处为你的解压包路径)
      * path 中添加 %CATALINA_HOME%\lib;%CATALINA_HOME%\bin (可有可无)
   4. 在tomcat目录下,执行 service.bat install (将其注册为服务,移除命令:service.bat remove)
   5. tomcat启动
      * 双击 tomcat9w.exe(杀死进程关闭)
      * 启动Apache Tomcat 9.0 Tomcat9 服务
      * 双击startup.bat (双击shutdown.bat关闭)
   6. server.xml 中,port = "8080"

