## 安装依赖
```shell
opkg update
opkg install curl
opkg install ip-full ipset iptables-mod-tproxy iptables-mod-nat-extra libpthread
opkg install coreutils-base64 ca-bundle libustream-mbedtls ca-certificates
```

### 安装 dnsmasq-full
https://swsmile.info/post/shwdowsocks-openwrt-dnsmasq-bypass-gfw/
```shell
opkg remove dnsmasq && opkg install dnsmasq-full
echo "conf-dir=/etc/dnsmasq.d" >> /etc/dnsmasq.conf
mkdir -p /etc/dnsmasq.d
wget https://cokebar.github.io/gfwlist2dnsmasq/dnsmasq_gfwlist_ipset.conf -O /etc/dnsmasq.d/dnsmasq_gfwlist_ipset.conf
```

## 配置服务
1. 将 v2ray 目录 copy 到 openwrt 系统
```shell
scp -r etc_config_v2ray OPENWRT:/etc/config/v2ray
```

2. 选择一种模式,建立对应软连接
etc_config_v2ray/{config.v2ray.json, post_iptables.sh} 两个软连接是 v2ray.service 用到的配置文件和iptables设置的脚本文件
```shell
# dnsmasq gfw list 模式
config.v2ray.json -> dnsmasq-ipset/redirect.config.v2ray.json
post_iptables.sh -> dnsmasq-ipset/gfwlist.iptables.sh

# dnsmasq china list 模式
config.v2ray.json -> dnsmasq-ipset/redirect.config.v2ray.json
post_iptables.sh -> dnsmasq-ipset/chinalist.iptables.sh

# v2ray china list 模式
config.v2ray.json -> tproxy-gfwlist-v2ray/tproxy.config.v2ray.json
post_iptables.sh -> tproxy-gfwlist-v2ray/tproxy.iptables.sh

# 不分流, 所有流量都通过 v2ray 国外代理模式
config.v2ray.json -> redirect-full-through-v2ray/redirect.config.v2ray.json
post_iptables.sh -> redirect-full-through-v2ray/redirect.iptables.sh

```


3. 更新 dnsmasq 配置
```
## 更新 dnsmasq gfwlist (并且最好设置 crontab 每日运行)
sh dnsmasq-ipset/auto_update_gfwlist.sh

## 更新 dnsmasq chinalist (可以间隔长周期更新)
sh dnsmasq-ipset/auto_update_chnlist.sh
```
