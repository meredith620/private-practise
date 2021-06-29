* https://swsmile.info/post/shwdowsocks-openwrt-dnsmasq-bypass-gfw/
* https://github.com/kuoruan/openwrt-v2ray 参考reademe中添加源,opkg安装v2ray
* https://github.com/felix-fly/v2ray-openwrt 参考readme中v2ray.service写法

# v2ray
```shell
wget -O kuoruan-public.key http://openwrt.kuoruan.net/packages/public.key
opkg-key add kuoruan-public.key
echo "src/gz kuoruan_packages http://openwrt.kuoruan.net/packages/releases/$(. /etc/openwrt_release ; echo $DISTRIB_ARCH)" >> /etc/opkg/customfeeds.conf
opkg update
opkg install v2ray-core 
ln -s /etc/config/v2ray/v2ray.service /etc/init.d/v2ray
```

# dnsmasq-full & ipset
```
opkg remove dnsmasq && opkg install dnsmasq-full
```
## install ipset
```
opkg install ip-full ipset iptables-mod-tproxy iptables-mod-nat-extra libpthread coreutils-base64 ca-bundle curl libustream-mbedtls ca-certificates
```

## dnsmasq
```
opkg install libustream-mbedtls coreutils-base64
opkg install ca-certificates ca-bundle
echo "conf-dir=/etc/dnsmasq.d" >> /etc/dnsmasq.conf
mkdir -p /etc/dnsmasq.d
wget https://cokebar.github.io/gfwlist2dnsmasq/dnsmasq_gfwlist_ipset.conf -O /etc/dnsmasq.d/dnsmasq_gfwlist_ipset.conf
```


## luci
```lua
# require "luci.sys"
# require "luci.model.uci"
# uci = luci.model.uci.cursor()
# print(uci:get_first("shadowsocksr", "global", "gfwlist_url"))
# print(uci:get_first("shadowsocksr", "global", "chnroute_url"))
# print(uci:get_first("shadowsocksr", "global", "adblock_url"))
# print(uci:get_first("shadowsocksr", "global", "nfip_url"))
```
### 获取的下载地址
```
### gfwlist
https://ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt
### chinalist
https://cdn.jsdelivr.net/gh/QiuSimons/Chnroute@master/dist/chnroute/chnroute.txt
### adblock url
https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/adblock-for-dnsmasq.conf
### netflix ip
https://ghproxy.com/https://raw.githubusercontent.com/QiuSimons/Netflix_IP/master/NF_only.txt
```
