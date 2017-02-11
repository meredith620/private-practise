sudo ifconfig wlan0 up
sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf
sudo iwconfig wlan0 channel auto
sudo ifconfig wlan0 192.168.0.36
sudo route add default gw 192.168.0.1

#sudo iwconfig wlan0 power on
