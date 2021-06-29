# v2ray
wget -O kuoruan-public.key http://openwrt.kuoruan.net/packages/public.key
opkg-key add kuoruan-public.key
echo "src/gz kuoruan_packages http://openwrt.kuoruan.net/packages/releases/$(. /etc/openwrt_release ; echo $DISTRIB_ARCH)" >> /etc/opkg/customfeeds.conf
opkg update
opkg install v2ray-core 

ln -s /etc/config/v2ray/v2ray.service /etc/init.d/v2ray

# dnsmasq-full & ipset
opkg remove dnsmasq && opkg install dnsmasq-full
## install ipset
opkg install ip-full ipset iptables-mod-tproxy iptables-mod-nat-extra libpthread coreutils-base64 ca-bundle curl libustream-mbedtls ca-certificates
## enable TCP Fast Open
echo "net.ipv4.tcp_fastopen = 3" > /etc/sysctl.conf
sysctl -p
## dnsmasq
echo "conf-dir=/etc/dnsmasq.d" >> /etc/dnsmasq.conf
mkdir -p /etc/dnsmasq.d
wget https://cokebar.github.io/gfwlist2dnsmasq/dnsmasq_gfwlist_ipset.conf -O /etc/dnsmasq.d/dnsmasq_gfwlist_ipset.conf
