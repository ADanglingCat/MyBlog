#声明方法
mk_dir(){
	if [ ! -d $1 ];then
		mkdir $1
    echo "# $1" > $1/readme.md
    echo "# $2" > $1/$2.md
    echo "\n* [$1]($1/readme.md)\n\t* [$2]($1/$2.md)" >> _sidebar.md
	else
		echo $1 existed
	fi
}

#脚本执行时自动调用方法
mk_dir $1 $2
