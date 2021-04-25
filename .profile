append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}
append_path "$HOME/.local/bin"
append_path "$HOME/node_modules/.bin"
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


export JAR="/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
export GRADLE_HOME="$HOME/gradle"
export JAVA_HOME="/usr/lib/jvm/default"
export JDTLS_CONFIG="$HOME/.local/share/java/jdtls/config_linux"
export WORKSPACE="$HOME/Documents/workspace"

unset -f append_path

alias luamake=/home/nezuko/Downloads/github/lua-language-server/3rd/luamake/luamake
