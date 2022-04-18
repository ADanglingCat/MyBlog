# Git

## 1. 常用命令

* 切换远程地址

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
  #保留提交:p 合并提交:s 
  #按a修改后:wq保存并退出,或者:q!不保存退出
  ```
  
* 绑定远程分支

  ```git
  #查看所有分支
  git branch -a
  #查看分支关联关系
  git branch -vv
  #解除绑定
  git branch --unset-upstream
  #添加绑定
  git branch --set-upstream-to origin/dev
  #添加绑定(第二种方法)
  git -u origin/dev
  ```

* 编辑tag

  ```git
  #查看所有tag
  git tag
  #查看某个tag
  git show name
  #搜索tag
  git tag -l "na*"
  #增加tag -a:名称 -m:"内容" 85fc7e7:commitId
  git tag -a 'name' -m 'message'
  #删除tag
  git tag -d name
  #删除远程tag
  git push origin :refs/tags/name
  #删除远程tag(会将分支删除?)
  git push origin --delete name
  #同步tag
  git push origin name
  git push --tags
  git fetch origin tag name
  ```
  
* 分支管理

  ```git
  #查看分支信息
  git branch
  #切换到a分支
  git checkout a
  #以master分支为基础创建并切换到a分支(master也可以换成tagName)
  git checkout -b a master
  #删除a分支
  git branch -d a
  
  ```

* git 配置

  ```git
  #查看系统配置
  git config --system --list
  #查看当前用户配置
  git config --global --list
  #查看当前仓库配置
  git config --local --list
  #更新配置
  git config --global --user.email = 123
  #删除配置
  git config --global --unset user.email
  
  ```

  

## 2. 常见问题

* 待完成
