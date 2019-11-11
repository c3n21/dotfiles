Issues:
    >Audio is still playing after I muted (the icon on bumblebee-status is updated properly)

Dependancy Arch Linux:
    >nodejs
    >python 3 (pip install neovim)

Tweaking:
    >ttf-inconsolata if you want to view bumblebee-status properly

Tmux instructions

tmux new -s [session name]
tmux ls                     //list running sessions
tmux attach-session -t [n]

Ctrl+b d                    //detach from tmux session
Ctrl+b c                    //create a new windows with shell assigning it the first available number from range 0...9
Ctrl+b w                    //list windows
Ctrl+b [n]                  //Switch to window n (by number )
Ctrl+b ,                    //Rename the current window
Ctrl+b %                    //Split current pane horizontally into two panes
Ctrl+b "                    //Split current pane vertically into two panes
Ctrl+b o                    //Go to the next pane
Ctrl+b ;                    //Toggle between the current and previous pane
Ctrl+b x                    //Close the current pane
