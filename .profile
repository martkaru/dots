export LANG=en_US.UTF-8

export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=$PATH:/opt/local/bin
export PATH="/opt/local/bin:/opt/local/lib/postgresql82/bin/:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$PATH" 
export LANG=en_US.UTF-8
export EDITOR=mvim
export PATH=${PATH}:/Application/android-sdk-mac_x86/tools
export PATH=${PATH}:/Users/martkaru/Library/Haskell/bin
if [[ -s /Users/martkaru/.rvm/scripts/rvm ]] ; then source /Users/martkaru/.rvm/scripts/rvm ; fi


# general shortcuts
alias mv='mv -i'
alias rm='rm -i'
alias cdd='cd ..'
alias cddd='cd ../..'
alias cdddd='cd ../../..'

# ls
alias l='ls -al'
alias ltr='ls -ltr'
alias lth='l -t|head'
alias lh='ls -Shl | less'
alias tf='tail -f -n 100'

# editing shortcuts
alias m='mate'

# grep for a process
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# display battery info on your Mac
# see http://blog.justingreer.com/post/45839440/a-tale-of-two-batteries
alias battery='ioreg -w0 -l | grep Capacity | cut -d " " -f 17-50'

# git
alias g='git '
alias gst='git status'
alias gs='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff | mate'
alias gdh='git diff HEAD | mate'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias gcb='git checkout -b'
alias gcap='git commit -v -a && git push'
alias gpp='git pull; git push'

# RAILS
alias r='rails'

# OS X indexing
alias disable_indexing='sudo mdutil -a -i off'
alias enable_indexing='sudo mdutil -a -i on'

# opens man in preview
pman () {
    man -t "${1}" | open -f -a /Applications/Preview.app
}
# history
alias h='history | grep'

function heftiest {
  for file in $(find app/$1/**/*.rb -type f); do wc -l $file ; done  | sort -r | head
}

###############################################################################
# IDENTIFICATION OF LOCAL HOST: CHANGE TO YOUR COMPUTER NAME
###############################################################################

PRIMARYHOST="localhost"

###############################################################################
# PROMPT
###############################################################################

###############################################################################
# Terminal Title

set_terminal_title() {
    if [[ -z $@ ]]
    then
        TERMINAL_TITLE=$PWD
    else
        TERMINAL_TITLE=$@
    fi
}
alias stt='set_terminal_title'
STANDARD_PROMPT_COMMAND='history -a ; echo -ne "\033]0;${TERMINAL_TITLE}\007"'
PROMPT_COMMAND=$STANDARD_PROMPT_COMMAND

###############################################################################
# Parses Git info for prompt

function _set_git_envar_info {
    GIT_BRANCH=""
    GIT_HEAD=""
    GIT_STATE=""
    GIT_LEADER=""
    GIT_ROOT=""
    if [[ $(which git 2> /dev/null) ]]
    then
        local STATUS
        STATUS=$(git status 2>/dev/null)
        if [[ -z $STATUS ]]
        then
            return
        fi
        GIT_LEADER=":"
        GIT_BRANCH="$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
        GIT_HEAD=":$(git show --quiet --pretty=format:%h 2> /dev/null)"
        GIT_ROOT=./$(git rev-parse --show-cdup)
        if [[ "$STATUS" == *'working directory clean'* ]]
        then
            GIT_STATE=""
        else
            GIT_HEAD=$GIT_HEAD":"
            GIT_STATE=""
            if [[ "$STATUS" == *'Changes to be committed:'* ]]
            then
                GIT_STATE=$GIT_STATE'+I' # Index has files staged for commit
            fi
            if [[ "$STATUS" == *'Changed but not updated:'* ]]
            then
                GIT_STATE=$GIT_STATE"+M" # Working tree has files modified but unstaged
            fi
            if [[ "$STATUS" == *'Untracked files:'* ]]
            then
                GIT_STATE=$GIT_STATE'+U' # Working tree has untracked files
            fi
            GIT_STATE=$GIT_STATE''
        fi
    fi
}

