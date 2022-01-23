#!/usr/bin/env bash
ALERT_THRESHOLD=90
s=($(df -h / | tail -1))
USAGE=${s[4]%*%}
(( $USAGE > $ALERT_THRESHOLD )) && /usr/local/bin/sendBartlettTelegram "WARNING: High space usage ($USAGE%)"
