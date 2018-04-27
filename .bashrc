#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

test -f ~/admin_yb1v1/install_files/artisan.sh && source ~/admin_yb1v1/install_files/artisan.sh
test -f ~/bin/all_elixir_auto_complete.bash && source ~/bin/all_elixir_auto_complete.bash
test -f ~/bin/git-flow-completion.bash && source ~/bin/git-flow-completion.bash

function git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
    echo -e "(\033[0;31m"${ref#refs/heads/}"\033[0m)";
}

function work_dir_color_begin () {
    admin_work_dir=$( echo $PWD |grep "$HOME/admin_yb1v1" )
    if [ "$admin_work_dir" != "" ]  ; then
        work_dir=$( ls -l $HOME/admin_yb1v1 |  awk '{ print $(NF) }' )
        git_dir=$(echo $work_dir | grep  "git" )
        if [ "$git_dir" == "" ] ;then
            echo -e "\033[0;31m";
        else
            echo -e "\033[0;32m";
        fi
    fi

}
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
MC_FLAG="localhost"
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    #PS1='localhost:`work_dir_color_begin`\w\033[0m\$ '
    PS1='localhost:\w$(git_branch)$ '
    ;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|linux)
    PROMPT_COMMAND='echo -ne "\033]0;'$MC_FLAG'\007"'
    ;;
*)
    ;;
esac


# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'

    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi
alias l='ls -allh'
alias l.='ls -d .* --color=tty'
alias ll='ls -lh --color=tty'
alias ls='ls --color=tty'
alias telnet="telnet -8 -e^e"
alias rm="rm -i"
alias df="df -h"
alias dir='ls  -d */'
alias cdd='cd $HOME/桌面'

alias cdolog='get_work_dir ./old/data/log/app/default'
alias cdow='get_work_dir  ./old/handler/'
alias cdov='get_work_dir ./old/template/'
alias cdom='get_work_dir ./old/model/'

alias cdh='get_work_dir ./app/Helper/'
alias cdlog='get_work_dir  ./storage/logs  " "  ./log  '
alias cdcli='get_work_dir  ./cli   '
alias cdjs='get_work_dir ./public/page_js ./web_public/page_js'
alias cdvv='get_work_dir ./vue/src/views'
alias cdts='get_work_dir ./public/page_ts ./web_public/page_ts'
alias cdv='get_work_dir ./resources/views/ ./views'
alias cdw="get_work_dir  ./app/Http/Controllers/ ./routes ./app/Controllers/  "
alias cdm="get_work_dir  ./app/Models ./modules"
alias cdj="get_work_dir  ./app/Jobs "
alias cde="get_work_dir  ./enum_config "
alias cdc="get_work_dir  ./app/Console/Commands"

alias cddb='cd  ~/admin_yb1v1/database/migrations/  '
function show_work_git_dir() {
    work_dir=$(ls -l $PWD  |  awk '{ print $(NF) }' )
    git_dir=$(echo $work_dir | grep  "git" )
    if [ "$git_dir" == "" ] ;then
        echo -e "\033[0;31m $work_dir \033[0m";
    else
        echo -e "\033[0;32m $work_dir \033[0m";
    fi

}
alias cdad="cd ~/admin_yb1v1  "
alias cdcc="cd ~/cc_admin_yb1v1  "
alias cdcad="cd ~/admin_class"
alias cda='cd ~/work/aaron_server/webserver/'
alias cdaccount='cd ~/yb_account/'
alias cdwww='cd ~/work/aaron_server/ebai_main_page/'

alias a6="rm -f ~/admin_yb1v1 ;ln -s  ~/work/admin ~/admin_yb1v1; switch_ac_php_tags  ~/work/admin ~/admin_yb1v1 ;  cd ~/admin_yb1v1 "
alias ag="rm -f ~/admin_yb1v1 ;ln -s  ~/admin_yb1v1_git/   ~/admin_yb1v1; switch_ac_php_tags   ~/admin_yb1v1_git ~/admin_yb1v1 ;  cd ~/admin_yb1v1 "
function switch_ac_php_tags () {
    from=$1
    to=$2
    from_dir="tags${from//\//-}"
    to_dir="tags${to//\//-}"
    mkdir -p  ~/.ac-php/$from_dir
    rm -f  ~/.ac-php/$to_dir
    ln -s ~/.ac-php/$from_dir  ~/.ac-php/$to_dir

}

function get_work_dir() {
    old_pwd=`pwd`
    while  [  ! -f ./.env -a ! -f ./server.ts  ] ;do
        cd ../
        pwd=`pwd`
        if [ $pwd == "/" ];then
            break;
        fi
    done

    if [ -f ./.env  ]; then
        if [ -d  $1 ] ;then
            cd $1
        elif [ -d  "$3" ] ;then
            cd $3
        else
            echo "nofind $3"
            cd $old_pwd
        fi
    elif [ -f ./server.ts ]; then
        if [ -d  $2 ] ;then
            cd $2
        else
            echo "nofind $2"
            cd $old_pwd
        fi

    else
        echo "no in project"
        cd $old_pwd
    fi


}

