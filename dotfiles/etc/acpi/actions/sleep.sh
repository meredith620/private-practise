#! /bin/bash

echo "[in sleep] '$@'" >> /var/log/custom_acpid
# if launched through a lid event and lid is open, do nothing
echo "$1" | grep "button/lid" && grep -q open /proc/acpi/button/lid/LID/state && exit 0

# sync filesystem and clock
sync
# acpi_listen
# go to sleep
sleep 5 && echo -n "mem" > /sys/power/state
