# Emacs 配置文件


**测试过的环境**

`ubuntu17.10`

`deepin2015.5`


## 说明 


* 基于　[spacemacs](https://github.com/syl20bnr/spacemacs) 

* 使用 `EVIL` 模拟 `VIM`  ,使得emacs的编辑和vim 保持95%以上的一致性

* 使用 `multi-term` 实现多终端模拟器， 基本上不用系统自带的终端模拟器


* 基于 phpctags +  [ac-php](https://github.com/xcwen/ac-php)  实现的 php 补全，跳转 

* 使用  `rtags` + `clang` 作 `c++` 代码补全

* `rtags` : 基于llvm . 真正实现了能编译，就能补全，跳转 :https://github.com/Andersbakken/rtags/

## 安装 

###基本安装
安装 spacemacs
```bash
#备份原有的文件
cd $HOME 
mv .emacs.d .emacs.d.bak 
mv .emacs .emacs.bak 


cd $HOME 
git clone https://github.com/syl20bnr/spacemacs.git
ln  -s spacemacs .emacs.d
cd spacemacs 
#切换到开发版本
git check develop

```


安装 spacemacs 配置
```bash
cd $HOME 

git clone https://github.com/xcwen/spacemacs-config.git

ubuntu 字体
mkdir ~/.fonts
cp ~/spacemacs-config/other/XHei_Mono.Ubuntu.ttc  ~/.fonts/

//创建  .spacemacs.d
rm -f ~/.spacemacs.d
ln -s ~/spacemacs-config ~/.spacemacs.d

# 加上 .bashrc
alias vi="emacsclient -n"



function git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
    #echo -e "(\033[0;31m"${ref#refs/heads/}"\033[0m)";
    echo -e "("${ref#refs/heads/}")";
}

PS1='localhost:\w$(git_branch)$ '

```

 安装后helm 报错时

　运行:　~/spacemacs-config/reset_helm.sh , 重启emacs


### multi-term
屏蔽的大部分的emacs 本身的快捷键
可在term 中使用vim 

可用快捷键:
```
"M-x"    M-x 
"M-1"    最大化 
"C-^"    打开当前文件列表
"C-6"    发"\C-^"   # C-^  在vim 中有用 ，使用  C-6 代替
"C-S-j"  进入终端

"C-S-t"  新建终端 
"C-S-h"  上个终端
"C-S-l"  下个终端
"C-S-c"  发C-c 
"C-c"    复制 
"M-w"    复制 
"C-v"    黏贴
"C-y"    黏贴
```


###php 补全 

指定项目所在的根目录,在项目根目录上生成.tags目录

``` bash
cd /project/to/path # 项目根目录
mkdir .tags
```
emacs php-mode 快捷键 
```
    tab       : -> 补全 
    C-tab     : 补全
    C-]       : 跳转到定义
    C-t       : 跳转返回
    ,a        : 切换 control, view, js  对应的文件
    ,i        : 查看定义
    ,u        : 当前词，切换大小写 
    ,e        : 删除多余空格，调整到出错的地方 
    ,r        : 重新生成tags
```
补全案例：

![补全案例gif](https://raw.githubusercontent.com/xcwen/site-lisp/master/other_script/ac-php.gif)

更多的请参考  [ac-php](https://github.com/xcwen/ac-php)

### typescript 补全 需要
```
npm install typescript -g 
```

###c++ 编码需要
``` bash
apt-get install fcitx clang cmake g++ libclang-dev libssl-dev libcurses-ocaml-dev cscope
```


查看 rtags 说明: https://github.com/Andersbakken/rtags ; 
安装 rtags: 

``` bash
cd ~/ &&  git clone https://github.com/Andersbakken/rtags/
cd ~/rtags/src &&  git clone https://github.com/Andersbakken/rct
cd ~/rtags && mkdir build && cd ~/rtags/build/ && cmake ../ && make && sudo make install 
ln -s ~/rtags/bin/gcc-rtags-wrapper.sh ~/bin/c++
ln -s ~/rtags/bin/gcc-rtags-wrapper.sh ~/bin/cc
ln -s ~/rtags/bin/gcc-rtags-wrapper.sh ~/bin/g++
ln -s ~/rtags/bin/gcc-rtags-wrapper.sh ~/bin/gcc
 #export 放到~/.bashrc
export PATH=~/bin/:$PATH
```

启动 rtags 服务:

``` bash
$rdm 
```


###python  补全jedi 需要
```
apt-get install virtualenv
or:
apt-get install python-virtualenv
```

### go 补全 需要
```
apt-get install golang 

#  安装liteide 的 gocode ,原版的不好 
wget  https://github.com/visualfc/gocode

```


