# Redis

## 1. 常用命令

### 1.1 linux

```shell
/etc/init.d/redis-server stop
/etc/init.d/redis-server start
/etc/init.d/redis-server restart

#删除key
del key
#序列化key
dump key
#判断key是否存在
exists key
#查看当前有效期秒[毫秒] 设置有效期 移除有效期
[p]ttl key
expire key
persist key
#查看所有key
keys *
```

### 1.2 windows

```powershell
#下载 https://github.com/MSOpenTech/redis/releases
#启动服务
redis-server[.exe] [redis.windows.conf]
#访问服务
redis-cli[.exe -h 127.0.0.1 -p 6379 -a pwd[]
#获取设置
config get config_setting_name
#调整设置
config set configname value
#中文乱码(调整windows控制台乱码) 
chcp 65001 
redis-cli --raw
```





##  2. 数据结构

### 2.1 String类型

```shell
#设置键值对[10秒过期]
set key value [ex 10]
setex key 10 value
setrange key 0 a
#存在才修改
setnx key value
#获取,获取子字符串
get key
getrange key 1
#删除(可以删除所有类型的key)
del key
#追加字符串
append key appendValue
#减1(value必须是数字) incr incrby  incrbyfloat
decr key
#减n
decrby key n
#批量操作
mset key1 value1 key2 value2
mget key1 key2
#字符串长度
strlen key
#二进制
setbit key value
getbit key
bitcount key
```

### 2.2 Hash类型(存储对象)

```shell
#basic
hmset key field1 value1 field2 value2
hmget key [field1]
hset key field1 value1
hget key field1
hdel key field1 field2
#返回所有key,所有value,所有key,value
hkeys key
hvals key
hgetall key
#判断是否存在属性
hexists key field
#某个filed的value长度
hstrlen key field
#自增n hincrbyfloat
hincrby key field n
```



### 2.3 List类型(有序,可重复)

```shell
#基本操作
lpush key v1 v2
lrange key 0 -1
lpop key
#获取指定位置元素(-n代表倒数第n个)
lindex key 
#截取指定区间
ltrim key 1 2
#阻塞弹出(list为空时等待60s,再停止)
blpop key 60
```

### 2.4 Set类型(无序,不可重复)

```shell
#基本操作
sadd key v1 v2
smembers user
srem key dfy
#随机返回并出栈
spop user
#随即返回n个元素但不出栈
srandmember key [n]
#1 存在 0 不存在
sismember key v1
#返回两个集合差集(set1减去set2)[结果保留到新的集合set3中]
sdiff[store set3] set1 set2
#两个集合交集
sinter[store set3] set1 set2
#并集
sunion set1 set2

```



### 2.5 zset类型(有序,不可重复)

```shell
zadd key score1 v1 s2 v2
zrem key v1
#指定区间数量
zlexcount key - +
zlexcount key [v1 [v4
#指定区间成员
zrangebylex key
#返回v2的score
zscore key v1
#返回一组元素
zrange key 0 -1 [withscore]
zrevrange key 0 10
zrangebyscore key 13 20
#元素数量
zcard key
#score在某个区间内元素个数
zcount key 0 60
#元素排第几位
zrank key v1
zrevrank key v1
#score自增n
zincrby key v1 n
#两个集合交集
zinterstore

```



## 3. 基本使用

### 3.1 远程连接

* 注释bind 127.0.0.1
* 开启requirepass,设置密码

### 3.2 发布订阅

subscribe channel...
unsubscribe channel..
psubscrbe pattern ...
publish channel msg
事务(批量处理)
multi 开始事务
exec执行事务

```java
//注解
//Cache	缓存接口，定义缓存操作。实现有:RedisCache、EhCacheCache、ConcurrentMapCache等
CacheManager	//缓存管理器，管理各种缓存（cache）组件
@Cacheable	//方法被调用时，先从缓存中读取数据，如果缓存没有找到数据，再调用方法获取数据，然后把数据添加到缓存中
@CacheEvict	//清空缓存
@CachePut	//执行方法后缓存,常用于更新
EnableCaching /开启基于注解的缓存
keyGenerator	缓存数据时key生成策略
serialize	缓存数据时value序列化策略
@CacheConfig 统一配置本类的缓存注解的属性
@Caching 对多个缓存进行分组 
  @Caching(evict = { 
           @CacheEvict("addresses"),        @CacheEvict(value="directory",key="#customer.name") })
```

