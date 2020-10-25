#Load all configurations
for i in "$HOME"/.config/bashrc.conf.d/*; do
        source "$i"
done
