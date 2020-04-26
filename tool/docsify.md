# Docsify 文档生成工具

## 官方文档

[地址](https://docsify.js.org/#/?id=docsify)

## 安装

```bash
npm install docsify-cli -g
docsify init ./docs
docsify serve docs
```



## 基本设置

* `index.html` 入口文件,相关配置也在里面

```html
<!--加载提示语-->
<div id="app">Please wait...</div>
<!--添加侧边栏:根目录创建_sidebar.md-->
<!--根据标题自动生成二级目录:subMaxLevel,想忽略当前标题: #Tool {docsify-ignore},忽律当前页面: {docsify-ignore-all} -->
<!--右上角添加github地址-->
<!--翻页自动移到顶部-->
<script>
  window.$docsify = {
    loadSidebar: true,
    maxLevel: 2,
    name: '',
    repo: '',
    auto2top: true,
  }
</script>
<!--扩展emoji支持-->
<script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/emoji.min.js"></script>
<!--click to copy code blocks-->
<script src="//cdn.jsdelivr.net/npm/docsify-copy-code"></script>
<!--zoom image,排除![](image.png ":no-zoom")-->
<script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/zoom-image.min.js"></script>
<!--gittalk-->
```

* `README.md` 首页内容
* `.nojekyll` prevents GitHub Pages from ignoring files that begin with an underscore



