#
# ~/.bash_profile
#

export PATH="$HOME/bin:$PATH"
export EDITOR=nvim
export GOPATH="$HOME/go"

[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.profile ]] && . ~/.profile

#using gnome-keyring for ssh keys
#if [ -n "$DESKTOP_SESSION" ];then
#    eval $(gnome-keyring-daemon --start)
#    export SSH_AUTH_SOCK
#fi
