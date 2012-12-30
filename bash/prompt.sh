function pwdtail () {
    if [ "$PWD" = "$HOME" ]; then
	echo '~'
    else
	echo "${PWD/#$HOME/~}"|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
    fi
}

function prompt_command () {
    if [ $? -eq 0 ]; then
	local TITLE="${PWD/#$HOME/~}"
	local TILE_COLOR=$RESET
    else
	local TITLE="${PWD/#$HOME/~}"
	local TITLE_COLOR=$RED
    fi
    local SYM=" `echo -e "±"`"
    local GREEN="\[\033[0;32m\]"
    local RED="\[\033[0;31m\]"
    local YELLOW="\[\033[0;33m\]"
    local BLUE="\[\033[0;35m\]"
    local COL="\[\033[0;36m\]"
    local RESET="\[\033[m\]"
    local CURRENT_DIR=`pwdtail`
    local GIT_STATUS="`git status -unormal 2>&1`"
    if ! [[ "$GIT_STATUS" =~ Not\ a\ git\ repo ]]; then
	if [[ "$GIT_STATUS" =~ nothing\ to\ commit ]]; then
	    local GITSTATE=$GREEN
	elif [[ "$GIT_STATUS" = nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
	    local GITSTATE=$RED 
	else
	    local GITSTATE=$YELLOW
	fi
	
	if [[ "$GIT_STATUS" =~ On\ branch\ ([^[:space:]]+) ]]; then
	    local BRANCH=" [${BASH_REMATCH[1]}]"
	    test "$BRANCH" != ' [master]' || BRANCH=''
	else
	    local BRANCH=" [`git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD`]"
	fi
    else
	local GITSTATE=$COL2
    fi
    
    export PS1="$COL$CURRENT_DIR$RESET${YELLOW}$BRANCH${RESET} $GITSTATE\$${RESET} "
}


export PROMPT_COMMAND=prompt_command


