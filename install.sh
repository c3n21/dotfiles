#!/bin/sh

echo -e "[oh-my-fish] Installing ...\n"
if [[ ! -d "$HOME/.local/share/omf" ]];
then
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > install
    fish install --path=~/.local/share/omf --config=~/.config/omf
    rm install
fi
echo -e "[oh-my-fish] Done...\n"
