#!/bin/sh
logger "[ACPI] Fn+F4 pressed, start Slimlock for current user and suspend to ram"
XUSER=$(ps aux | grep xinit | awk '{print $1}' | head -n1)
sudo -u $XUSER /usr/bin/slimlock&
echo -n mem >/sys/power/state
