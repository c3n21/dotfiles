#!/bin/bash

echo "Running as $USER"

if pidof -x borg > /dev/null; then
	echo "Backup is already running"
	exit
fi

eval "$(ssh-agent -s)"
ssh-add /root/.ssh/autologin_fanaro

#export BORG_PASSPHRASE="$(cat $HOME/.borg-passphrase)"

REPO=backup@fanaro:/media/backup/borg/laptop
HOST=$(hostname)
DATE=$(date +%y-%m-%d)

borg create -v --stats $REPO::$HOST-$DATE / --exclude /dev/ --exclude /proc/ --exclude /sys/ --exclude /tmp/ --exclude /run/ --exclude /mnt/ --exclude /media/ --exclude /lost+found --exclude /shared_home/

borg prune -v --list $REPO --prefix $HOST- --keep-daily=7 --keep-weekly=4 --keep-monthly=6
#unset $BORG_PASSPHRASE
