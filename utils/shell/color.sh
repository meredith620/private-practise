#!/bin/bash  
T='gYw' # The test text  
echo  
echo  "        default  40m     41m     42m     43m     44m     45m     46m    47m"  
## FGs 为前景(foreground)色, BG 为背景(background)色  
for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m' '2;31m' '3;31m' '4;31m' '5;31m'
do  
   FG=$(echo $FGs|tr -d ' ')  
   echo -en " $FGs \033[$FG  $T  "  
   for BG in 40m 41m 42m 43m 44m 45m 46m 47m;  
   do  
      echo -en " \033[$FG\033[$BG  $T  \033[0m"  
   done  
   echo  
done 
