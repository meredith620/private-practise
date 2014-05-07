#! /bin/bash

echo "[in sleep] $@" >> /var/log/custom_acpid

# sync filesystem and clock
sync
# acpi_listen
# go to sleep
sleep 5 && echo -n "mem" > /sys/power/state