export WORKDIR=$HOME/DB
alias cdserlog='cd $WORKDIR/ser/log'
alias cdsrc='cd ../src/ '
alias cdbin='cd ../bin/ '
alias cdetc='cd ../etc/ '
alias cdsql='cd ../sql/ '
alias cdtools='cd ../tools/ '
alias l='ls -allh'
alias l.='ls -d .* --color=tty'
alias ll='ls -lh --color=tty'
alias ls='ls --color=tty'
alias telnet="telnet -8 -e^e"
alias rm="rm -i"
alias df="df -h"
alias grep="grep --color=auto"


alias cdpro='cd $WORKDIR/proxy/src'
alias cdi='cd $WORKDIR/include'
alias cdcom='cd $WORKDIR/com/src'
alias cdcomlog='cd $WORKDIR/com/log'
alias cdprolog='cd $WORKDIR/proxy/log'
alias cdser='cd ~/server_others/dbserver/'
alias cdage='cd $WORKDIR/agentser/src'
alias cdtest='cd $WORKDIR/libsrc/cli*/ '
alias cdproc='cd $WORKDIR/procser/src/ '
alias clog='cat ../log/de*`date +%Y%m%d`* '
alias putsvn='cd  ~/DB && svn ci && cd -'
alias sub="ls -d */" #只显示文件夹
alias bk="cd -" #回到上一目录
alias cp="cp -i -rf "
alias rmlog="rm -f $WORKDIR/ser/log/* $WORKDIR/proxy/log/*  $WORKDIR/payser/log/* "


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
#set -o vi


export EDITOR="vim"



function lf ()
{
  find $PWD -maxdepth 1 -name $1
}

function comm_put_ser()
{
  user=$1
  ip_fix=$2
  port=$3
  passwd=$4
    echo   scp -2  -P $port $6 $user@$ip_fix.$5:~/
  sshpass -p"$passwd" scp -2 -o "StrictHostKeyChecking no"  -P $port $6 $user@$ip_fix.$5:~/
}

function comm_get_ser()
{
  user=$1
  ip_fix=$2
  port=$3
  passwd=$4

  echo  scp -2 -P $port  $user@$ip_fix.$5:~/$6 .
  sshpass -p"$passwd" scp -2  -o "StrictHostKeyChecking no"  -P $port  $user@$ip_fix.$5:~/$6 .
}
function comm_login_server ( )
{
  if [  ! "$EMACS" == "" ]; then
    #emacs shell
    echo ""
    echo ""
    echo ""
    echo "=============================================================================="
    echo "                       in emacs shell not use ssh !                           "
    echo "=============================================================================="
    echo ""
    echo ""
    echo ""
    #return
  fi
  user=$1
  ip_fix=$2
  port=$3
  passwd=$4
  sshpass -p"$passwd" ssh -2  -o "StrictHostKeyChecking no"  -p $port  $user@$ip_fix.$5

}

