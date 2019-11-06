#!/bin/bash 


sudo systemctl stop NetworkManager 
sudo systemctl stop NetworkManager-dispatcher.service
sudo systemctl enable systemd-networkd.service
sudo systemctl enable systemd-resolved.service
sudo wpa_supplicant -i wlo1 -c /etc/wpa_supplicant/eduroam.conf -B
sudo dhcpcd wlo1
