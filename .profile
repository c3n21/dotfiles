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
append_path "$HOME/.cargo/bin"

if [[ -x "/usr/sbin/bob" ]]; then
    append_path "$HOME/.local/share/neovim/bin"
fi

if [[ "$ANDROID_HOME" != "" ]]; then # https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
    ANDROID_SDK_ROOT='/opt/android-sdk'
    append_path "$ANDROID_HOME/emulator"
    append_path "$ANDROID_HOME/platform-tools/"
    append_path "$ANDROID_HOME/tools/bin/"
    append_path "$ANDROID_HOME/tools/"
    append_path "$ANDROID_HOME/emulator"
fi


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

export JAR="/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar"
export GRADLE_HOME="$HOME/gradle"
export JAVA_HOME="/usr/lib/jvm/default"
export JDTLS_CONFIG="$HOME/.local/share/java/jdtls/config_linux"
export WORKSPACE="$HOME/Documents/workspace"

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

unset -f append_path
