#
# ~/.bashrc
#
[[ $- != *i* ]] && return [ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion use_color=true # Set colorful PS1 only on colorful terminals.  dircolors --print-database uses its own built-in database instead of using /etc/DIR_COLORS.  Try to use the external file first to take advantage of user additions.  Use internal bash globbing instead of external grep binary.  safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true


unset use_color safe_term match_lhs sh

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize
shopt -s extglob
shopt -s expand_aliases


#
# # ex - archive extractor
# # usage: ex <file>

#Different histories
# avoid duplicates..
#export HISTCONTROL=ignoredups:erasedups

# append history entries..
#shopt -s histappend

# After each command, save and reload history
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# enable color support of ls and also add handy aliases
 if [ -x /usr/bin/dircolors ]; then
     #test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)" alias ls='ls --color=auto' #bash: export: `--color=auto': not a valid identifier
     alias dir='dir --color=auto'
     alias vdir='vdir --color=auto'
 
     alias grep='grep --color=auto'
     alias fgrep='fgrep --color=auto'
     alias egrep='egrep --color=auto'
 fi

#if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#    tmux attach -t default || tmux new -s default
#fi

set -o vi

eval "$(_TMUXP_COMPLETE=source tmuxp)"
