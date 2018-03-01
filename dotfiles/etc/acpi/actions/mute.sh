#!/bin/bash
INPUT_DEVICE="'Master'"
if amixer sget $INPUT_DEVICE,0 | grep '\[on\]' ; then
    amixer sset $INPUT_DEVICE,0 toggle
#    echo "0 blink" > /proc/acpi/ibm/led
else
    amixer sset $INPUT_DEVICE,0 toggle
#    echo "0 on" > /proc/acpi/ibm/led 
fi
