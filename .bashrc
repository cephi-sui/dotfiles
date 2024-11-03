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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/cephi/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/cephi/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/cephi/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/cephi/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

