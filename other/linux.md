# vim 
## 查找替换
 s/vivian/sky/ 替换当前行第一个 vivian 为 sky 

 s/vivian/sky/g 替换当前行所有 vivian 为 sky 

 %s/vivian/sky/（等同于 ：g/vivian/s//sky/） 替换每一行的第一个 vivian 为 sky 

 %s//sky/ 替换当前选择的字符串

 选择区域后， 输入 ':'

 '<,'>s/vv/kk/    区域替换


 s/^.*a/ /  替换行开始到"a" 为 " "

 s/a.*$/ /  替换行"a"结束  为 " "


 s/[0-9]+/ /  替换行"数字" 为 " "

## 合并行
 选择区域后， 输入 'J'


# 数据处理
## sort 
  sort -k1n 
## uniq
 uniq -c
 
 sort f  | uniq -c  | sort -k1n

## awk 
  awk  '$2>50{pirnt $1 $2 }'

# firefox 开发工具

## 查看 按钮对应js代码
 查看元素　-> 事件
![](https://raw.githubusercontent.com/xcwen/spacemacs-config/master/other/1.png)
 
## 查看 行数代码的位置 
  控制台  输入　函数 回车，

  点击　　 控制台 输出　跳转
![](https://raw.githubusercontent.com/xcwen/spacemacs-config/master/other/2.png)


# emacs
所有的键盘按键都是快捷键 ， 都对应了相应的函数 

## 快捷键：

   M-x:  进入输入命令模式

   F1 k : 查看快捷键对应的函数

