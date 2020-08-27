#! /bin/bash
set -e
# sudo ifconfig wlp3s0 up
# sudo wpa_supplicant -Dnl80211 -B -i wlp3s0 -c /etc/wpa_supplicant/home.conf
# sudo iwconfig wlp3s0 channel auto
# sudo ifconfig wlp3s0 192.168.1.35
# sudo route add default gw 192.168.1.1

#sudo iwconfig wlp3s0 power on

#ifconfig wlp3s0 up
wpa_supplicant -Dnl80211 -B -i wlp3s0 -c /etc/wpa_supplicant/wpa_supplicant.conf
ifconfig wlp3s0 192.168.1.35 broadcast 192.168.1.255 netmask 255.255.255.0
route add default gw 192.168.1.1
# dhcpcd -A wlp3s0