###############################################################################
# Composes prompt.
function setps1 {

    # Help message.
    local USAGE="Usage: setps1 [none] [screen=<0|1>] [user=<0|1>] [dir=<0|1|2>] [git=<0|1>] [wrap=<0|1>] [which-python=<0|1>]"

    if [[ (-z $@) || ($@ == "*-h*") || ($@ == "*--h*") ]]
    then
        echo $USAGE
        return
    fi

    # Prompt colors.
    local CLEAR="\[\033[0m\]"
    local STY_COLOR='\[\033[1;37;41m\]'
    local PROMPT_COLOR='\[\033[1;94m\]'
    local USER_HOST_COLOR=$CLEAR'\[\033[0;36m\]'
    #local USER_HOST_COLOR='\[\033[1;33m\]'
    local PROMPT_DIR_COLOR='\[\033[1;94m\]'
    local GIT_LEADER_COLOR='\[\033[1;30m\]'
    local GIT_BRANCH_COLOR=$CLEAR'\[\033[1;32m\]\[\033[4;31m\]'
    #local GIT_BRANCH_COLOR=$CLEAR'\[\033[1;90m\]\[\033[4;90m\]'
    local GIT_HEAD_COLOR=$CLEAR'\[\033[1;32m\]'
    local GIT_STATE_COLOR=$CLEAR'\[\033[1;31m\]'

    # Hostname-based colors in prompt.
    #if [[ $HOSTNAME != $PRIMARYHOST ]]
    #then
        #USER_HOST_COLOR=$REMOTE_USER_HOST_COLOR
    #fi

    # Start with empty prompt.
    local PROMPTSTR=""

    # Set screen session id.
    if [[ $@ == *screen=1* ]]
    then
        ## Decorate prompt with indication of screen session ##
        if [[ -z "$STY" ]] # if screen session variable is not defined
        then
            local SCRTAG=""
        else
            local SCRTAG="$STY_COLOR(STY ${STY%%.*})$CLEAR" # get screen session number
        fi
    fi

    # Set user@host.
    if [[ $@ == *user=1* ]]
    then
         PROMPTSTR=$PROMPTSTR"$USER_HOST_COLOR\\u@\\h$CLEAR"
    fi

    # Set directory.
    if [[ -n $PROMPTSTR && ($@ == *dir=1* || $@ == *dir=2*) ]]
    then
            PROMPTSTR=$PROMPTSTR"$PROMPT_COLOR:"
    fi

    if [[ $@ == *dir=1* ]]
    then
        PROMPTSTR=$PROMPTSTR"$PROMPT_DIR_COLOR\W$CLEAR"
    elif [[ $@ == *dir=2* ]]
    then
        PROMPTSTR=$PROMPTSTR"$PROMPT_DIR_COLOR\$(pwd -P)$CLEAR"
    fi

#     if [[ $@ == *dir=1* ]]
#     then
#         PROMPTSTR=$PROMPTSTR"$PROMPT_DIR_COLOR\W$CLEAR"
#     elif [[ $@ == *dir=2* ]]
#     then
#         PROMPTSTR=$PROMPTSTR"$PROMPT_DIR_COLOR\w$CLEAR"
#     fi
#
    # Set git.
    if [[ $@ == *git=1* ]]
    then
        PROMPT_COMMAND="$STANDARD_PROMPT_COMMAND && _set_git_envar_info"
        PROMPTSTR=$PROMPTSTR"$BG_COLOR$GIT_LEADER_COLOR\$GIT_LEADER$GIT_BRANCH_COLOR"
        PROMPTSTR=$PROMPTSTR"\$GIT_BRANCH$GIT_HEAD_COLOR\$GIT_HEAD$GIT_STATE_COLOR\$GIT_STATE$CLEAR"
    else
        PROMPT_COMMAND=$STANDARD_PROMPT_COMMAND
    fi

    # Set wrap.
    if [[ $@ == *wrap=1* ]]
    then
        local WRAP="$CLEAR\n"
    else
        local WRAP=""
    fi

    # Set wrap.
    if [[ $@ == *which-python=1* ]]
    then
        local WHICHPYTHON="$CLEAR\n(python is '\$(which python)')$CLEAR\n"
    else
        local WHICHPYTHON=""
    fi

    # Finalize.
    if [[ -z $PROMPTSTR || $@ == none ]]
    then
        PROMPTSTR="\$ "
    else
        PROMPTSTR="$TITLEBAR\n$SCRTAG${PROMPT_COLOR}[$CLEAR$PROMPTSTR$PROMPT_COLOR]$WRAP$WHICHPYTHON$PROMPT_COLOR\$$CLEAR "
    fi

    # Set.
    PS1=$PROMPTSTR
    PS2='> '
    PS4='+ '
}

alias setps1-long='setps1 screen=1 user=1 dir=2 git=1 wrap=1'
alias setps1-short='setps1 screen=1 user=1 dir=1 git=1 wrap=0'
alias setps1-default='setps1-short'
alias setps1-plain='setps1 screen=0 user=0 dir=0 git=0 wrap=0'
alias setps1-nogit='setps1 screen=0 user=1 dir=1 git=0 wrap=0'
alias setps1-local-long='setps1 screen=1 user=0 dir=2 git=1 wrap=1'
alias setps1-local-short='setps1 screen=0 user=0 dir=1 git=1 wrap=0'
alias setps1-local='setps1-local-short'
alias setps1-dev-short='setps1 screen=0 user=0 dir=1 git=1 wrap=0 which-python=1'
alias setps1-dev-long='setps1 screen=0 user=1 dir=2 git=1 wrap=0 which-python=1'
alias setps1-dev-remote='setps1 screen=0 user=1 dir=1 git=1 wrap=0 which-python=1'
if [[ "$HOSTNAME" = "$PRIMARYHOST" ]]
then
    setps1 screen=0 user=0 dir=1 git=1 wrap=0 which-python=0
else
    setps1 screen=1 user=1 dir=1 git=1 wrap=0 which-python=0
fi



[[ -s "/Users/martkaru/.rvm/scripts/rvm" ]] && source "/Users/martkaru/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
