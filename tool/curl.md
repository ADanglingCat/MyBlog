# curl

### 1. `-X` 指定请求方式, -G get请求

> curl -X GET url

### 2. -b 发送cookie

> curl -b 'key=value;key1=value1' https://google.com

### 3. -d 发送参数

> curl -d 'username=aa&password=123' -X POST https://google.com

### 4. -F --file 上传文件(自动加上Content-Type: multipart/form-data)

> curl -F 'file=@photo.png;type=image/png;filename=file.png' https://google.com/profile

### 5. -H --header 添加请求头

> curl -d '{"login": "emma", "pass": "123"}' -H 'Content-Type: application/json' https://google.com/login

### 6. -i 返回响应头

### 7. `-u`参数用来设置服务器认证 添加Authorization请求头

> curl -u 'user:pwd' https://www.example.com

### 8. -v 输出请求详情

> ![image-20210812092322154](https://s2.loli.net/2022/02/28/wDQbXFxArmq7GIj.png)

### 9. -L 让请求跟随服务器重定向

> curl -Lo cool.apk https://dl.coolapk.com/down\?pn\=com.coolapk.market\&id\=NDU5OQ\&h\=46bb9d98\&from\=from-web

### 10. -o 将服务器响应保存为文件,等同于wget

> curl -o filename.txt url