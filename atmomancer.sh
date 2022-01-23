#!/bin/bash  

if [[ ! $heat ]]; then echo "Atmo Error?"; /root/tuyaudit.sh; fi
if [ ! -s terrarium.state ]; then printf "atmo: Empty state"; fi

# Binary to pass alert message to
alertmsgr="/usr/local/bin/sendBartlettTelegram"

NEW_STATE_FILE="terrarium.newstate.$$"

for L in `cat terrarium.state`; do
    VAR=`sed 's/=.*//' <<< $L`
    VAL=`sed 's/.*=//' <<< $L`
    
    if [[ $VAL != ${!VAR} ]]; then
        # ATTEMPTS=0
        # while [[ $ATTEMPS < 3 ]]; do
            #/usr/local/bin/tuya $VAR ${!VAR} &
	    (
	    	if [ "$(/usr/local/bin/tuya $VAR ${!VAR} 2>&1 | grep -i Error)" ]; then
			$alertmsgr "Tuya network error."
	      	fi
	    ) &
            
            # Only push datapoint on change
            # curl -s -XPOST --data-binary "terrarium $VAR=${!VAR}" localhost:8086/write?db=GeckOS 2>&1 > /dev/null
            
            # ((ATTEMPTS++))
        # done
    fi
    
    echo "$VAR=${!VAR}" >> "$NEW_STATE_FILE"
done

if [ -s $NEW_STATE_FILE ]; then
    mv $NEW_STATE_FILE terrarium.state
else
    printf "Debug: "
    cat terrarium.state
fi

VALS=`tr '\n' ',' < terrarium.state`

curl -s -XPOST --data-binary "terrarium ${VALS::-1}" localhost:8086/write?db=GeckOS 2>&1 > /dev/null

#$alertmsgr "`tr '\n' ' ' < terrarium.state` t:`printf "%.02f" $temperature` h:`printf "%.02f" $humidity`"