function alias_comm_cmd_ex()
{
    ip=$1
    last_ip=${ip/*./}
    pre_ip=$(echo $ip  | sed "s/\\.[0-9]*\$//")

    #pi 192.168.31 22     raspberry
    #alias_comm_cmd 3 "" jim 192.168.0 22   xcwen142857

    alias_comm_cmd $last_ip $2 ybai  $pre_ip  22  yb142857 

}

function alias_comm_cmd()
{
    flag=$2
    user=$3
    ip_fix=$4
    port=$5
    passwd=$6
  if [ "$7" == "true" ] ; then
    flag_str="$flag$1$user"
  else
    flag_str="$flag$1"
  fi
    eval "alias c$flag_str='sshpass -p\"$passwd\" ssh -2  -o \"StrictHostKeyChecking no\" -p$port -l\"$user\" $ip_fix.$1' "
    #eval "alias c$flag_str=' comm_login_server $user $ip_fix $port \"$passwd\" $1  ' "
    eval "alias put$flag_str=' comm_put_ser $user $ip_fix $port \"$passwd\" $1 ' "
    eval "alias get$flag_str=' comm_get_ser $user $ip_fix $port \"$passwd\" $1 ' "
}
#alias_comm_cmd 5 "" jim 192.168.0 22   xcwen142857
#alias_comm_cmd 3 "" jim 192.168.0 22   xcwen142857
alias_comm_cmd 77 "" ybai 115.28.241  22   yb142857



alias cdum="cd /var/www/su/uman"
function ptop(){
  `ps -ef | grep $*  | awk 'BEGIN{printf "top "}{printf "-p" $2  " " }'`
}

function get_date(){
    date +"%F %T" -d "1970-01-01 UTC $1 seconds"
}

function cpshare(){
  cp $* ~/share
}


alias py="python"
export LANG=zh_CN.UTF-8
export LC_CTYPE="zh_CN.UTF-8"
export GOPATH=$HOME/goprojects
#export GOROOT=$HOME/goprojects

export PATH=~/admin_yb1v1/vendor/bin:~/bin:.:$PATH:~/site-lisp/other_script/:/usr/local/go/bin:$GOPATH/bin:/usr/local/node/bin/

export ANDROID_HOME=~/Android/Sdk

export PATH="~/tt/ejabberd-17.08/bin:~/Android/Sdk/tools:~/Android/Sdk/platform-tools:${PATH}:~/.config/composer/vendor/bin"
#JAVA
#export ANDROID_NDK=/home/jim/android-ndk
#export JAVA_HOME=/home/jim/jdk1.6.0_45
#export JRE_HOME=/home/jim/jdk1.6.0_45/jre
#export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib
#export PATH=$JAVA_HOME/jre/bin/:$JAVA_HOME/bin/:$PATH
#
#export NDK_HOME=/home/jim/android-ndk-r9d

#export ANDROID_SDK_ROOT=/home/jim/android-sdk-linux
#export ANDROID_NDK_ROOT=/home/jim/android-ndk-r9d
#JAVA END

alias cdshare="cd ~/share"


alias halt="sudo shutdown -h now"
alias sc="gnome-screensaver-command -a"

#XMPP
alias_comm_cmd 116  "" pi 192.168.31 22     raspberry
alias_comm_cmd 206  "" pi 192.168.5 22     raspberry
alias_comm_cmd 105  "" pi 192.168.0 22     raspberry
alias_comm_cmd 75  "" pi 192.168.31 22     raspberry
alias_comm_cmd 8  "" pi 192.168.0 22     raspberry
alias_comm_cmd 6 "" jim  192.168.0 22     xcwen142857
alias_comm_cmd 5 "" jim  192.168.0 22     xcwen142857
alias_comm_cmd 172  "" pi 192.168.0 22     raspberry
#B8:27:EB:3F:C6:4F
#alias_comm_cmd 83 "q" ybai   120.27.51 56000  yb142857

#web02:
alias_comm_cmd 189 "q" ybai  118.190.65 56000  yb142857
#www:
alias_comm_cmd 193 "q" ybai 118.190.65 56000  yb142857
#db api
alias_comm_cmd 163 "q" ybai 121.42.183     22 yb142857

alias_comm_cmd 66 "q" ybai 114.215.82   56000  yb142857
alias_comm_cmd 38 "q" ybai 114.215.66 56000  yb142857
alias_comm_cmd 73 "q" ybai 115.28.89   22 yb142857
alias_comm_cmd 128 "q" ybai 114.215.40    22 yb142857
alias_comm_cmd 161 "q" ybai 114.215.98    22 yb142857
alias_comm_cmd 161 "Q" jim 118.190.115 22 xcwen142857
alias_comm_cmd 55 "q" ybai   118.190.142  22 yb142857
alias_comm_cmd 107 "q" ybai  118.190.142  22 yb142857
alias_comm_cmd 27 "q" ybai 118.190.164  22 yb142857
alias_comm_cmd 19 "q" ybai 118.190.167  22 yb142857

alias_comm_cmd 129 "q" ybai  118.190.32  22 yb142857
alias_comm_cmd 67 "q" ybai   118.190.32  22 yb142857






alias_comm_cmd 96 "q" ybai 118.190.113 22 yb142857
alias_comm_cmd 205 "q" ybai 118.190.135 22 yb142857
alias_comm_cmd 59 "q" ybai 121.42.186  22 yb142857


#HANG ZHOU
alias_comm_cmd 95  "h" ybai 121.43.230 22   yb142857
alias_comm_cmd 183  "h" ybai  120.26.58 22   yb142857
alias_comm_cmd 121  "l"  willshang 18.0.1  22 dengzhi123

alias_comm_cmd_ex  47.104.82.208   "v"
alias_comm_cmd_ex  47.104.81.193   "v"
alias_comm_cmd_ex 118.190.151.173  "v"
alias_comm_cmd_ex 120.27.9.154     "v"
alias_comm_cmd_ex 47.104.12.188    "v"
alias_comm_cmd_ex 47.104.16.121    "v"
alias_comm_cmd_ex  47.104.86.200   "v"
alias_comm_cmd_ex 47.104.86.240    "v"
alias_comm_cmd_ex 47.104.86.32     "v"
alias_comm_cmd_ex 47.104.89.186  "v"
alias_comm_cmd_ex 47.104.62.209  "q"


function do_vi() {
   cur_git_branch_name=$(git symbolic-ref --short -q HEAD 2>/dev/null)
   project_name=$(git config --get remote.origin.url  | awk -F[./] '{print $(NF-1)}')
   echo $project_name,$cur_git_branch_name

}

alias vi="emacsclient -n"
alias my="mysql -uroot -pta0mee"
alias my6="mysql -uroot -pta0mee -h192.168.0.6"
alias my_test="mysql -uyb_user -pyb142857 -h rm-m5e95vbq1a2b104ugfo.mysql.rds.aliyuncs.com "
#halt:

#alias composer="sudo docker run -i -t -v \$PWD:/srv ubermuda/composer"
