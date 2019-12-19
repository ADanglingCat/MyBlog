# Git

[TOC]



## 1. git 常用命令

* 切换远程分支

  ```git
  #修改有三种方式
      #1.直接修改
      git remote set-url origin url
      #2.先删除后修改
      git remote rm origin
      git remote add origin url
      #3.直接修改conf文件
  #修改后执行
  git pull --allow-unrelated-histories
  ```

* 合并提交,修改提交信息

  ```git
  #查看要修改的提交
  git log
  #打开交互界面
  git rebase -i HEAD~3
  #保留提交:p 合并提交:s 按a修改后:wq保存并退出,或者:q!不保存退出
  
  ```

## 2. 常见问题

* 待完成

