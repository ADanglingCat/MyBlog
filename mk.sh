#!/bin/zsh
#声明方法
mk_dir(){
  dir=$1
	if [ ! -d $dir ];then
    echo mkdir $dir
		mkdir $dir
    echo "# $dir" > $dir/readme.md
    echo "* [$dir]($dir/readme.md)" >> _sidebar.md
	else
		echo $dir existed
	fi
}
mk_file(){
  file=$1/$2.md
  filename=$2
	if [ ! -f $file ];then
    echo mkfile $file
    echo "# $filename" > $file
    echo "\t* [$filename]($file \"$3\")" >> _sidebar.md
  else
    echo $file existed
  fi
}
#脚本执行时自动调用方法
mk_dir $1 $2
mk_file $1 $2 $3
