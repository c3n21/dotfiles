# Tmux instructions

tmux new -s [session name] <br/>
tmux ls                    <br/>
tmux attach-session -t [n] <br/>

Ctrl+b d                    //detach from tmux session<br/>
Ctrl+b c                    //create a new windows with shell assigning it the first available number from range 0...9<br/>
Ctrl+b w                    //list windows<br/>
Ctrl+b [n]                  //Switch to window n (by number )<br/>
Ctrl+b ,                    //Rename the current window<br/>
Ctrl+b %                    //Split current pane horizontally into two panes<br/>
Ctrl+b "                    //Split current pane vertically into two panes<br/>
Ctrl+b o                    //Go to the next pane<br/>
Ctrl+b ;                    //Toggle between the current and previous pane<br/>
Ctrl+b x                    //Close the current pane<br/>

# Dependencies
* sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"<br/>
* git clone git://github.com/zsh-users/zsh-completions.git<br/>
* git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-\~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions<br/>
* git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-\~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting<br/>


