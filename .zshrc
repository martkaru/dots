# oh my zsh setup
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="karu"
plugins=(git rvm rake gem brew github rails)
source $ZSH/oh-my-zsh.sh

# aliases
alias gs='git status'
alias glg='git lg'
alias vu='vagrant up'
alias vh='vagrant halt'
alias vs='vagrant ssh'
alias l='ls -al'
alias ltr='ls -ltr'
alias lth='l -t|head'
alias lh='ls -Shl | less'
alias tf='tail -f -n 100'

# exports
export PATH=/Users/karu/.rvm/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/karu/Library/Haskell/bin
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export EDITOR=vim

# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
__rvm_project_rvmrc
rvm default

# utilities
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

