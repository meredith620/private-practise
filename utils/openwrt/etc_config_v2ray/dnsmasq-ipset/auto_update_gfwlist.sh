set -e

GFWLIST2DNSMASQ_SH=/etc/config/v2ray/gfwlist2dnsmasq.sh
CUR_DATE=$(date "+%Y-%m-%d_%H_%M_%S")

test -e ${GFWLIST2DNSMASQ_SH} || wget https://raw.githubusercontent.com/cokebar/gfwlist2dnsmasq/master/gfwlist2dnsmasq.sh -O ${GFWLIST2DNSMASQ_SH}

sh ${GFWLIST2DNSMASQ_SH} -p 5353 -s gfwlist -o /tmp/dnsmasq_gfwlist_ipset_${CUR_DATE}.conf
rm -rf /etc/dnsmasq.d/dnsmasq_gfwlist_ipset_*
cp /tmp/dnsmasq_gfwlist_ipset_${CUR_DATE}.conf /etc/dnsmasq.d/
/etc/init.d/dnsmasq restart
