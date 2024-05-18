#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ssh='TERM=xterm-256color ssh'
alias hide='nmcli c up us-nyc-wg-604 && sudo tailscale down'
alias unhide='nmcli c down us-nyc-wg-604 && sudo tailscale up'
PS1='[\u@\h \W]\$ '

export EDITOR=vim

neofetch --disable WM
