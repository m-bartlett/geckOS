#!/bin/bash
if [ "$(pidof -o %PPID -x $(basename $0))" ]; then echo "Mom script already running, dying..."; exit 1; fi

set -a # export everything that gets declared here as a safety mechanism

sensor_data=`./bme280.py`

#Read BME280 sensor, try to read it a few times if anything goes wrong 
declare -x `tr ',' ' ' <<< "$sensor_data"` # read sensor data, load it as read-only
# Read current $lamp $fan $mist $heat
### This is just to quickly load these values. They may get changed.
### Another module will determine if devices need toggled
if [ ! -s terrarium.state ]; then printf "State was empty so we'll get mom error 2: "; fi

source terrarium.state

# All of these should be set with proper values by here:
#   temperature, humidity, preassure, heat, lamp, fan, mist

if [ -z $temperature ]; then echo "Mom Error";   /root/tuyaudit.sh; exit; fi
if [ -z $heat ];        then echo "Mom Error 2"; /root/tuyaudit.sh; source terrarium.state; fi


#Record the data
curl -s -XPOST --data-binary "terrarium $sensor_data" localhost:8086/write?db=GeckOS >> /var/log/GeckOS 2>&1 &

# Round float values for arithmetic mode ease of use
humidity=${humidity%%.*}
temperature=${temperature%%.*}
heat=${heat%%.*}

#Check if data violates any thresholds
### Source the script to preserve its variables
source alert.sh

#Determine if any devices need to be toggled based on threshold violations
## Assumes heat,lamp,mist,fan preserved from alert script
./atmomancer.sh
