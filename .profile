append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}
append_path "$HOME/.local/bin"
#append_path "$HOME/.local/share/gem/ruby/2.7.0/bin"
export PATH
export EDITOR=nvim
#export BROWSER=firefox
#export TERM=alacritty
#export MAIL=thunderbird
#export GTK2_RC_FILES="$HOME/.gtkrc-2.0" 
export DIFFPROG="nvim -d"
export AURDEST="$HOME/Downloads/aur"
export AURSEEN="$HOME/Downloads/aur"
export MANPAGER="nvim +Man!"

unset -f append_path
