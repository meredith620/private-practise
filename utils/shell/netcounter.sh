#! /bin/bash

CATNET="cat /proc/net/dev"
print_bps()
{
    KEY=$1
    PRE_ARY=($($CATNET | grep $KEY | sed -e "s/.*://" | awk -F ' ' '{print $1 " "  $9}'))
#   echo ${PRE_ARY[0]} ${PRE_ARY[1]}
    sleep 1
    THIS_ARY=($($CATNET | grep $KEY | sed -e "s/.*://" | awk -F ' ' '{print $1 " "  $9}'))
    IN_BYTE=$((${THIS_ARY[0]} - ${PRE_ARY[0]}));    OUT_BYTE=$((${THIS_ARY[1]} - ${PRE_ARY[1]}))
    IN_BITPS=$((IN_BYTE * 8 / 1024));     OUT_BITPS=$((OUT_BYTE * 8 / 1024))
    IN_BYTEPS=$((IN_BYTE / 1024));    OUT_BYTEPS=$((OUT_BYTE / 1024))
    echo -e "$KEY - in: $IN_BITPS kbps  $IN_BYTEPS kB/s\tout: $OUT_BITPS kbps  $OUT_BYTEPS kB/s"
    PRE_ARY=($($CATNET | grep $KEY | sed -e "s/.*://" | awk -F ' ' '{print $1 " "  $9}'))  
}
while true
do 
  #  print_bps "lo"
    print_bps "eth0"
done
