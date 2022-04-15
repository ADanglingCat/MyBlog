# ElasticSearch

## 一. 基础使用

### 1. 安装

[教程地址](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI1NDY0MTkzNQ==&action=getalbum&album_id=1591614521561923586&scene=173&from_msgid=2247491899&from_itemidx=1&count=3#wechat_redirect)

``` bash
#下载
https://www.elastic.co/cn/elasticsearch/
#解压后执行启动命令
./bin/elasticsearch
#如果这时报错"max virtual memory areas vm.maxmapcount [65530] is too low"，要运行下面的命令。
sudo sysctl -w vm.max_map_count=262144
#Elastic 就会在默认的9200端口运行
curl localhost:9200
{
  "name" : "DONGFEIYANG-NB",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "seQckbvQTAuxLaX3NdnrfQ",
  "version" : {
    "number" : "7.10.0",
    "build_flavor" : "default",
    "build_type" : "zip",
    "build_hash" : "51e9d6f22758d0374a0f3f5c6e8f3a7997850f96",
    "build_date" : "2020-11-09T21:30:33.964949Z",
    "build_snapshot" : false,
    "lucene_version" : "8.7.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}

#默认情况下，es 只允许本机访问，如果需要远程访问，可以修改 es 安装目录的config/elasticsearch.yml文件，去掉network.host的注释，将它的值改成0.0.0.0，然后重新启动 Elastic。
network.host: 0.0.0.0

#安装ik分词器 注意版本要与es完全一致 这里是7.10.0 安装以后要重启es
./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.10.0/elasticsearch-analysis-ik-7.10.0.zip

```

### 2. 介绍

> ElasticSearch 核心功能就是数据检索，首先通过索引将文档写入 es。查询分析则主要分为两个步骤：
>
> 1. 词条化：**分词器**将输入的文本转为一个一个的词条流。
>
> 2. 过滤：比如停用词过滤器会从词条中去除不相干的词条（的，嗯，啊，呢）；另外还有同义词过滤器、小写过滤器等。
>

### 2.1 Index

> ES会索引所有字段，经过处理后写入一个反向索引（Inverted Index）。查找数据的时候，直接查找该索引。
>
> 所以，Elastic 数据管理的顶层单位就叫做 Index（索引）。每个 Index 的名字必须是小写。
>
> ```bash
> #查询索引状态
> curl -X GET 'http://localhost:9200/_cat/indices/index_name?v'
> #查看当前节点所有index
> curl -X GET 'http://localhost:9200/_cat/indices?v'
> #查询索引
> curl -X GET "localhost:9200/index_name
> #创建索引
> curl -X PUT "localhost:9200/index_name
> #创建索引时可以指定settings和mappings参数,用来指明索引的配置和字段映射
> #7.0之前,mappeings下一级可以指定type
> PUT /index_name
> {
>   "settings": {
>     "number_of_shards": 1,
>     "number_of_replicas": 2
>   },
>   "mappings": {
>     "properties": {
>       "field1": { "type": "text" }
>     }
>   }
> }
> 
> # 添加/更新mapping
> PUT /index_name/_mapping
> {
>   "properties": {
>       "field1": { "type": "keyword" }
>   }
> }
> ```

### 2.3 Document

> Index 里面单条的记录称为 Document（文档）。许多条 Document 构成了一个 Index。
>
> 同一个 Index 里面的 Document，不要求有相同的结构（scheme），但是最好保持相同，这样有利于提高搜索效率。
>
> ```bash
> #创建文档
> PUT /index_name/_doc/id
> POST /index_name/_doc
> #搜索文档
> GET /index_name/_doc/id
> #模糊搜索
> GET /index_name/_search
> {
>   "query": { "match_all": {} },
>   "sort": [
>     { "account_number": "asc" }
>   ],
>   "from": 10,
>   "size": 10
> }
> #match or查询 搜索地址字段中包含 mill 或 lane 的客户
> GET /index_name/_search
> {
>   "query": { "match": { "address": "mill lane" } }
> }
> #match and查询 搜索地址字段中同时包含 mill和lane 的客户
> GET /index_name/_search
> {
>   "query": { "match_phrase": { "address": "mill lane" } }
> }
> #构造更复杂的查询，可以使用布尔查询来组合多个查询条件，must match、should match、must not match
> GET /index_name/_search
> {
>   "query": {
>     "bool": {
>       "must": [
>         { "match": { "age": "40" } }
>       ],
>       "must_not": [
>         { "match": { "state": "ID" } }
>       ]
>     }
>   }
> }
> #用filter过滤结果(类似match_not)
> GET /index_name/_search
> {
>   "query": {
>     "bool": {
>       "must": { "match_all": {} },
>       "filter": {
>         "range": {
>           "balance": {
>             "gte": 20000,
>             "lte": 30000
>           }
>         }
>       }
>     }
>   }
> }
> ```

### 3. 常用操作

```bash
#创建索引test
curl -X PUT 'localhost:9200/test'
#测试分词器
curl -X POST 'localhost:9200/test/_analyze' -d {"analyzer":"ik_smart","text":"我是中国人,我爱中国"}
```

### 4. 原理

### 4.1 并发控制

> ![image-20210120090603205](https://s2.loli.net/2022/02/28/aherKjc2OzYIskQ.png)
>
> ![image-20210120090633326](https://s2.loli.net/2022/02/28/WYMgvuKCzof38pA.png)

### 4.2 倒排索引

> 一般来说，倒排索引分为两个部分：
>
> - 单词词典（记录所有的文档词项，以及词项到倒排列表的关联关系）
> - 倒排列表（记录单词与对应的关系，由一系列倒排索引项组成，倒排索引项指：文档 id、词频（TF）（词项在文档中出现的次数，评分时使用）、位置（Position，词项在文档中分词的位置）、偏移（记录词项开始和结束的位置））

### 4.3 搜索

> 搜索分为两个过程：
>
> 1. 当向索引中保存文档时，默认情况下，es 会保存两份内容，一份是 `_source` 中的数据，另一份则是通过分词、排序等一系列过程生成的倒排索引文件，倒排索引中保存了词项和文档之间的对应关系。
> 2. 搜索时，当 es 接收到用户的搜索请求之后，就会去倒排索引中查询，通过的倒排索引中维护的倒排记录表找到关键词对应的文档集合，然后对文档进行评分、排序、高亮等处理，处理完成后返回文档。