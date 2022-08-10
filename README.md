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

# 加上 .bashrc /.zshrc
alias vi="emacsclient -n"



function git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
    #echo -e "(\033[0;31m"${ref#refs/heads/}"\033[0m)";
    echo -e "("${ref#refs/heads/}")";
}

PS1='localhost:\w$(git_branch)$ '

```


### multi-term

#### zsh


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
#php 代码检查
sudo apt-get install phpmd php-cli php-xml php-codesniffer

cd /project/to/path # 项目根目录
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

### c++ 编码需要
apt-get install clangd-11

#### 从make/cmake 生成补全配置
https://edward852.github.io/post/%E7%94%9F%E6%88%90compile_commands.json%E6%96%87%E4%BB%B6/

compile_commands.json 文件能够有效提高一些工具(比如说ccls1, vscode2)的代码跳转、补全等功能。

因此，本文将会说明如何生成 compile_commands.json 文件，特别是使用 makefile 的老工程。

不过很多(旧的)工程都是用 makefile 来编译的，没有现成的选项生成 compile_commands.json 文件。

虽然也可以使用 ctags, gtags 等，但是跳转其实不是很准确。

我们可以通过 Bear 来生成，而且不需要改动代码。

具体Bear的安装这里就不赘述了，按照 官方文档 来即可。

安装之后，执行以下命令即可生成：
bear make

###python  补全jedi 需要
```
apt-get install virtualenv
or:
apt-get install python-virtualenv
```

### go 补全 需要
```bash

apt-get install golang

GO111MODULE=on go install golang.org/x/tools/gopls@latest


```
`.spacemacs.d/.spacemacs.env`  文件里要注意 go的环境配置

```bash
GOPATH=/Users/jim/goprojects
GOROOT=/usr/local/go
GO111MODULE=on
GOPROXY=https://goproxy.cn

```
还要注意 当前的项目地址的问题
