# Shell
## 1. tar

```shell
#c 打包 z gz压缩 v查看日志 f 指定压缩包名称 C 指定工作空间
tar -czvf test.tar.gz  -CsourceDir file1 file2
#r 新增文件到打包，.gz不能添加文件，.tar可以
tar -rvf test.tar -CsourceDir file1 file2
#t 预览压缩包内容
tar -tzvf test.tar.gz
#v 解压压缩包
tar -xzvf test.tar.gz

```

## 2. netstat

```shell
netstat -tunlp | grep 端口号
#-t (tcp) 仅显示tcp相关选项
#-u (udp)仅显示udp相关选项
#-n 拒绝显示别名，能显示数字的全部转化为数字
#-l 仅列出在Listen(监听)的服务状态
#-p 显示建立相关链接的程序名
```

## 3. find

```shell
#基础语法
find   path   -option   [   -print ]   [ -exec   -ok   command ]   {} \;
#查询path目录及子目录下文件名.c结尾的文件
find path -name "*.c"
#查询当前目录及其子目录最近20天内（-20）更新过的文件
find . -mtime -20
#c 文件内容获取权限改变 min 单位分钟
find . -cmin -10

#查询/var/log及其子目录中更改时间在7天以前（+7）的普通文件，并在删除（rm {} \; {}代表查询结果，反斜杠用来转义分号，分号表示命令结束）之前询问(-ok) f-文件 d-目录 
find /var/log -type f -mtime +7 -ok rm {} \;
#查询系统中所有普通文件且长度为0且权限为644的文件并列出它们的路径
find / -type f -size 0 -perm 644 -exec ls -l {} \;
```

## 4. 其他

```shell
#chmod 修改文件权限
#将path及其子目录下所有文件和文件夹赋予755权限;#6:读 4:写 1:执行
chmod -R 755 path
#给所有用户file的执行权限
chmod +x file
#chown修改文件所有者
#将file用户修改为root
chown root file
#将当前前目录下的所有文件与子目录的拥有者皆设为 runoob，群体的使用者 runoobgroup:
chown -R runoob:runoobgroup *
```

## 5. shell [脚本](https://www.runoob.com/linux/linux-shell-process-control.html)

```shell

# #!告诉系统脚本执行需要的解释器,如果使用sh运行则该行可以省略
#! /bin/bash

# 定义变量 变量名=变量值 =左右不能有空格!
key=value
# 反引号或者$()表示将命令结果赋值给key2
key2=`ls`
key2=$(ls)
# $key1 获取变量key1的值;也可以用${变量名}防止混淆;$HOME $PWD获取系统变量;$0获取命令本身 $1 $2获取执行脚本时传入的第一个参数 第二个参数的值
# $*获取所有参数的值作为一个整体 $@获取所有参数的值作为独立个体 $#获取参数数量
echo $0 $1 $2
echo $*
echo $@
echo 参数数量=$#
echo 当前的进程号=$$
echo 后台运行的最后一个进程PID=$!
#0成功 非0失败
echo 最后执行的命令结果=$?

#字符串
echo 字符串==
#双引号内部可以有空格,可以引用变量,不加双引号不能有空格;单引号内部不能引用变量,会原样输出;
str1=key2:$key2
str2='key2:$key2'
str3="${key2}key2"
echo str1 str2
#从第3位开始截取3个字符
echo ${key: 2: 3}
#从第3位开始截取直到末尾
echo ${key: 2}]
#从右边第3位开始截取直到末尾
echo ${key: 0-2}
#截取key中lu最后一次出现位置左边所有字符 %%第一次出现位置(从后面最大限度截取)
echo ${key%lu*}
#截取key中lu第一次出现位置右边所有字符 ##最后一次出现位置(从前面最大限度截取)
echo ${key#*lu}



#$((运算式))  $[运算式] `expr 运算式`
echo $(((2+3)*4))
echo $[(2+3)*4]
#expr 运算符间要有空格
echo 'expr 2 + 3'

#条件判断 [ condition ] condition前后要有空格
echo 条件判断==
if [ 20 -gt 10 ]; then
  echo '相等'
elif [ 20 -gt 10 ]; then
  echo '大于'
else
  echo '小于'
fi

#for循环
echo for循环==
for i in "$*"
do
	echo "the arg is $i"
done

sum=0
for ((i=0;i<10;i++))
do
	sum=$[$sum+$i]
donne
echo $sum

#while循环
echo while循环==
temp=0
whie [ $temp -le 10 ]
do
	sum=$[$sum+$temp]
	temp=$[$temp+1]
done
echo $sum

#数组
echo 数组

#声明方法
mk_dir(){
	if [ ! -d $1 ];then
		mkdir $1
	else
		echo $1 existed
	fi
}

#脚本执行时自动调用方法
mk_dir $1

```

