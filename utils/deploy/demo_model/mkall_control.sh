#!/bin/bash
cd conf

# ======== clean first =========
rm -rf start_all.sh
rm -rf stop_all.sh
rm -rf check_all.sh
rm -rf save_all.sh
rm -rf servers
rm -rf slaves
rm -rf slaves_cmd
rm -rf deploy_control.sh
# ==============================

cat *start_all >> start_all.sh
sort -u start_all.sh -o start_all.sh
chmod 755 start_all.sh

cat *stop_all >> stop_all.sh
sort -u stop_all.sh -o stop_all.sh
chmod 755 stop_all.sh

cat *check_all >> check_all.sh
sort -u check_all.sh -o check_all.sh
chmod 755 check_all.sh

cat *save_all >> save_all.sh
sort -u save_all.sh -o save_all.sh
chmod 755 save_all.sh

cat *server-list >> temp-servers
awk '$0&&!/slaveof/{print $1 "\t" $2 "\t" $3}' temp-servers > servers
awk '$0&&/slaveof/{print $1 "\t" $2 "\t" $3 "\t->" $4 "\t" $5}' temp-servers > slaves
awk '$0&&/slaveof/{print $3 " " $4 " " $5 }' temp-servers > slaves_cmd
sed -i -e 's/:/ /g' slaves_cmd
rm temp-servers

# ==deploy files generated above==
cat *scp_control_sh >> deploy_control.sh
sort -u deploy_control.sh -o deploy_control.sh
chmod 755 deploy_control.sh

