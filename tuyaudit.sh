#!/bin/bash
sed -e 's/[\}|\{|"]//g' -e 's/:/=/g' <<< `/usr/local/bin/tuya` | tr ',' '\n' > terrarium.state