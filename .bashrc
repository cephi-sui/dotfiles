#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ssh='TERM=xterm-256color ssh'
alias proton='WINEDLLOVERRIDES=winhttp=n,b proton'

PS1='[\u@\h \W]\$ '

export EDITOR=vim
