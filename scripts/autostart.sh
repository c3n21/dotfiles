#/bin/bash

echo "[autostart.sh] START"

if [[ "$DESKTOP_SESSION" == 'plasma' ]];
then
    echo "[autostart.sh] DETECTED plasmashell environment!"
    latte-dock &
fi

if [[ "$DESKTOP_SESSION" == 'xfce' ]];
then
    echo "[autostart.sh] DETECTED xfce environment!"
    conky -d
fi

echo "[autostart.sh] END"
