append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}
ANDROID_SDK_ROOT='/opt/android-sdk'
append_path "$HOME/.local/bin"
append_path "$HOME/node_modules/.bin"
append_path "$HOME/.cargo/bin"
append_path "$PATH:$ANDROID_HOME/emulator"
append_path "$PATH:$ANDROID_HOME/platform-tools/"
append_path "$PATH:$ANDROID_HOME/tools/bin/"
append_path "$PATH:$ANDROID_HOME/tools/"
PATH="$ANDROID_HOME/emulator:$PATH"

if [[ -d "$HOME/.local/share/junest" ]]; then
    append_path "$HOME/.local/share/junest/bin"
fi

if [ "$XDG_SESSION_TYPE" == "wayland" ] ; then
    export MOZ_ENABLE_WAYLAND=1
fi

export PATH
export EDITOR="nvim"
export DIFFPROG="nvim -d"
export AURDEST="$HOME/Downloads/aur"
export AURSEEN="$HOME/Downloads/aur"
export MANPAGER="nvim +Man!"

export JAR="/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar"
export GRADLE_HOME="$HOME/gradle"
export JAVA_HOME="/usr/lib/jvm/default"
export JDTLS_CONFIG="$HOME/.local/share/java/jdtls/config_linux"
export WORKSPACE="$HOME/Documents/workspace"
unset -f append_path

alias luamake=/home/nezuko/Downloads/github/lua-language-server/3rd/luamake/luamake
