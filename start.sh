#!/bin/bash

set -e

COMMAND=${1:-dump}
CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}
PREFIX=${PREFIX:-dump}
PGUSER=${PGUSER:-postgres}

if [[ "$COMMAND" == 'dump' ]]; then
    exec /dump.sh
elif [[ "$COMMAND" == 'dump-cron' ]]; then
    touch /var/log/cron.log
    CRON_ENV="PREFIX=$PREFIX\nPGUSER=$PGUSER"
    if [ -n "$PGPASSWORD" ]; then
        CRON_ENV="$CRON_ENV\nPGPASSWORD=$PGPASSWORD"
    fi
    echo -e "$CRON_ENV\n$CRON_SCHEDULE /dump.sh >> /var/log/cron.log 2>&1"
    echo -e "$CRON_ENV\n$CRON_SCHEDULE /dump.sh >> /var/log/cron.log 2>&1" | crontab -
    cron
    tail -f /var/log/cron.log
else
    echo "Unknown command $COMMAND"
    echo "Available commands: dump, dump-cron"
    exit 1
fi
