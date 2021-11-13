# Install oh-my-fish
echo -e "Installing oh-my-fish...\n"

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > install
fish install --path=~/.local/share/omf --config=~/.config/omf
rm install
