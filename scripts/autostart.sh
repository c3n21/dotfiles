#/bin/bash

echo "[autostart.sh] START"

if [[ "$DESKTOP_SESSION" == 'plasma' ]];
then
    echo "[autostart.sh] DETECTED plasmashell environment!"
    latte-dock &
fi

echo "[autostart.sh] END"
