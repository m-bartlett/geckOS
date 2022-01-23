#!/bin/bash  

# ASSUMES $temperature $humidity AND $pressure ARE DECLARED IN THE ENV
if [[ ! $temperature ]]; then echo "Alert Error";   /root/tuyaudit.sh; exit; fi
if [[ ! $heat ]];        then echo "Alert Error 2"; /root/tuyaudit.sh; exit; fi

# H < 80, mist fan
# H > 85, x.      x

if (( $humidity < 80 )); then
    mist=1
    fan=1
elif (( $humidity > 87 )); then
    mist=0
    fan=0
fi

# T < 80, lamp heat
# T < 85, heat  x
# T > 90, x.       x
# T > 95, fan

if [[ $temperature < 84 ]]; then
    lamp=1
    heat=1
# elif [[ $temperature > 87 ]]; then
#     lamp=0
#     heat=1
elif [[ $temperature > 95 ]]; then
    heat=0
    lamp=0
    fan=1
elif [[ $temperature > 90 ]]; then
    heat=0
    lamp=0
else
    heat=1
    lamp=0
fi
