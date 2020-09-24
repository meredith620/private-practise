#!/bin/bash
INPUT_DEVICE="'Master'"
if amixer sget $INPUT_DEVICE,0 | grep '\[off\]' ; then
    # amixer sset $INPUT_DEVICE,0 toggle
    amixer set 'Master',0 unmute
    amixer set 'Headphone',0 unmute
    amixer set 'Speaker',0 unmute
   # echo "0 blink" > /proc/acpi/ibm/led
else
    amixer sset $INPUT_DEVICE,0 toggle
   # echo "0 on" > /proc/acpi/ibm/led 
fi
