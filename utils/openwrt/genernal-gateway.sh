#echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
echo 1 >/proc/sys/net/ipv4/ip_forward

iptables -I FORWARD -s 10.0.0.0/8 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -j MASQUERADE
# 不限制源ip (不限制内网网段)
#iptables -I FORWARD -j ACCEPT
#iptables -t nat -A POSTROUTING -j MASQUERADE

# iptables -P INPUT ACCEPT 
# iptables -P FORWARD ACCEPT
# iptables -P OUTPUT ACCEPT
