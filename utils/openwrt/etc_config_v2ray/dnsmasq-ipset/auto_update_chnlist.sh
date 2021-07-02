set -e
CUR_DATE=$(date "+%Y-%m-%d_%H_%M_%S")
CHINA_IPS=/etc/config/hsv2ray/dnsmasq-ipset/china_list_${CUR_DATE}.txt

rm -f /etc/config/hsv2ray/dnsmasq-ipset/china_list*.txt
wget https://cdn.jsdelivr.net/gh/QiuSimons/Chnroute@master/dist/chnroute/chnroute.txt -O ${CHINA_IPS}
ln -s $CHINA_IPS /etc/config/hsv2ray/dnsmasq-ipset/china_list.txt

# ipset -X china
# ipset -N china nethash
# ipset -! flush china
# ipset -! -R <<-EOF || exit 1
# 	create china hash:net
# 	$(cat ${CHINA_IPS} | sed -e "s/^/add china /")
# EOF

