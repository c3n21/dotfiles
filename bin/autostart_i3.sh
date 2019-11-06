    #/bin/bash
fcitx &
#i3-msg "exec --no-startup-id $HOME/bin/polybar.sh"
i3-msg "exec feh --no-startup-id --bg-scale ~/Pictures/Wallpapers/Misc/liuxing.jpg"

#i3-msg "exec --no-startup-id /usr/lib/geoclue-2.0/demos/agent exec redshift-gtk"

# set desktop background with custom effect
#i3-msg "exec --no-startup-id betterlockscreen -w dim"

# Alternative (set last used background)
#i3-msg "exec --no-startup-id source ~/.fehbg"

i3-msg "exec --no-startup-id thunderbird"
#i3-msg "exec_always --no-startup-id numlockx on"
i3-msg "exec --no-startup-id redshift"
numlockx on
