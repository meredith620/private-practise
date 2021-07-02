#! /bin/sh

usage() {
    echo "$0 [OPTIONS]
            -m mode [gfwlist | chnlist | v2raychn | v2rayall]
         "
    exit 1
}

change_config() {
    case "$MODE" in
        gfwlist)
            echo "use dnsmasq-ipset:gfwlist"
            rm -f config.v2ray.json; ln -s dnsmasq-ipset/redirect.config.v2ray.json config.v2ray.json
            rm -f post_iptables.sh; ln -s dnsmasq-ipset/gfwlist.iptables.sh post_iptables.sh
            ls -l
            ;;
        chnlist)
            echo "use dnsmasq-ipset:chinalist"            
            rm -f config.v2ray.json; ln -s dnsmasq-ipset/redirect.config.v2ray.json config.v2ray.json
            rm -f post_iptables.sh; ln -s dnsmasq-ipset/chinalist.iptables.sh post_iptables.sh
            ls -l
            ;;
        v2raychn)
            echo "use tproxy-gfwlist-v2ray:chinalist"
            rm -f config.v2ray.json; ln -s tproxy-gfwlist-v2ray/tproxy.config.v2ray.json config.v2ray.json
            rm -f post_iptables.sh; ln -s tproxy-gfwlist-v2ray/tproxy.iptables.sh post_iptables.sh
            ls -l
            ;;
        v2rayall)
            echo "use redirect-full-through-v2ray:all-traffic"
            rm -f config.v2ray.json; ln -s redirect-full-through-v2ray/redirect.config.v2ray.json config.v2ray.json
            rm -f post_iptables.sh; ln -s redirect-full-through-v2ray/redirect.iptables.sh post_iptables.sh
            ls -l
            ;;
        *)
            usage
            ;;
    esac
}

main() {
    while getopts "m:h" opt; do
        case "$opt" in
            m)
                MODE="${OPTARG}"
                ;;
            h)
                usage
                ;;
            *)
                usage
                ;;
        esac
    done

    change_config
}

# ===== main =====
if [[ "${BASH_SOURCE[0]}" == "$0" ]];then
    main "$@"
fi

