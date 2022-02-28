# Mysql

1. ## 常用命令

```mysql
#创建用户
create user 'USERNAME'@'HOST' identified by 'PASSWORD';
#授予权限
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost'
#修改密码
set password for 'root'@'localhost'=PASSWORD('redhat');
#创建用户
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;
#刷新权限
flush privileges;
#修改密码
mysqladmin -uroot  password 'sqlpwd123' -p
#查看连接
show full processlist;
#查看权限
show grants for 'USERNAME'@'HOST';
#移除权限
revoke all on db.xsb from 'tom'@'localhost';
```

2. ## 设置远程连接

```shell
# 修改配置文件的端口绑定
sudo vim /etc/mysql/my.cnf
# 没有该文件则尝试
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
# 注释掉bind-address = 127.0.0.1
# 修改访问权限
mysql -u root -p XXX
SELECT host FROM mysql.user WHERE User = 'root';
grant all privileges on *.* to root@"%" identified by "pwd" with grant option;
flush privileges;
exit;
# 重启mysql服务
/etc/init.d/mysql restart
```

