

# Docker

## 1. 下载安装

   * Windows安装 [DockerDesktop](https://www.docker.com/get-started),将会打开容器和Hyper-V功能

   * Ubuntu安装

	```bash
	curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
	```
	
* 配置

  ```bash
  # 配置镜像加速
  "registry-mirrors": [
      "http://hub-mirror.c.163.com/",
      "https://registry.docker-cn.com"
   ]
  ```

## 2.常用命令

* 帮助命令

  ```bash
  # 查看版本
  docker version
  # docker相关详细信息
  docker info
  # 帮助命令如:docker run --help
  docker --help
  ```

* 镜像命令

  ```bash
  # 查看本地镜像
  docker images
  # 查找镜像tomcat,查找地址:https://hub.docker.com/
  docker search tomcat
  # 拉取/下载镜像
  docker pull tomcat
  # 删除镜像tomcat
  docker rmi tomcat
  # 强制删除镜像tomcat
  docker rmi -f tomcat
  # 删除多个镜像
  docker rmi -f tomcat hello-world
  # 删除所有镜像
  docker rmi -f $(docker images -qa)
  ```

  

* 容器命令

  ```bash
  # 复制文件到容器
  docker cp filename ContainerName:/path/path
  # 设置容器启动项
  docker container update --restart=always nginx
  # 启动/重启容器
  docker start/restart CONTAINER
  停止/强停容器
  docker stop/ kill CONTAINER
  # 删除容器
  docker rm [OPTIONS] CONTAINER [CONTAINER...]
  # 重命名容器
  docker rename CONTAINER CONTAINER_NEW
  # -d后台执行以后,再进入容器,exit退出后容器会停止
  docker attach CONTAINER
  # [推荐]-d后台执行以后,进入容器执行容器命令,exit退出后容器会停止
  docker exec CONTAINER COMMAND
  docker exec -it containerId/name bash
  # 查看容器日志
  docker logs [OPTIONS] CONTAINER
  # 查看[所有]容器列表[不省略command]
  docker ps [-a] [--no-trunc]
  # 导出容器
  docker export id > file.zip
  
  ```

## 3. 示例

```bash

# 运行示例 docker/getting-started imagename
docker run -d -p 80:80 docker/getting-started
# 运行示例 nginx
# 搜索镜像
docker search nginx
# 下载镜像
docker pull nginx
# 启动镜像 -d:后台运行 -p:本机与容器端口映射 --name 容器自定义名称 镜像名称
docker run -d -p 8080:80 --name MyNginx nginx
# 访问nginx
浏览器访问: localhost:8080
# 后续可以直接使用MyNginx
docker start MyNginx
docker stop MyNginx
```

## 4. Dockerfile

* 创建Dockerfile 文件放到demo文件夹下

```dockerfile
# 基于jdk创建
FROM java:latest
# 作者名
MAINTAINER nikou
#指定工作路径
WORKDIR /home/npi
# 把demo-0.0.1-SNAPSHOT.jar添加到镜像,并重命名为demo.jar
ADD npi-0.0.1-SNAPSHOT.jar /home/npi/demo.jar
ADD lib /home/npi/lib
# 把8080端口暴露出来
EXPOSE 8080
# 启动容器以后默认执行命令:java -java demo.jar
ENTRYPOINT ["java","-jar","demo.jar"]
```

## 5. docker-compose

```dockerfile
#docker-compose.yml
version: '3'
services:

  npi-web:
    build: .
    ports:
      - "8066:8066"
    restart: always
    depends_on:
      - npi-redis
    #volumes:
    #  - ./web:/home/npi
      
  npi-redis:
    image: redis
    environment:
      - TZ=Asia/Shanghai
    command: redis-server --requirepass cdl12278@
    ports:
      - "6379:6379"
    volumes:
      - ./redis/data:/data
     
 
  volumes:
  # 只需指定一个路径，让引擎创建一个卷
  - /var/lib/mysql
  # 指定绝对路径映射
  - /opt/data:/var/lib/mysql
  # 相对于当前compose文件的相对路径
  - ./cache:/tmp/cache
  # 用户家目录相对路径
  - ~/configs:/etc/configs/:ro
  # 命名卷
  - datavolume:/var/lib/mysql
     
#执行命令
docker-compose up
docker-compose stop
#列出容器
docker-compose ps
#run：在一个服务上执行一个命令
docker-compose run web bash
```



* 在命令行执行以下命令

```dockerfile
# 在demo文件夹下执行,.代表当前文件夹,-t 指定tag
docker build -t my/demo .
# 创建并启动容器,因为java web默认在8080端口,所以映射8080
docker run -d --name demo -p 8080:8080 my/demo
# 浏览器访问:localhost:8080/hello  hello是demo.jar里写的一个接口,请求/hello接口会返回"hello world"
```



[参考文档](https://blog.csdn.net/weixin_42054155/article/details/90815393)

