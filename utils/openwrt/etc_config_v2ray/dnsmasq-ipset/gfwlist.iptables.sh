## set gfwlist
# ipset -X gfwlist
# ipset -N gfwlist iphash
# iptables -t nat -A PREROUTING -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 12345  # 12345 端口（即 V2Ray）
# iptables -t nat -A OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 12345
# iptables -t nat -A PREROUTING -p udp --dport 443 -j REDIRECT --to-ports 12345
# iptables -t nat -A OUTPUT -p udp --dport 443 -j REDIRECT --to-ports 12345

# V2RAY
ipset -X gfwlist
ipset -N gfwlist iphash
iptables -t nat -N V2RAY
iptables -t nat -A V2RAY -d 0.0.0.0/8 -j RETURN
iptables -t nat -A V2RAY -d 10.0.0.0/8 -j RETURN
iptables -t nat -A V2RAY -d 127.0.0.0/8 -j RETURN
iptables -t nat -A V2RAY -d 169.254.0.0/16 -j RETURN
iptables -t nat -A V2RAY -d 172.16.0.0/12 -j RETURN
iptables -t nat -A V2RAY -d 192.168.0.0/16 -j RETURN
iptables -t nat -A V2RAY -d 224.0.0.0/4 -j RETURN
iptables -t nat -A V2RAY -d 240.0.0.0/4 -j RETURN
iptables -t nat -A V2RAY -d 255.255.255.255/32 -j RETURN
iptables -t nat -A V2RAY -p tcp -j RETURN -m mark --mark 0xff # 直连 SO_MARK 为 0xff 的流量(0xff 是 16 进制数，数值上等同与上面配置的 255)，此规则目的是避免代理本机(网关)流量出现回环问题
iptables -t nat -A V2RAY -p tcp -j REDIRECT --to-ports 12345

iptables -t nat -A OUTPUT -p tcp -m set --match-set gfwlist dst -j V2RAY # 代理网关本机
iptables -t nat -A PREROUTING -p tcp -m set --match-set gfwlist dst -j V2RAY  # 代理局域网设备 12345 端口（即 V2Ray）

# 通用网关服务
# iptables -I FORWARD -j ACCEPT
# iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -I FORWARD -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# iptables -I FORWARD -s 10.0.0.0/8 -j ACCEPT
# iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -j MASQUERADE

### eth1 内网端口, eth0 外网端口
# iptables -A FORWARD -i eth1 -j ACCEPT #允许LAN内转发
# iptables -A FORWARD -o eth1 -j ACCEPT
# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE #允许内部 IP 地址的 LAN 节点和外部的公共网络通信

## disable gfwlist
# service firewall stop
# ipset destroy gfwlist
# service firewall start
